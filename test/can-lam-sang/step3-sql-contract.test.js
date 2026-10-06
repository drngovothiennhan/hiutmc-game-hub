import test from 'node:test';
import assert from 'node:assert/strict';
import { readFile } from 'node:fs/promises';

const read=p=>readFile(new URL(p,import.meta.url),'utf8');

test('012 list RPC is a security-definer authenticated-only public list and never reads answer_keys',async()=>{
  const sql=await read('../../supabase/proposed/can-lam-sang/012_cls_list_cases_v1.sql');
  assert.match(sql,/create or replace function public\.cls_list_cases_v1\(\)/i);
  assert.match(sql,/security definer/i);
  assert.match(sql,/set search_path = ''/i);
  assert.match(sql,/cls_user_enabled_v1\(v_user\)/i);
  assert.match(sql,/cls_content_visible_v1\(c\.review_status\)/i);
  assert.match(sql,/cls_review_fields_v1\(c\.review_status\)/i);
  assert.match(sql,/can_lam_sang_private\.submissions/i);
  assert.doesNotMatch(sql,/answer_keys/i);
  assert.match(sql,/revoke all on function public\.cls_list_cases_v1\(\)\s+from public, anon, authenticated/i);
  assert.match(sql,/grant execute on function public\.cls_list_cases_v1\(\)\s+to authenticated/i);
  assert.doesNotMatch(sql,/DA_DUYET/i);
});

test('013 rollback drops only the new list function',async()=>{
  const sql=await read('../../supabase/proposed/can-lam-sang/013_cls_list_cases_v1_rollback.sql');
  assert.match(sql,/begin;/i);assert.match(sql,/commit;/i);
  assert.match(sql,/drop function if exists public\.cls_list_cases_v1\(\)/i);
  assert.equal((sql.match(/drop\s+(?:table|function|schema|policy|type)\b/gi)||[]).length,1);
  assert.doesNotMatch(sql,/cls_submit_v1|case_bundles|answer_keys|submissions/i);
});


test('009 keeps CHUA_DUYET label independent of expiry and constrains config_id',async()=>{
  const sql=await read('../../supabase/proposed/can-lam-sang/009_cls_publish_gate.sql');
  assert.match(sql,/constraint cls_publish_config_id_check check \(config_id = true\)/i);
  assert.match(sql,/when p_review_status='CHUA_DUYET' then c\.label_text/i);
  assert.doesNotMatch(sql,/CHUA_DUYET'.*cls_content_visible_v1\(p_review_status\).*then c\.label_text/is);
  assert.match(sql,/coalesce\(pg_catalog\.jsonb_array_length\(pg_catalog\.jsonb_path_query_array\(v_expected, '\$\.\*'\)\), -1\) <> 13/i);
});

test('011 authenticates before feature gate, validates nested answer-key shapes, and bounds selections',async()=>{
  const sql=await read('../../supabase/proposed/can-lam-sang/011_cls_core_submit_validation.sql');
  const authPos=sql.indexOf("if v_user is null then");
  const gatePos=sql.indexOf("if not can_lam_sang_private.cls_user_enabled_v1(v_user) then");
  assert.ok(authPos>=0 && gatePos>authPos);
  assert.match(sql,/jsonb_typeof\(v_diagnosis_options\) <> 'object'/i);
  assert.match(sql,/jsonb_typeof\(v_action_options\) <> 'array'/i);
  assert.match(sql,/jsonb_array_length\(p_answers -> v_key_name\) > v_max_selected/i);
  assert.match(sql,/jsonb_array_length\(v_value\) <= v_max_selected/i);
  assert.doesNotMatch(sql,/v_choice\b/);
  assert.doesNotMatch(sql,/raise exception/i);
});

test('014/015 provide read-only submission retrieval with rollback before 010',async()=>{
  const sql=await read('../../supabase/proposed/can-lam-sang/014_cls_get_submission_v1.sql');
  const rollback=await read('../../supabase/proposed/can-lam-sang/015_cls_get_submission_v1_rollback.sql');
  assert.match(sql,/create or replace function public\.cls_get_submission_v1\(p_case_id text\)/i);
  assert.match(sql,/exists \(\s*select 1[\s\S]*submissions/i);
  assert.match(sql,/revoke all on function public\.cls_get_submission_v1\(text\)/i);
  assert.match(sql,/grant execute on function public\.cls_get_submission_v1\(text\)\s+to authenticated/i);
  assert.doesNotMatch(sql,/insert into|update |delete from/i);
  assert.match(rollback,/drop function if exists public\.cls_get_submission_v1\(text\)/i);
  assert.doesNotMatch(rollback,/cls_submit_v1|cls_get_case_v1|cls_publish_config/i);
});

test('016 flag enable is isolated and never executed by the source tests',async()=>{
  const sql=await read('../../supabase/proposed/can-lam-sang/016_cls_enable_unreviewed_2026-10-12.sql');
  assert.match(sql,/update can_lam_sang_private\.cls_publish_config/i);
  assert.match(sql,/where config_id = true/i);
  assert.match(sql,/unreviewed_enabled = true/i);
  assert.match(sql,/2026-10-12 23:59:59\+07/i);
});
