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
  assert.match(client, /signal:AbortSignal\.timeout\(RPC_TIMEOUT_MS\)/);
  assert.match(client, /signal:AbortSignal\.timeout\(AUTH_TIMEOUT_MS\)/);
});

test('Thap van daily attempts use the server schedule and private case rubric for score and credits', async () => {
  const migration = await read('../supabase/migrations/20260926120000_y_quan_thap_van_cases_v2.sql');
  const client = await read('../public/y-quan-live/game.js');
  const interview = await read('../public/y-quan-live/interview/app.js');
  assert.match(migration, /add column if not exists case_profile_id text/i);
  assert.match(migration, /generate_series\(1,5\)/i);
  assert.match(migration, /\(n - 1\) \* 120/i);
  assert.match(migration, /case_profile_id='can-khi-uat-ket'/);
  assert.match(migration, /case_profile_id='ty-vi-hu-han'/);
  assert.match(migration, /case_profile_id='am-hu-hoa-vuong'/);
  assert.match(migration, /diagnosis_points\+b8c_points\+inquiry_points\+reasoning_points/);
  assert.match(migration, /'bot_stars'/);
  assert.match(client, /HIU_YQ_PRACTICE_SUBMIT/);
  assert.match(client, /event\.origin!==location\.origin/);
  assert.match(interview, /answered_domains:\[\.\.\.new Set\(asked\.map/);
});

test('Y Quan writes send idempotency keys to the transactional server gateway', async () => {
  const client = await read('../public/y-quan-live/game.js');
  const migration = await read('../supabase/migrations/20260926100000_y_quan_write_idempotency_v1.sql');
  assert.match(client, /requestName=isWrite\?'y_quan_write_idempotent_v1':name/);
  assert.match(client, /p_idempotency_key:crypto\.randomUUID\(\),p_operation:name,p_payload:body/);
  assert.match(migration, /primary key \(member_id, request_id\)/i);
  assert.match(migration, /prior\.request_body <> body/);
  assert.match(migration, /if prior\.response is not null then return prior\.response/i);
  for (const operation of ['y_quan_submit_case_v1', 'y_quan_submit_daily_case_v1', 'y_quan_rate_doctor_v1', 'y_quan_send_message_v1']) {
    assert.ok(migration.includes(`'${operation}'`));
  }
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
  assert.match(client, /if\(writeRecoveryRequired\)\{if\(activeChat\)refreshChat\(true\)/);
  assert.match(client, /setWriteRecoveryRequired\(true\)/);
  assert.match(client, /RPC_OUTCOME_UNKNOWN/);
  assert.match(client, /loadSequence/);
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

import { gameHubBasePath, gameHubPath } from '../public/y-quan-live/paths.js';

test('Y Quan paths stay inside both the Pages root and the production app mount', async () => {
  assert.equal(gameHubBasePath('/y-quan-live/'), '/');
  assert.equal(gameHubPath('y-quan-live/interview/', '/y-quan-live/'), '/y-quan-live/interview/');
  assert.equal(gameHubBasePath('/apps/game-hub/y-quan-live/'), '/apps/game-hub/');
  assert.equal(gameHubPath('/y-quan-live/interview/', '/apps/game-hub/y-quan-live/'), '/apps/game-hub/y-quan-live/interview/');
  assert.equal(gameHubPath('https://example.test/avatar.png', '/apps/game-hub/'), 'https://example.test/avatar.png');

  const entry = await read('../public/y-quan-live/index.html');
  const game = await read('../public/y-quan-live/game.js');
  const interviewEntry = await read('../public/y-quan-live/interview/index.html');
  const interview = await read('../public/y-quan-live/interview/app.js');
  assert.ok(entry.includes("y-quan-live/game.css"));
  assert.ok(entry.includes("import(base+'y-quan-live/game.js')"));
  assert.match(game, /new URL\(gameHubPath\('y-quan-live\/interview\/'\),location\.origin\)/);
  assert.match(game, /gameHubPath\('assets\/avatars\//);
  assert.ok(interviewEntry.includes("'y-quan-live/game.css'"));
  assert.ok(interviewEntry.includes("'y-quan-live/interview/interview.css'"));
  assert.ok(interviewEntry.includes("import(base+'y-quan-live/interview/app.js')"));
  assert.match(interview, /import \{ gameHubPath \} from '\.\.\/paths\.js'/);
  assert.match(interview, /gameHubPath\('y-quan-live\/'\)/);
  assert.match(interview, /\[HIU Y Quán\]\[Thập vấn\] startup failed/);
});
