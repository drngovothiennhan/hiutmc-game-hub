import test from 'node:test';
import assert from 'node:assert/strict';
import { readFile } from 'node:fs/promises';

const read = path => readFile(new URL(path, import.meta.url), 'utf8');

test('Y Quan is launched from Game Hub as its own live multiplayer game', async () => {
  const map = await read('../src/data/world-map.js');
  const entry = map.match(/\{ id: 'clinic',[^\n]+/);
  assert.ok(entry);
  assert.match(entry[0], /state: 'available-live'/);
  assert.match(entry[0], /href: '\/y-quan-live\/'/);
  assert.doesNotMatch(entry[0], /garden\?game=hiu-y-quan/);
});

test('Y Quan client sends patient ratings and simulated cases to authenticated cloud RPCs', async () => {
  const client = await read('../public/y-quan-live/game.js');
  for (const rpc of ['y_quan_rate_doctor_v1','y_quan_submit_daily_case_v1','y_quan_submit_case_v1','y_quan_leaderboard_v1']) {
    assert.ok(client.includes(rpc), `missing RPC ${rpc}`);
  }
  assert.match(client, /Authorization:'Bearer '\+t/);
  assert.match(client, /patient_avatar_url/);
});

test('server schema isolates Y Quan credits and prevents direct table access', async () => {
  const sql = await read('../supabase/migrations/20260925225700_y_quan_official_runtime_v1.sql');
  assert.match(sql, /schema if not exists y_quan_private/);
  assert.match(sql, /unique \(member_id,source_kind,source_id\)/);
  assert.match(sql, /Only the patient of a completed visit can rate this doctor/);
  assert.match(sql, /revoke all on all tables in schema y_quan_private from public,anon,authenticated/i);
  assert.match(sql, /grant execute on function public\.y_quan_rate_doctor_v1\(uuid,smallint\) to authenticated/i);
});

test('doctor and patient can open a per-visit chat from their visit lists', async () => {
  const client = await read('../public/y-quan-live/game.js');
  assert.match(client, /data-action="chat" data-id="'\+v\.visit_id/);
  assert.match(client, /Chat với bác sĩ/);
  assert.match(client, /Nhắn bệnh nhân/);
  assert.match(client, /y_quan_visit_messages_v1/);
  assert.match(client, /y_quan_send_message_v1/);
  assert.match(client, /setInterval\(\(\)=>\{if\(activeChat\)refreshChat\(true\)\},5000\)/);
  assert.match(client, /maxlength="1000"/);
});

test('Y Quan chat is private to visit participants and sends as the authenticated member', async () => {
  const sql = await read('../supabase/migrations/20260926032644_y_quan_patient_doctor_chat_v1.sql');
  assert.match(sql, /create table if not exists y_quan_private\.visit_messages/i);
  assert.match(sql, /v\.doctor_id = mid or v\.patient_id = mid/);
  assert.match(sql, /values \(p_visit_id, mid, clean_body\)/);
  assert.match(sql, /limit 100/i);
  assert.match(sql, /revoke all on function public\.y_quan_send_message_v1\(uuid, text\) from public, anon/i);
  assert.match(sql, /grant execute on function public\.y_quan_visit_messages_v1\(uuid\) to authenticated/i);
  assert.match(sql, /grant execute on function public\.y_quan_send_message_v1\(uuid, text\) to authenticated/i);
});
