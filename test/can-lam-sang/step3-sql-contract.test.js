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
