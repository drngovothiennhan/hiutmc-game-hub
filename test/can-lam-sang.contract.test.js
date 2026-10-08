import test from 'node:test';
import assert from 'node:assert/strict';
import { readFile } from 'node:fs/promises';
import {
  adaptLegacyCase,
  blockingDiagnosisChoices,
  hasWordBoundedMatch,
  sha256Hex
} from '../src/can-lam-sang/adapters/legacy-case-adapter.mjs';
import { createSeededRng, hash32 } from '../src/can-lam-sang/lib/seeded-rng.mjs';

const read = path => readFile(new URL(path, import.meta.url), 'utf8');
const BLOCKING_GROUPS = new Set(['ydx', 'bd', 'bc', 'the']);

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

function normalizeExact(value) {
  return String(value ?? '').normalize('NFC').toLocaleLowerCase('vi-VN').replace(/\s+/g, ' ').trim();
}

function stripAccents(value) {
  return normalizeExact(value)
    .replace(/đ/g, 'd')
    .normalize('NFD')
    .replace(/[\u0300-\u036f]/g, '');
}

function isWordChar(value) {
  return typeof value === 'string' && value.length > 0 && /[\\p{L}\\p{N}_]/u.test(value);
}

function hasWordBoundedAccentlessMatch(value, choice) {
  const haystack = stripAccents(value);
  const needle = stripAccents(choice);
  if (needle.length <= 5) return false;
  let index = haystack.indexOf(needle);
  while (index >= 0) {
    const before = index === 0 ? '' : haystack[index - 1];
    const end = index + needle.length;
    const after = end >= haystack.length ? '' : haystack[end];
    if (!isWordChar(before) && !isWordChar(after)) return true;
    index = haystack.indexOf(needle, index + 1);
  }
  return false;
}

function publicClinicalStrings(bundle) {
  const out = [
    { path: 'title', value: bundle.title },
    { path: 'presentation.intro', value: bundle.presentation?.intro }
  ];
  (bundle.history || []).forEach((item, index) => {
    out.push({ path: `history[${index}].question`, value: item.question });
    out.push({ path: `history[${index}].response`, value: item.response });
  });
  (bundle.examination || []).forEach((item, index) => {
    out.push({ path: `examination[${index}].group`, value: item.group });
    out.push({ path: `examination[${index}].item`, value: item.item });
    out.push({ path: `examination[${index}].finding`, value: item.finding });
  });
  (bundle.investigations || []).forEach((item, index) => {
    out.push({ path: `investigations[${index}].name`, value: item.name });
    out.push({ path: `investigations[${index}].result`, value: item.result });
  });
  return out;
}

function schemaTypeMatches(value, type) {
  if (Array.isArray(type)) return type.some(one => schemaTypeMatches(value, one));
  if (type === 'null') return value === null;
  if (type === 'array') return Array.isArray(value);
  if (type === 'object') return value !== null && typeof value === 'object' && !Array.isArray(value);
  if (type === 'integer') return Number.isInteger(value);
  if (type === 'number') return typeof value === 'number' && Number.isFinite(value);
  return typeof value === type;
}

function pointer(root, fragment) {
  if (!fragment || fragment === '#') return root;
  assert.ok(fragment.startsWith('#/'), `unsupported schema pointer: ${fragment}`);
  return fragment.slice(2).split('/').reduce((node, raw) => {
    const key = raw.replace(/~1/g, '/').replace(/~0/g, '~');
    assert.ok(node && Object.hasOwn(node, key), `schema pointer not found: ${fragment}`);
    return node[key];
  }, root);
}

function resolveRef(ref, currentRoot, schemas) {
  const [file, fragment = ''] = ref.split('#');
  const root = file ? schemas.get(file) : currentRoot;
  assert.ok(root, `schema ref not loaded: ${ref}`);
  return { schema: pointer(root, fragment ? `#${fragment}` : '#'), root };
}

