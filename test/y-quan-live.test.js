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
