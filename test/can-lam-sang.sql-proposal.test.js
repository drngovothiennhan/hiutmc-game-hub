import test from 'node:test';
import assert from 'node:assert/strict';
import { execFile } from 'node:child_process';
import { mkdtemp, readFile, rm } from 'node:fs/promises';
import { tmpdir } from 'node:os';
import { join } from 'node:path';
import { promisify } from 'node:util';

const execFileAsync = promisify(execFile);
const read = path => readFile(new URL(path, import.meta.url), 'utf8');

const paths = {
  foundation: '../supabase/proposed/can-lam-sang/001_cls_foundation.sql',
  rpc: '../supabase/proposed/can-lam-sang/002_cls_rpc.sql',
  rollback: '../supabase/proposed/can-lam-sang/003_cls_rollback.sql',
  generator: new URL('../supabase/proposed/can-lam-sang/004_cls_seed_generator.mjs', import.meta.url)
};

function normalizeSql(sql) {
  return sql
    .replace(/--.*$/gm, '')
    .replace(/\s+/g, ' ')
    .trim();
}

function createdTables(sql) {
  return [...sql.matchAll(
    /create\s+table\s+if\s+not\s+exists\s+can_lam_sang_private\.([a-z0-9_]+)/gi
  )].map(match => match[1]);
}

function functionBlocks(sql) {
  const matches = [...sql.matchAll(
    /create\s+or\s+replace\s+function\s+public\.(cls_[a-z0-9_]+_v1)\s*\([^)]*\)[\s\S]*?\$function\$;/gi
  )];
  return matches.map(match => ({ name: match[1], text: match[0] }));
}

test('Step 1B proposal creates exactly five private tables and enables RLS on every one', async () => {
  const foundation = await read(paths.foundation);
  const tables = createdTables(foundation);
  assert.deepEqual(tables.sort(), [
    'answer_keys',
    'case_bundles',
    'feature_flags',
    'resources',
    'submissions'
  ]);

  for (const table of tables) {
    assert.match(
      foundation,
      new RegExp(
        `alter\\s+table\\s+can_lam_sang_private\\.${table}\\s+enable\\s+row\\s+level\\s+security`,
        'i'
      ),
      `${table}: RLS must be enabled`
    );
  }
});

test('Step 1B proposal revokes direct schema/table access and never grants anon', async () => {
  const [foundation, rpc] = await Promise.all([
    read(paths.foundation),
    read(paths.rpc)
  ]);
  const sql = foundation + '\n' + rpc;

  assert.match(
    foundation,
    /revoke\s+all\s+on\s+schema\s+can_lam_sang_private\s+from\s+public\s*,\s*anon\s*,\s*authenticated/i
  );
  assert.match(
    foundation,
    /revoke\s+all\s+on\s+all\s+tables\s+in\s+schema\s+can_lam_sang_private\s+from\s+public\s*,\s*anon\s*,\s*authenticated/i
  );
  assert.doesNotMatch(sql, /grant\s+[^;]+\s+to\s+[^;]*\banon\b/i);
  assert.doesNotMatch(sql, /create\s+policy\b/i);
});

test('Every Step 1B RPC is SECURITY DEFINER with an empty search_path and authenticated-only execute', async () => {
  const rpc = await read(paths.rpc);
  const blocks = functionBlocks(rpc);
  assert.deepEqual(blocks.map(item => item.name).sort(), [
    'cls_flag_status_v1',
    'cls_get_case_v1',
    'cls_submit_v1'
  ]);

  for (const block of blocks) {
    assert.match(block.text, /security\s+definer/i, block.name);
    assert.match(block.text, /set\s+search_path\s*=\s*''/i, block.name);
  }

  for (const signature of [
    'public.cls_flag_status_v1\\(\\)',
    'public.cls_get_case_v1\\(text\\)',
    'public.cls_submit_v1\\(text,\\s*text,\\s*jsonb\\)'
  ]) {
    assert.match(
      rpc,
      new RegExp(
        `revoke\\s+all\\s+on\\s+function\\s+${signature}\\s+from\\s+public\\s*,\\s*anon\\s*,\\s*authenticated`,
        'i'
      )
    );
    assert.match(
      rpc,
      new RegExp(
        `grant\\s+execute\\s+on\\s+function\\s+${signature}\\s+to\\s+authenticated`,
        'i'
      )
    );
  }
});

