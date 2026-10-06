import { mkdir, readFile, rm, writeFile } from 'node:fs/promises';
import { resolve, dirname, join } from 'node:path';
import { fileURLToPath } from 'node:url';
import {
  adaptLegacyCase,
  sha256Hex
} from '../../../src/can-lam-sang/adapters/legacy-case-adapter.mjs';

const here = dirname(fileURLToPath(import.meta.url));
const repoRoot = resolve(here, '../../..');
const bankPath = resolve(repoRoot, 'public/tu-chan/index.html');
const defaultOutputDir = resolve(repoRoot, 'build/can-lam-sang/seed');

function parseArgs(argv) {
  let outputDir = defaultOutputDir;
  let chunkSize = 20;
  let sqlMode = false;

  for (let i = 0; i < argv.length; i += 1) {
    const arg = argv[i];
    if (arg === '--sql') {
      sqlMode = true;
      outputDir = resolve(repoRoot, 'supabase/proposed/can-lam-sang/seed');
    } else if (arg === '--output-dir') {
      outputDir = resolve(argv[++i]);
    } else if (arg === '--chunk-size') {
      chunkSize = Number(argv[++i]);
    } else {
      throw new Error(`unknown argument: ${arg}`);
    }
  }

  if (!Number.isInteger(chunkSize) || chunkSize < 1 || chunkSize > 156) {
    throw new Error('--chunk-size must be an integer from 1 to 156');
  }

  return { outputDir, chunkSize, sqlMode };
}

function sqlText(value) {
  return "'" + String(value).replaceAll("'", "''") + "'";
}

function sqlNullableText(value) {
  return value == null ? 'null' : sqlText(value);
}

function sqlDate(value) {
  return value == null ? 'null' : sqlText(value) + '::date';
}

function sqlTextArray(values) {
  const items = Array.isArray(values) ? values : [];
  return items.length === 0
    ? "'{}'::text[]"
    : 'array[' + items.map(sqlText).join(', ') + ']::text[]';
}

function jsonbLiteral(value) {
  return sqlText(JSON.stringify(value)) + '::jsonb';
}

function resourceContent(resource) {
  return JSON.stringify(resource);
}

function sizeSummary(name, text, extra = {}) {
  const bytes = Buffer.byteLength(text, 'utf8');
  return {
    name,
    bytes,
    kb: Number((bytes / 1024).toFixed(2)),
    ...extra
  };
}

function resourceSql(resource) {
  return [
    'insert into can_lam_sang_private.resources (',
    '  resource_id, schema_version, resource_type, source, title,',
    '  organization, year_version, citation, checked_date, reviewer,',
    '  review_status, license, provenance_tags',
    ') values (',
    `  ${sqlText(resource.resource_id)},`,
    `  ${sqlText(resource.schema_version)},`,
    `  ${sqlText(resource.resource_type)},`,
    `  ${sqlText(resource.source)},`,
    `  ${sqlText(resource.title)},`,
    `  ${sqlNullableText(resource.organization)},`,
    `  ${sqlNullableText(resource.year_version)},`,
    `  ${sqlText(resource.citation)},`,
    `  ${sqlDate(resource.checked_date)},`,
    `  ${sqlNullableText(resource.reviewer)},`,
    `  ${sqlText(resource.review_status)},`,
    `  ${sqlNullableText(resource.license)},`,
    `  ${sqlTextArray(resource.provenance_tags)}`,
    ')',
    'on conflict (resource_id) do update set',
    '  schema_version = excluded.schema_version,',
    '  resource_type = excluded.resource_type,',
    '  source = excluded.source,',
    '  title = excluded.title,',
    '  organization = excluded.organization,',
    '  year_version = excluded.year_version,',
    '  citation = excluded.citation,',
    '  checked_date = excluded.checked_date,',
    '  reviewer = excluded.reviewer,',
    '  review_status = excluded.review_status,',
    '  license = excluded.license,',
    '  provenance_tags = excluded.provenance_tags;',
    ''
  ].join('\n');
}

function caseSql(publicBundle, answerKey) {
  const publicContent = JSON.stringify(publicBundle);
  const answerContent = JSON.stringify(answerKey);

  return [
    'insert into can_lam_sang_private.case_bundles',
    '  (case_id, schema_version, data_origin, review_status, public_bundle, content_sha256)',
    'values (',
    `  ${sqlText(publicBundle.case_id)},`,
    `  ${sqlText(publicBundle.schema_version)},`,
    `  ${sqlText(publicBundle.data_origin)},`,
    `  ${sqlText(publicBundle.review_status)},`,
    `  ${jsonbLiteral(publicBundle)},`,
    `  ${sqlText(sha256Hex(publicContent))}`,
    ')',
    'on conflict (case_id) do update set',
    '  schema_version = excluded.schema_version,',
    '  data_origin = excluded.data_origin,',
    '  review_status = excluded.review_status,',
    '  public_bundle = excluded.public_bundle,',
    '  content_sha256 = excluded.content_sha256;',
    '',
    'insert into can_lam_sang_private.answer_keys',
    '  (case_id, answer_key, content_sha256)',
    'values (',
    `  ${sqlText(answerKey.case_id)},`,
    `  ${jsonbLiteral(answerKey)},`,
    `  ${sqlText(sha256Hex(answerContent))}`,
    ')',
    'on conflict (case_id) do update set',
    '  answer_key = excluded.answer_key,',
    '  content_sha256 = excluded.content_sha256;',
    ''
  ].join('\n');
}

