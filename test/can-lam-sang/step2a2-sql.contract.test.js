import test from "node:test";
import assert from "node:assert/strict";
import fs from "node:fs";
import os from "node:os";
import path from "node:path";
import { execFileSync } from "node:child_process";
import { fileURLToPath } from "node:url";

const here = path.dirname(fileURLToPath(import.meta.url));
const repoRoot = path.resolve(here, "../..");
const sqlRoot = path.join(repoRoot, "supabase/proposed/can-lam-sang");
const tablesSql = fs.readFileSync(path.join(sqlRoot, "005_cls_cbc_tables.sql"), "utf8");
const rpcSql = fs.readFileSync(path.join(sqlRoot, "006_cls_cbc_rpc.sql"), "utf8");
const seedScript = path.join(sqlRoot, "008_cls_cbc_seed_generator.mjs");
const fixturePath = path.join(
  repoRoot,
  "test/fixtures/can-lam-sang/cbc/normal-adult.fixture.json"
);

test("Step 2a-2 SQL contract has approval gates, grants and no random ordering", () => {
  assert.match(tablesSql, /reviewer text/);
  assert.match(tablesSql, /reviewed_at timestamptz/);
  assert.match(tablesSql, /approval_ref text/);
  assert.match(tablesSql, /review_status <> 'DA_DUYET'/);
  assert.match(tablesSql, /pg_catalog\.btrim\(approval_ref\) <> ''/);
  assert.match(tablesSql, /level in \('co_ban', 'trung_binh', 'nang_cao'\)/);
  assert.match(tablesSql, /cbc_scenarios/);
  assert.match(tablesSql, /public_scenario jsonb/);
  assert.match(tablesSql, /answer_key jsonb/);
  assert.match(tablesSql, /revoke all on table/);
  assert.doesNotMatch(tablesSql, /ORDER\s+BY\s+random\s*\(/i);
  assert.doesNotMatch(rpcSql, /ORDER\s+BY\s+random\s*\(/i);
});

test("Step 2a-2 RPC contract has three enveloped SECURITY DEFINER functions", () => {
  for (const signature of [
    "public.cls_cbc_start_v1(p_level text)",
    "public.cls_cbc_get_v1(p_attempt_id uuid)",
    "public.cls_cbc_submit_v1(p_attempt_id uuid, p_answers jsonb)"
  ]) {
    assert.ok(rpcSql.includes(signature), signature);
  }
  assert.equal((rpcSql.match(/security definer/gi) || []).length, 3);
  assert.equal((rpcSql.match(/set search_path = ''/g) || []).length, 3);
  assert.match(rpcSql, /grant execute on function public\.cls_cbc_start_v1\(text\) to authenticated/);
  assert.match(rpcSql, /grant execute on function public\.cls_cbc_get_v1\(uuid\) to authenticated/);
  assert.match(rpcSql, /grant execute on function public\.cls_cbc_submit_v1\(uuid, jsonb\) to authenticated/);
  assert.match(rpcSql, /pg_catalog\.pg_advisory_xact_lock/);
  assert.match(rpcSql, /cbc_attempts_user_status_idx/);
  assert.match(rpcSql, /cbc_attempts_user_created_at_idx/);
  assert.match(rpcSql, /'answers_khong_hop_le'/);
  assert.match(rpcSql, /user_id = v_user/);
  assert.match(rpcSql, /'khong_tim_thay'/);
  assert.match(rpcSql, /expected_classifications/);
});

test("seed generator produces separate public_scenario and answer_key without pattern_id leakage", () => {
  const fixture = JSON.parse(fs.readFileSync(fixturePath, "utf8"));
  fixture.level = "co_ban";
  fixture.review_status = "FIXTURE_ONLY";

  const dir = fs.mkdtempSync(path.join(os.tmpdir(), "hiutmc-cbc-seed-"));
  const input = path.join(dir, "pattern.json");
  const output = path.join(dir, "seed.json");
  fs.writeFileSync(input, JSON.stringify(fixture), "utf8");

  execFileSync(process.execPath, [seedScript, input, output, "co_ban", "1"], {
    cwd: repoRoot,
    stdio: "pipe"
  });

  const payload = JSON.parse(fs.readFileSync(output, "utf8"));
  assert.equal(payload.rows.length, 2);

  for (const row of payload.rows) {
    assert.ok(row.pattern_id);
    assert.ok(row.public_scenario);
    assert.ok(row.answer_key);
    assert.equal(row.public_scenario.pattern_id, undefined);
    assert.equal(JSON.stringify(row.public_scenario).includes(row.pattern_id), false);
    assert.equal(Object.keys(row.answer_key.classifications).length, 13);
  }
});
