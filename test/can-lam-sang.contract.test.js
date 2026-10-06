import test from 'node:test';
import assert from 'node:assert/strict';
import { readFile } from 'node:fs/promises';
import { adaptLegacyCase } from '../src/can-lam-sang/adapters/legacy-case-adapter.mjs';
import { createSeededRng, hash32 } from '../src/can-lam-sang/lib/seeded-rng.mjs';

const read = path => readFile(new URL(path, import.meta.url), 'utf8');

async function readLegacyBank() {
  const html = await read('../public/tu-chan/index.html');
  const match = html.match(/id="bank-data">([\s\S]*?)<\/script>/);
  assert.ok(match, 'legacy bank-data missing');
  return JSON.parse(match[1]);
}

function walk(value, visit, path = '$') {
  visit(value, path);
  if (Array.isArray(value)) value.forEach((item, i) => walk(item, visit, `${path}[${i}]`));
  else if (value && typeof value === 'object') {
    for (const [key, item] of Object.entries(value)) walk(item, visit, `${path}.${key}`);
  }
}

function approvalGateFromSchema(schema, resource) {
  const gate = schema.allOf.find(item => item?.if?.properties?.review_status?.const === 'DA_DUYET');
  assert.ok(gate, 'resource schema missing DA_DUYET gate');
  if (resource.review_status !== 'DA_DUYET') return true;
  for (const [key, rule] of Object.entries(gate.then.properties)) {
    const value = resource[key];
    if (rule.type === 'string' && (typeof value !== 'string' || value.trim().length < (rule.minLength || 0))) return false;
  }
  return true;
}

test('Step 1A converts all 156 legacy cases into public bundle + server-only answer key', async () => {
  const bank = await readLegacyBank();
  assert.equal(bank.length, 156);
  for (const legacy of bank) {
    const { public_bundle, answer_key } = adaptLegacyCase(legacy);
    assert.equal(public_bundle.case_id, legacy.id);
    assert.equal(answer_key.case_id, legacy.id);
    assert.equal(answer_key.server_only, true);
    assert.equal(public_bundle.data_origin, 'synthetic');
    assert.equal(public_bundle.review_status, 'CHUA_DUYET');
  }
});

test('Public bundle is whitelist-only and contains no legacy answer keys or answer-marker prefixes', async () => {
  const bank = await readLegacyBank();
  const bannedKeys = new Set(['opt','actions','teach','answer_key']);
  const answerMarker = /^(?:\+\+|\+|~|-|!)(?=\S)/;
  for (const legacy of bank) {
    const { public_bundle } = adaptLegacyCase(legacy);
    walk(public_bundle, (value, path) => {
      if (value && typeof value === 'object' && !Array.isArray(value)) {
        for (const key of Object.keys(value)) assert.ok(!bannedKeys.has(key), `${legacy.id}: banned key ${key} at ${path}`);
      }
      if (typeof value === 'string') assert.ok(!answerMarker.test(value), `${legacy.id}: answer marker leaked at ${path}`);
    });
  }
});

test('All legacy resources stay CHUA_DUYET and are tagged legacy_unverified; registry still has 105 entries', async () => {
  const bank = await readLegacyBank();
  const registry = JSON.parse(await read('../data/nguon-registry.json'));
  assert.equal(registry.muc.length, 105);
  let resourceCount = 0;
  for (const legacy of bank) {
    const { public_bundle } = adaptLegacyCase(legacy);
    for (const resource of public_bundle.resources) {
      resourceCount += 1;
      assert.equal(resource.review_status, 'CHUA_DUYET');
      assert.ok(resource.provenance_tags.includes('legacy_unverified'));
      assert.equal(resource.reviewer, null);
      assert.equal(resource.license, null);
    }
  }
  assert.ok(resourceCount > 0, 'expected mapped legacy resources');
});

test('Resource schema makes reviewer and license mandatory before DA_DUYET', async () => {
  const schema = JSON.parse(await read('../schemas/can-lam-sang/resource.v1.schema.json'));
  const base = {
    schema_version: '1.0.0',
    resource_id: 'resource-approved-example',
    resource_type: 'guideline',
    source: 'https://example.invalid/resource',
    title: 'Example',
    organization: 'Example Organization',
    year_version: '2026',
    citation: 'Example citation',
    checked_date: '2026-10-06',
    reviewer: 'Reviewer',
    review_status: 'DA_DUYET',
    license: 'CC-BY-4.0',
    provenance_tags: []
  };
  assert.equal(approvalGateFromSchema(schema, base), true);
  assert.equal(approvalGateFromSchema(schema, { ...base, reviewer: null }), false);
  assert.equal(approvalGateFromSchema(schema, { ...base, license: null }), false);
  assert.equal(approvalGateFromSchema(schema, { ...base, reviewer: '' }), false);
  assert.equal(approvalGateFromSchema(schema, { ...base, license: '' }), false);
});

test('Seeded RNG is deterministic and has a golden sequence for case_id + module + schema_version', () => {
  const input = { caseId: 'chan-tam-thong', module: 'cbc', schemaVersion: '1.0.0' };
  assert.equal(hash32('chan-tam-thong\u001fcbc\u001f1.0.0'), 3353939940);
  const a = createSeededRng(input);
  const b = createSeededRng(input);
  const seqA = Array.from({ length: 5 }, () => a().toFixed(12));
  const seqB = Array.from({ length: 5 }, () => b().toFixed(12));
  assert.deepEqual(seqA, seqB);
  assert.deepEqual(seqA, [
    '0.483934359392',
    '0.432240774157',
    '0.388367964420',
    '0.423109231750',
    '0.501698970096'
  ]);
  const other = createSeededRng({ ...input, module: 'ecg_monitor' });
  assert.notEqual(other().toFixed(12), seqA[0]);
});

test('Seeded generator implementation never calls unseeded random APIs', async () => {
  const source = await read('../src/can-lam-sang/lib/seeded-rng.mjs');
  assert.doesNotMatch(source, /Math\.random/);
  assert.doesNotMatch(source, /ORDER\s+BY\s+random\s*\(/i);
});

test('Every converted bundle has data_origin and review_status allowed by the public schema', async () => {
  const schema = JSON.parse(await read('../schemas/can-lam-sang/case-bundle.v1.schema.json'));
  const allowedOrigins = new Set(schema.properties.data_origin.enum);
  const allowedReview = new Set(schema.properties.review_status.enum);
  const bank = await readLegacyBank();
  for (const legacy of bank) {
    const { public_bundle } = adaptLegacyCase(legacy);
    assert.ok(allowedOrigins.has(public_bundle.data_origin), legacy.id + ' missing/invalid data_origin');
    assert.ok(allowedReview.has(public_bundle.review_status), legacy.id + ' missing/invalid review_status');
  }
});