const { outputDir, chunkSize, sqlMode } = parseArgs(process.argv.slice(2));
const html = await readFile(bankPath, 'utf8');
const match = html.match(/id="bank-data">([\s\S]*?)<\/script>/);
if (!match) throw new Error('legacy bank-data missing');

const bank = JSON.parse(match[1]);
if (bank.length !== 156) {
  throw new Error(`expected 156 legacy cases, got ${bank.length}`);
}

const adapted = bank.map(adaptLegacyCase);
const variantsByBaseId = new Map();

for (const { answer_key } of adapted) {
  for (const resource of answer_key.resources_after_submission || []) {
    const baseId = resource.resource_id;
    const content = resourceContent(resource);
    if (!variantsByBaseId.has(baseId)) variantsByBaseId.set(baseId, new Map());
    variantsByBaseId.get(baseId).set(content, resource);
  }
}

const resourceIdByContent = new Map();
const resourceMap = new Map();
let resourceIdCollisions = 0;

for (const [baseId, variants] of variantsByBaseId) {
  const entries = [...variants.entries()].sort(([a], [b]) => a.localeCompare(b));
  if (entries.length > 1) resourceIdCollisions += 1;

  for (const [content, resource] of entries) {
    const resourceId = entries.length === 1
      ? baseId
      : `${baseId}-${sha256Hex(content).slice(0, 12)}`;
    const normalized = { ...resource, resource_id: resourceId };
    resourceIdByContent.set(baseId + '\u001f' + content, resourceId);
    resourceMap.set(resourceId, normalized);
  }
}

const normalized = adapted.map(({ public_bundle, answer_key }) => ({
  public_bundle,
  answer_key: {
    ...answer_key,
    resources_after_submission: (answer_key.resources_after_submission || []).map(resource => {
      const content = resourceContent(resource);
      const resourceId = resourceIdByContent.get(resource.resource_id + '\u001f' + content);
      if (!resourceId) throw new Error(`resource normalization missing: ${resource.resource_id}`);
      return { ...resource, resource_id: resourceId };
    })
  }
}));

await rm(outputDir, { recursive: true, force: true });
await mkdir(outputDir, { recursive: true });

const files = [];
const resourcesName = '000_resources.sql';
const resourcesText = [
  'begin;',
  '',
  '-- Resources run before case chunks. This file does not modify runtime flags.',
  ...[...resourceMap.values()]
    .sort((a, b) => a.resource_id.localeCompare(b.resource_id))
    .map(resourceSql),
  'commit;',
  ''
].join('\n');
await writeFile(join(outputDir, resourcesName), resourcesText, 'utf8');
files.push(sizeSummary(resourcesName, resourcesText, { kind: 'resources', resources: resourceMap.size }));

const allCaseSql = [
  'begin;',
  '',
  '-- Idempotent core case/answer-key seed. Never set DA_DUYET.',
  ...normalized.map(({ public_bundle, answer_key }) => caseSql(public_bundle, answer_key)),
  'commit;',
  ''
].join('\\n');

if (sqlMode) {
  const totalBytes = Buffer.byteLength(allCaseSql, 'utf8');
  if (totalBytes <= 400 * 1024) {
    const name = 'core-cases-seed.sql';
    await writeFile(join(outputDir, name), allCaseSql, 'utf8');
    files.push(sizeSummary(name, allCaseSql, { kind: 'cases', cases: normalized.length }));
  } else {
    const letters = 'ABCDEFGH';
    if (normalized.length > 160) throw new Error('core SQL mode supports at most 160 cases');
    for (let batch = 0, start = 0; start < normalized.length; batch += 1) {
      const rows = normalized.slice(start, start + 20);
      const text = [
        'begin;',
        '',
        '-- Idempotent core case/answer-key seed. Never set DA_DUYET.',
        ...rows.map(({ public_bundle, answer_key }) => caseSql(public_bundle, answer_key)),
        'commit;',
        ''
      ].join('\\n');
      const name = `seed-core-${letters[batch]}.sql`;
      await writeFile(join(outputDir, name), text, 'utf8');
      files.push(sizeSummary(name, text, { kind: 'cases', cases: rows.length, first_case: rows[0].public_bundle.case_id, last_case: rows.at(-1).public_bundle.case_id }));
      start += rows.length;
    }
  }
} else {
  for (let start = 0, chunk = 1; start < normalized.length; start += chunkSize, chunk += 1) {
    const rows = normalized.slice(start, start + chunkSize);
    const first = String(start + 1).padStart(3, '0');
    const last = String(start + rows.length).padStart(3, '0');
    const name = `${String(chunk).padStart(3, '0')}_cases_${first}-${last}.sql`;
    const text = [
      'begin;',
      '',
      '-- Idempotent case/answer-key seed. This file does not modify runtime flags.',
      ...rows.map(({ public_bundle, answer_key }) => caseSql(public_bundle, answer_key)),
      'commit;',
      ''
    ].join('\\n');
    await writeFile(join(outputDir, name), text, 'utf8');
    files.push(sizeSummary(name, text, { kind: 'cases', cases: rows.length, first_case: rows[0].public_bundle.case_id, last_case: rows.at(-1).public_bundle.case_id }));
  }
}

console.log(JSON.stringify({
  output_dir: outputDir,
  chunk_size: chunkSize,
  cases: normalized.length,
  resources: resourceMap.size,
  resource_id_collisions: resourceIdCollisions,
  files
}));
