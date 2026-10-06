import test from 'node:test';
import assert from 'node:assert/strict';
import { execFile } from 'node:child_process';
import { mkdtemp, readFile, readdir, rm } from 'node:fs/promises';
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
  return sql.replace(/--.*$/gm, '').replace(/\s+/g, ' ').trim();
}

function createdTables(sql) {
  return [...sql.matchAll(
    /create\s+table\s+if\s+not\s+exists\s+can_lam_sang_private\.([a-z0-9_]+)/gi
  )].map(match => match[1]);
}

function publicRpcBlocks(sql) {
  return [...sql.matchAll(
    /create\s+or\s+replace\s+function\s+public\.(cls_[a-z0-9_]+_v1)\s*\([^)]*\)[\s\S]*?\$function\$;/gi
  )].map(match => ({ name: match[1], text: match[0] }));
}

test('Step 1B creates five private RLS tables and fail-safe audience defaults', async () => {
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
      )
    );
  }
  assert.match(foundation, /audience\s+text\s+not\s+null\s+default\s+'allowlist'/i);
  assert.match(foundation, /check\s*\(audience\s+in\s*\('allowlist'\s*,\s*'all_authenticated'\)\)/i);
  assert.match(foundation, /references\s+auth\.users\s*\(id\)\s*on\s+delete\s+cascade/i);
});

test('Private tables are revoked and no anon grants or policies exist', async () => {
  const [foundation, rpc] = await Promise.all([read(paths.foundation), read(paths.rpc)]);
  const sql = foundation + '\n' + rpc;
  assert.match(foundation, /revoke\s+all\s+on\s+schema\s+can_lam_sang_private\s+from\s+public\s*,\s*anon\s*,\s*authenticated/i);
  assert.match(foundation, /revoke\s+all\s+on\s+all\s+tables\s+in\s+schema\s+can_lam_sang_private\s+from\s+public\s*,\s*anon\s*,\s*authenticated/i);
  assert.doesNotMatch(sql, /grant\s+[^;]+\s+to\s+[^;]*\banon\b/i);
  assert.doesNotMatch(sql, /create\s+policy\b/i);
});

