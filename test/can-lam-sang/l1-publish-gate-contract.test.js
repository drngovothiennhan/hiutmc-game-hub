import test from 'node:test';
import assert from 'node:assert/strict';
import fs from 'node:fs';
const read = p => fs.readFileSync(p, 'utf8');

test('009 is fail-closed, transactional, and server-owned', () => {
  const s = read('supabase/proposed/can-lam-sang/009_cls_publish_gate.sql');
  assert.match(s, /^begin;\n/);
  assert.match(s, /unreviewed_enabled boolean not null default false/);
  assert.match(s, /unreviewed_expires_at timestamptz/);
  assert.match(s, /p_review_status='DA_DUYET'/);
  assert.match(s, /pg_catalog\.now\(\) <= c\.unreviewed_expires_at/);
  assert.match(s, /public\.cls_get_case_v1\(p_case_id text\)/);
  assert.match(s, /review_label/);
  assert.match(s, /review_status/);
  assert.match(s, /alter table can_lam_sang_private\.cls_publish_config enable row level security/);
  assert.match(s, /revoke all on table can_lam_sang_private\.cls_publish_config/);
  assert.match(s, /revoke all on function can_lam_sang_private\.cls_content_visible_v1\(text\)/);
  assert.match(s, /revoke all on function can_lam_sang_private\.cls_review_fields_v1\(text\)/);
  assert.doesNotMatch(s, /update can_lam_sang_private\.cls_publish_config/i);
});

test('011 uses the real core schema and exact three-argument submit signature', () => {
  const s = read('supabase/proposed/can-lam-sang/011_cls_core_submit_validation.sql');
  assert.doesNotMatch(s, /core_case_bundles/);
  assert.match(s, /public\.cls_submit_v1\(\s*p_case_id text,\s*p_module text,\s*p_answers jsonb/s);
  assert.match(s, /can_lam_sang_private\.case_bundles/);
  assert.match(s, /can_lam_sang_private\.answer_keys/);
  assert.match(s, /can_lam_sang_private\.submissions/);
  assert.match(s, /answers_khong_hop_le/);
  assert.match(s, /p_answers = '\{\}'::jsonb/);
});

test('010 restores original RPCs and never drops them', () => {
  const s = read('supabase/proposed/can-lam-sang/010_cls_publish_gate_rollback.sql');
  assert.match(s, /create or replace function public\.cls_get_case_v1\(p_case_id text\)/);
  assert.match(s, /create or replace function public\.cls_submit_v1\(/);
  assert.match(s, /create or replace function public\.cls_cbc_start_v1\(/);
  assert.match(s, /create or replace function public\.cls_cbc_get_v1\(/);
  assert.doesNotMatch(s, /drop function[^;]*cls_get_case_v1/i);
  assert.doesNotMatch(s, /drop function[^;]*cls_cbc_start_v1/i);
  assert.doesNotMatch(s, /drop function[^;]*cls_cbc_get_v1/i);
  assert.doesNotMatch(s, /drop function[^;]*cls_submit_v1/i);
  assert.match(s, /drop function if exists can_lam_sang_private\.cls_review_fields_v1/);
  assert.match(s, /drop function if exists can_lam_sang_private\.cls_content_visible_v1/);
  assert.match(s, /drop table if exists can_lam_sang_private\.cls_publish_config/);
});