test('R1/A5 ordering is visible statically: flag first, submission write before answer-key read', async () => {
  const rpc = normalizeSql(await read(paths.rpc));

  const getCaseStart = rpc.indexOf('create or replace function public.cls_get_case_v1');
  const submitStart = rpc.indexOf('create or replace function public.cls_submit_v1');
  const getCase = rpc.slice(getCaseStart, submitStart);
  const submit = rpc.slice(submitStart);

  assert.ok(
    getCase.indexOf('from can_lam_sang_private.feature_flags')
      < getCase.indexOf('from can_lam_sang_private.case_bundles'),
    'cls_get_case_v1 must check feature flag before reading the case'
  );

  assert.ok(
    submit.indexOf('from can_lam_sang_private.feature_flags')
      < submit.indexOf('insert into can_lam_sang_private.submissions'),
    'cls_submit_v1 must check feature flag before writing'
  );

  assert.ok(
    submit.indexOf('insert into can_lam_sang_private.submissions')
      < submit.indexOf('from can_lam_sang_private.answer_keys'),
    'answer key must be read only after successful submission insert'
  );
});

test('Proposed SQL does not mutate legacy schemas or tables outside can_lam_sang_private', async () => {
  const [foundation, rpc, rollback] = await Promise.all([
    read(paths.foundation),
    read(paths.rpc),
    read(paths.rollback)
  ]);
  const all = foundation + '\n' + rpc + '\n' + rollback;

  assert.doesNotMatch(
    all,
    /\b(?:alter|drop|update|delete\s+from)\s+(?:table\s+)?y_quan_private\b/i
  );

  for (const match of all.matchAll(
    /\b(?:alter|drop)\s+table\s+(?:if\s+exists\s+)?([a-z0-9_]+)\.([a-z0-9_]+)/gi
  )) {
    assert.equal(match[1].toLowerCase(), 'can_lam_sang_private');
  }
});

test('Rollback is scoped to the CLS private schema plus exactly the three public RPC wrappers', async () => {
  const rollback = normalizeSql(await read(paths.rollback));

  const publicRefs = [...rollback.matchAll(/\bpublic\.([a-z0-9_]+)/gi)]
    .map(match => match[1])
    .sort();
  assert.deepEqual(publicRefs, [
    'cls_flag_status_v1',
    'cls_get_case_v1',
    'cls_submit_v1'
  ]);

  const schemaRefs = [...rollback.matchAll(/\b([a-z_][a-z0-9_]*)\./gi)]
    .map(match => match[1].toLowerCase())
    .filter(name => name !== 'public');
  assert.ok(
    schemaRefs.every(name => name === 'can_lam_sang_private'),
    'rollback must not reference any other data schema'
  );

  assert.match(
    rollback,
    /drop\s+schema\s+if\s+exists\s+can_lam_sang_private\s+cascade/i
  );
});

test('Seed generator produces 156 case and answer inserts in a temporary file with flag disabled', async () => {
  const dir = await mkdtemp(join(tmpdir(), 'cls-seed-'));
  const out = join(dir, 'seed.sql');

  try {
    const { stdout } = await execFileAsync(
      process.execPath,
      [paths.generator.pathname, out],
      { encoding: 'utf8' }
    );
    const summary = JSON.parse(stdout.trim());
    const sql = await readFile(out, 'utf8');

    assert.equal(summary.cases, 156);
    assert.equal(summary.feature_flag_enabled, false);
    assert.equal(
      (sql.match(/insert into can_lam_sang_private\.case_bundles/g) || []).length,
      156
    );
    assert.equal(
      (sql.match(/insert into can_lam_sang_private\.answer_keys/g) || []).length,
      156
    );
    assert.match(
      sql,
      /values\s*\(\s*'clinical_lab_room_v1'\s*,\s*false\s*,/i
    );
  } finally {
    await rm(dir, { recursive: true, force: true });
  }
});