test('Feature gating is centralized in one private helper with fail-safe semantics', async () => {
  const rpc = await read(paths.rpc);
  assert.match(rpc, /function\s+can_lam_sang_private\.cls_user_enabled_v1\s*\(p_user_id\s+uuid\)/i);
  assert.match(rpc, /when\s+'allowlist'\s+then\s*\(\s*p_user_id\s+is\s+not\s+null\s+and\s+p_user_id\s*=\s*any\(f\.allowlist_user_ids\)/i);
  assert.match(rpc, /when\s+'all_authenticated'\s+then\s+p_user_id\s+is\s+not\s+null/i);
  assert.match(rpc, /revoke\s+all\s+on\s+function\s+can_lam_sang_private\.cls_user_enabled_v1\(uuid\)\s+from\s+public\s*,\s*anon\s*,\s*authenticated/i);
  assert.equal(
    (rpc.match(/can_lam_sang_private\.cls_user_enabled_v1\(/g) || []).length,
    5,
    'one definition plus one call from each public RPC and one revoke signature'
  );
});

test('Every public RPC is SECURITY DEFINER, empty search_path, authenticated-only execute', async () => {
  const rpc = await read(paths.rpc);
  const blocks = publicRpcBlocks(rpc);
  assert.deepEqual(blocks.map(item => item.name).sort(), [
    'cls_flag_status_v1',
    'cls_get_case_v1',
    'cls_submit_v1'
  ]);
  for (const block of blocks) {
    assert.match(block.text, /security\s+definer/i);
    assert.match(block.text, /set\s+search_path\s*=\s*''/i);
  }
  assert.doesNotMatch(rpc, /grant\s+execute[^;]*\bto\s+anon\b/i);
  assert.equal(
    (rpc.match(/grant\s+execute\s+on\s+function\s+public\.cls_[^;]+\s+to\s+authenticated\s*;/gi) || []).length,
    3
  );
});

test('All three RPCs return the unified ok/code/data envelope', async () => {
  const rpc = await read(paths.rpc);
  for (const key of ["'ok'", "'code'", "'data'"]) {
    assert.ok((rpc.split(key).length - 1) >= 3, `${key} must appear in all RPC response paths`);
  }
  assert.match(rpc, /'data'\s*,\s*pg_catalog\.jsonb_build_object\('enabled'\s*,\s*v_enabled\)/i);
  assert.match(rpc, /'data'\s*,\s*v_bundle/i);
  assert.match(rpc, /'data'\s*,\s*v_reveal/i);
});

test('Only core can write a submission in Step 1B and answers are bounded', async () => {
  const rpc = normalizeSql(await read(paths.rpc));
  const submit = rpc.slice(rpc.indexOf('create or replace function public.cls_submit_v1'));
  assert.ok(submit.indexOf("if p_module <> 'core'") < submit.indexOf('insert into can_lam_sang_private.submissions'));
  assert.match(submit, /'module_chua_ho_tro'/i);
  assert.match(submit, /p_answers\s*=\s*'\{\}'::jsonb/i);
  assert.match(submit, /pg_catalog\.octet_length\(p_answers::text\)\s*>\s*65536/i);
});

test('Idempotent reveal reads answer key after insert attempt and supports da_nop', async () => {
  const rpc = normalizeSql(await read(paths.rpc));
  const submit = rpc.slice(rpc.indexOf('create or replace function public.cls_submit_v1'));
  assert.ok(
    submit.indexOf('insert into can_lam_sang_private.submissions')
      < submit.indexOf('from can_lam_sang_private.answer_keys')
  );
  assert.match(submit, /v_code\s*:=\s*'da_nop'/i);
  assert.match(submit, /'ok',\s*true,\s*'code',\s*v_code,\s*'data',\s*v_reveal/i);
});

test('Rollback is guarded against submission data loss and scoped to CLS plus 3 public RPCs', async () => {
  const rollback = normalizeSql(await read(paths.rollback));
  assert.match(rollback, /to_regclass\('can_lam_sang_private\.submissions'\)/i);
  assert.match(rollback, /current_setting\('cls\.allow_data_loss',\s*true\)\s+is\s+distinct\s+from\s+'on'/i);
  assert.match(rollback, /raise\s+exception[^;]*export/i);
  const publicRefs = [...rollback.matchAll(/\bpublic\.([a-z0-9_]+)/gi)]
    .map(match => match[1]).sort();
  assert.deepEqual(publicRefs, [
    'cls_flag_status_v1',
    'cls_get_case_v1',
    'cls_submit_v1'
  ]);
  assert.match(rollback, /drop\s+schema\s+if\s+exists\s+can_lam_sang_private\s+cascade/i);
  assert.doesNotMatch(rollback, /\by_quan_private\b/i);
});

test('Proposed SQL never mutates y_quan_private or tables outside CLS', async () => {
  const all = (await Promise.all([
    read(paths.foundation),
    read(paths.rpc),
    read(paths.rollback)
  ])).join('\n');
  assert.doesNotMatch(all, /\b(?:alter|drop|update|delete\s+from)\s+(?:table\s+)?y_quan_private\b/i);
  for (const match of all.matchAll(
    /\b(?:alter|drop)\s+table\s+(?:if\s+exists\s+)?([a-z0-9_]+)\.([a-z0-9_]+)/gi
  )) {
    assert.equal(match[1].toLowerCase(), 'can_lam_sang_private');
  }
});

test('Seed generator chunks 156 cases, writes resources first, and never touches feature_flags', async () => {
  const dir = await mkdtemp(join(tmpdir(), 'cls-seed-'));
  try {
    const { stdout } = await execFileAsync(
      process.execPath,
      [paths.generator.pathname, '--output-dir', dir, '--chunk-size', '20'],
      { encoding: 'utf8' }
    );
    const summary = JSON.parse(stdout.trim());
    const names = await readdir(dir);
    assert.equal(summary.cases, 156);
    assert.equal(summary.chunk_size, 20);
    assert.equal(summary.files[0].name, '000_resources.sql');
    assert.equal(summary.files.length, 9);
    assert.deepEqual(names.sort(), summary.files.map(file => file.name).sort());
    assert.ok(summary.files.every(file => file.bytes > 0 && file.kb > 0));

    let caseInserts = 0;
    let answerInserts = 0;
    let resourceInserts = 0;
    for (const file of summary.files) {
      const sql = await readFile(join(dir, file.name), 'utf8');
      assert.match(sql, /^begin;/i);
      assert.match(sql, /commit;\s*$/i);
      assert.doesNotMatch(sql, /feature_flags/i);
      caseInserts += (sql.match(/insert into can_lam_sang_private\.case_bundles/g) || []).length;
      answerInserts += (sql.match(/insert into can_lam_sang_private\.answer_keys/g) || []).length;
      resourceInserts += (sql.match(/insert into can_lam_sang_private\.resources/g) || []).length;
    }
    assert.equal(caseInserts, 156);
    assert.equal(answerInserts, 156);
    assert.equal(resourceInserts, summary.resources);
  } finally {
    await rm(dir, { recursive: true, force: true });
  }
});