function validateSchema(value, schema, { schemas, root = schema, path = '$' } = {}) {
  if (schema.$ref) {
    const resolved = resolveRef(schema.$ref, root, schemas);
    return validateSchema(value, resolved.schema, { schemas, root: resolved.root, path });
  }
  if (Object.hasOwn(schema, 'const')) assert.deepEqual(value, schema.const, `${path}: const mismatch`);
  if (schema.enum) assert.ok(schema.enum.some(item => Object.is(item, value)), `${path}: not in enum`);
  if (schema.type) assert.ok(schemaTypeMatches(value, schema.type), `${path}: type mismatch`);

  if (typeof value === 'string') {
    if (schema.minLength != null) assert.ok(value.length >= schema.minLength, `${path}: minLength`);
    if (schema.pattern) assert.match(value, new RegExp(schema.pattern), `${path}: pattern`);
  }
  if (typeof value === 'number' && Number.isFinite(value)) {
    if (schema.minimum != null) assert.ok(value >= schema.minimum, `${path}: minimum`);
    if (schema.maximum != null) assert.ok(value <= schema.maximum, `${path}: maximum`);
  }
  if (Array.isArray(value)) {
    if (schema.items) value.forEach((item, index) => validateSchema(item, schema.items, { schemas, root, path: `${path}[${index}]` }));
    if (schema.uniqueItems) assert.equal(new Set(value.map(item => JSON.stringify(item))).size, value.length, `${path}: uniqueItems`);
  }
  if (value !== null && typeof value === 'object' && !Array.isArray(value)) {
    for (const key of schema.required || []) assert.ok(Object.hasOwn(value, key), `${path}: missing required ${key}`);
    if (schema.additionalProperties === false) {
      const allowed = new Set(Object.keys(schema.properties || {}));
      for (const key of Object.keys(value)) assert.ok(allowed.has(key), `${path}: additional property ${key}`);
    }
    for (const [key, childSchema] of Object.entries(schema.properties || {})) {
      if (Object.hasOwn(value, key)) validateSchema(value[key], childSchema, { schemas, root, path: `${path}.${key}` });
    }
  }
  return true;
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

function getLegacyPath(caseItem, path) {
  const match = /^investigations\[(\d+)\]\.(name|result)$/.exec(path);
  assert.ok(match, `unsupported test path ${path}`);
  const row = caseItem.tests[Number(match[1])];
  return row[match[2] === 'name' ? 0 : 2];
}

function getPublicPath(bundle, path) {
  const match = /^investigations\[(\d+)\]\.(name|result)$/.exec(path);
  assert.ok(match, `unsupported test path ${path}`);
  return bundle.investigations[Number(match[1])][match[2]];
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
    assert.ok(!Object.hasOwn(public_bundle, 'resources'));
  }
});

test('D1 masks title only for full/partial diagnosis or pattern groups using exact accents and word boundaries', async () => {
  const bank = await readLegacyBank();
  const touched = [];
  for (const legacy of bank) {
    const { public_bundle, answer_key } = adaptLegacyCase(legacy);
    const protectedChoices = blockingDiagnosisChoices(answer_key.diagnosis_options);
    assert.ok(protectedChoices.every(choice => BLOCKING_GROUPS.has(choice.group)));
    const shouldMask = protectedChoices.some(choice => hasWordBoundedMatch(legacy.title, choice.text));
    if (shouldMask) {
      touched.push(legacy.id);
      assert.equal(public_bundle.title, `Ca bệnh ${legacy.id}`);
      assert.equal(answer_key.title_reveal, legacy.title);
    } else {
      assert.equal(public_bundle.title, legacy.title);
      assert.equal(answer_key.title_reveal, null);
    }
  }
  assert.ok(touched.includes('noi-than-005'), 'known F1 case noi-than-005 must be masked');
  assert.equal(hasWordBoundedMatch('ứ huyết hai bên', 'Huyết hải'), false);
});

test('Public bundle is whitelist-only and contains no legacy answer keys, source metadata, or answer-marker prefixes', async () => {
  const bank = await readLegacyBank();
  const bannedKeys = new Set(['opt','teach','answer_key','resources','resources_after_submission','after_submission_notes','title_reveal','diagnosis_options','action_options']);
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

test('F2 keeps all legacy resources server-only after submission with unverified review metadata', async () => {
  const bank = await readLegacyBank();
  const registry = JSON.parse(await read('../data/nguon-registry.json'));
  assert.equal(registry.muc.length, 105);
  let resourceCount = 0;
  for (const legacy of bank) {
    const { public_bundle, answer_key } = adaptLegacyCase(legacy);
    assert.ok(!Object.hasOwn(public_bundle, 'resources'));
    for (const resource of answer_key.resources_after_submission) {
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

test('D4 validates all 156 public bundles and answer keys against their schemas', async () => {
  const [publicSchema, answerSchema, resourceSchema, bank] = await Promise.all([
    read('../schemas/can-lam-sang/case-bundle.v1.schema.json').then(JSON.parse),
    read('../schemas/can-lam-sang/answer-key.v1.schema.json').then(JSON.parse),
    read('../schemas/can-lam-sang/resource.v1.schema.json').then(JSON.parse),
    readLegacyBank()
  ]);
  const schemas = new Map([
    ['case-bundle.v1.schema.json', publicSchema],
    ['answer-key.v1.schema.json', answerSchema],
    ['resource.v1.schema.json', resourceSchema]
  ]);
  assert.equal(bank.length, 156);
  for (const legacy of bank) {
    const { public_bundle, answer_key } = adaptLegacyCase(legacy);
    validateSchema(public_bundle, publicSchema, { schemas });
    validateSchema(answer_key, answerSchema, { schemas });
  }
});

test('F3 schema validator rejects an unknown public bundle key when additionalProperties is false', async () => {
  const [publicSchema, resourceSchema, bank] = await Promise.all([
    read('../schemas/can-lam-sang/case-bundle.v1.schema.json').then(JSON.parse),
    read('../schemas/can-lam-sang/resource.v1.schema.json').then(JSON.parse),
    readLegacyBank()
  ]);
  const schemas = new Map([
    ['case-bundle.v1.schema.json', publicSchema],
    ['resource.v1.schema.json', resourceSchema]
  ]);
  const { public_bundle } = adaptLegacyCase(bank[0]);
  assert.throws(
    () => validateSchema({ ...public_bundle, unexpected_answer_hint: true }, publicSchema, { schemas }),
    /additional property unexpected_answer_hint/
  );
});

test('D1 has zero blocking diagnosis leaks after overrides; accent-stripped matches are warnings only', async (t) => {
  const bank = await readLegacyBank();
  const violations = [];
  const warnings = [];
  for (const legacy of bank) {
    const { public_bundle, answer_key } = adaptLegacyCase(legacy);
    const choices = blockingDiagnosisChoices(answer_key.diagnosis_options);
    for (const field of publicClinicalStrings(public_bundle)) {
      for (const choice of choices) {
        if (hasWordBoundedMatch(field.value, choice.text)) {
          violations.push({ case_id: legacy.id, field: field.path, group: choice.group, choice: choice.text, excerpt: field.value });
        } else if (hasWordBoundedAccentlessMatch(field.value, choice.text)) {
          warnings.push({ case_id: legacy.id, field: field.path, group: choice.group, choice: choice.text, excerpt: field.value });
        }
      }
    }
  }
  for (const warning of warnings) t.diagnostic('accentless-only warning: ' + JSON.stringify(warning));
  assert.deepEqual(violations, []);
});

test('D4 override schema is valid and every override only deletes content or moves the whole original server-side', async () => {
  const [config, schema, bank] = await Promise.all([
    read('../data/can-lam-sang/legacy-content-overrides.json').then(JSON.parse),
    read('../schemas/can-lam-sang/legacy-content-overrides.v1.schema.json').then(JSON.parse),
    readLegacyBank()
  ]);
  const schemas = new Map([['legacy-content-overrides.v1.schema.json', schema]]);
  validateSchema(config, schema, { schemas });
  assert.equal(config.overrides.length, 4);

  for (const override of config.overrides) {
    const legacy = bank.find(item => item.id === override.case_id);
    assert.ok(legacy, override.case_id + ': case missing');
    const original = getLegacyPath(legacy, override.path);
    assert.equal(sha256Hex(original), override.original_sha256);
    const { public_bundle, answer_key } = adaptLegacyCase(legacy);
    const result = getPublicPath(public_bundle, override.path);
    assert.ok(result.length <= original.length, override.case_id + ': override lengthened content');

    if (override.op === 'move_to_after_submission') {
      assert.equal(result, '');
      assert.ok(answer_key.after_submission_notes.some(note => note.path === override.path && note.text === original));
    } else {
      assert.equal(override.op, 'remove_substring');
      assert.equal(result, original.replace(override.remove_substring, ''));
      assert.notEqual(result, original);
      assert.ok(!answer_key.after_submission_notes.some(note => note.path === override.path));
    }
  }
});

test('D4 negative: modifying an override target makes adapter fail closed on sha256 mismatch', async () => {
  const [config, bank] = await Promise.all([
    read('../data/can-lam-sang/legacy-content-overrides.json').then(JSON.parse),
    readLegacyBank()
  ]);
  const override = config.overrides[0];
  const legacy = structuredClone(bank.find(item => item.id === override.case_id));
  const match = /^investigations\[(\d+)\]\.(name|result)$/.exec(override.path);
  const row = legacy.tests[Number(match[1])];
  const slot = match[2] === 'name' ? 0 : 2;
  row[slot] = row[slot] + ' thay đổi';
  assert.throws(() => adaptLegacyCase(legacy), /override sha256 mismatch/);
});

test('Adapter rejects every non-finite or non-number required legacy vital', async () => {
  const [legacy] = await readLegacyBank();
  for (const key of ['hr', 'sbp', 'dbp', 'rr', 't', 'spo2']) {
    for (const invalid of [NaN, Infinity, -Infinity, '37', null, undefined]) {
      const bad = { ...legacy, vitals: { ...legacy.vitals, [key]: invalid } };
      assert.throws(() => adaptLegacyCase(bad), new RegExp(`vital ${key} must be a finite number`));
    }
  }
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
