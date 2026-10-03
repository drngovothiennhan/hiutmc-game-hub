import test from 'node:test';
import assert from 'node:assert/strict';
import { readFile } from 'node:fs/promises';

const read = path => readFile(new URL(path, import.meta.url), 'utf8');

test('Vien Thuc Hanh is its own hub and is no longer listed inside the Game Hub world map', async () => {
  const map = await read('../src/data/world-map.js');
  assert.doesNotMatch(map, /four-diagnosis/);
  const hub = await read('../public/vien-thuc-hanh/index.html');
  assert.match(hub, /href="\/phong-hoc\/"/);
  assert.match(hub, /href="\/tu-chan\/"/);
  assert.doesNotMatch(hub + (await read('../public/phong-hoc/index.html')).slice(0, 200000), /href="\.\.\//, 'relative ../ links break behind the Eco <base> tag');
});

test('Tu Chan page embeds the case bank and does not need a network or secret', async () => {
  const html = await read('../public/tu-chan/index.html');
  assert.match(html, /<title>Viện Thực Hành - TMC<\/title>/);
  const m = html.match(/<script type="application\/json" id="bank-data">([\s\S]*?)<\/script>/);
  assert.ok(m, 'bank-data missing');
  const packs = JSON.parse(m[1]);
  const cases = (Array.isArray(packs) ? packs : Object.values(packs)).flatMap(p => p.cases || p);
  assert.ok(cases.length >= 19, 'expected at least 19 cases, got ' + cases.length);
  assert.doesNotMatch(html, /service[_-]?role|secret|password/i);
});

test('Vien Thuc Hanh bank has unique case ids', async () => {
  const html = await read('../public/tu-chan/index.html');
  const bank = JSON.parse(html.match(/id="bank-data">([\s\S]*?)<\/script>/)[1]);
  const ids = bank.map(c => c.id);
  assert.equal(new Set(ids).size, ids.length, 'case ids must be unique');
});

test('Vien Thuc Hanh page declares doctype and a mobile viewport so phones do not shrink it', async () => {
  const html = await read('../public/tu-chan/index.html');
  assert.match(html, /^<!doctype html>/i);
  assert.match(html, /<meta name="viewport" content="width=device-width,initial-scale=1/);
  assert.match(html, /min-width:980px/);
});

test('Case bank management is hidden unless the member is verified as admin', async () => {
  const html = await read('../public/tu-chan/index.html');
  assert.match(html, /id="manage" \$\{ADMIN \? '' : 'hidden'\}/);
  assert.match(html, /garden_hub_current_member_role_v1/);
  assert.match(html, /=== 'admin'\) setAdmin\(true\)/);
});

test('Duty rooms: random server-issued cases and EXP wired to the shared Y Quan doctor profile', async () => {
  const html = await read('../public/tu-chan/index.html');
  for (const rpc of ['tu_chan_profile_v1', 'tu_chan_start_shift_v2', 'tu_chan_finish_shift_v2', 'tu_chan_register_cases_v1']) assert.ok(html.includes(rpc), 'client missing ' + rpc);
  assert.match(html, /data-duty="\$\{k\}"/);
  const sql = await read('../supabase/migrations/20261001160000_vien_thuc_hanh_shifts_v1.sql');
  assert.match(sql, /enable row level security/);
  assert.match(sql, /experience = experience \+ gain/);
  assert.match(sql, /revoke all on function public\.tu_chan_profile_v1\(\), public\.tu_chan_start_shift_v1\(text\)[^;]*from public, anon;/);
  assert.match(sql, /tu_chan_shifts_one_open_idx/);
});

test('Catalog seeded on the server matches the reviewed bank: 40 cases, 20 per room (draft cases wait for admin sync)', async () => {
  const html = await read('../public/tu-chan/index.html');
  const bank = JSON.parse(html.match(/id="bank-data">([\s\S]*?)<\/script>/)[1]).filter(c => c.status !== 'nhap');
  assert.equal(bank.length, 40);
  const room = c => (c.setting === 'capcuu' || c.setting === 'giuong') ? 'capcuu' : 'kham';
  assert.equal(bank.filter(c => room(c) === 'capcuu').length, 20);
  assert.equal(bank.filter(c => room(c) === 'kham').length, 20);
  const sql = await read('../supabase/migrations/20261001160000_vien_thuc_hanh_shifts_v1.sql');
  for (const c of bank) assert.ok(sql.includes(`('${c.id}','${room(c)}'`), 'catalog missing ' + c.id);
});


test('Intake cases cannot be synced into the random duty catalog', async () => {
  const html = await read('../public/tu-chan/index.html');
  assert.match(html, /BASE\.filter\(c => c\.status !== 'nhap'\)/);
  assert.match(html, /c\.setting === 'capcuu' \|\| c\.setting === 'giuong'/);
  assert.match(html, /status: c\.status \|\| 'draft'/);

  const bank = JSON.parse(html.match(/id="bank-data">([\s\S]*?)<\/script>/)[1]);
  const intake = bank.filter(c => c.status === 'nhap');
  assert.equal(intake.length, 101);
  assert.ok(intake.every(c => Array.isArray(c.nguon) && c.nguon.length > 0), 'intake cases must carry sources before review');
  const requiredHbu = ['ly_do_vao_vien','benh_su','tien_su','luoc_qua_co_quan','tom_tat','bien_luan','sinh_ly_benh','chan_doan_phan_biet','dieu_tri','tien_luong','du_phong'];
  for (const item of intake) {
    for (const key of requiredHbu) assert.ok(item.hbu && String(item.hbu[key] || '').trim(), item.id + ' missing hbu.' + key);
  }

  const guard = await read('../supabase/migrations/20261002194500_vien_thuc_hanh_case_release_guard.sql');
  assert.match(guard, /when r\.status = 'nhap' then false/);
  assert.match(guard, /coalesce\(v_active, false\)/);
});

test('Duty is filtered by the three tracks: noi, ngoai, yhct (server picks only inside the chosen track)', async () => {
  const html = await read('../public/tu-chan/index.html');
  assert.match(html, /const TRACKS = \{\s*noi:[\s\S]*ngoai:[\s\S]*yhct:/);
  assert.match(html, /tu_chan_start_shift_v2', \{ p_track: track \}/);
  const sql = await read('../supabase/migrations/20261003180000_vien_thuc_hanh_tracks_v1.sql');
  assert.match(sql, /k\.active and k\.track = p_track/);
  assert.match(sql, /revoke all on function public\.tu_chan_start_shift_v2\(text\) from public, anon;/);
  assert.doesNotMatch(sql, /drop\s|delete\s+from|truncate/i, 'additive migration only');
  const bank = JSON.parse(html.match(/id="bank-data">([\s\S]*?)<\/script>/)[1]);
  const t = c => (c.opt && c.opt.bd) ? 'yhct' : ((c.group === 'ngoai' || c.id === 'thai-ngoai-tu-cung-vo') ? 'ngoai' : 'noi');
  for (const k of ['noi', 'ngoai', 'yhct']) assert.ok(bank.some(c => t(c) === k), 'no case in track ' + k);
  for (const c of bank.filter(c => t(c) !== 'yhct')) assert.ok(!c.opt || !c.opt.bd, c.id + ' modern track must not carry YHCT diagnosis');
});

test('Duty history: per-skill scores are stored server-side and shown in the duty hub', async () => {
  const html = await read('../public/tu-chan/index.html');
  assert.match(html, /tu_chan_finish_shift_v2', \{ p_shift_id/);
  assert.match(html, /tu_chan_history_v1/);
  for (const k of ['hoi_benh', 'kham', 'cls', 'chan_doan', 'xu_tri', 'an_toan']) assert.ok(html.includes(k), 'client missing skill ' + k);
  const sql = await read('../supabase/migrations/20261003200000_vien_thuc_hanh_history_skills_v1.sql');
  assert.match(sql, /add column if not exists skills jsonb/);
  assert.match(sql, /revoke all on function public\.tu_chan_finish_shift_v2\(uuid, integer, boolean, jsonb\), public\.tu_chan_history_v1\(integer\) from public, anon;/);
  assert.match(sql, /least\(100, greatest\(0, round\(v\)\)\)/, 'skill scores must be clamped to 0-100');
  assert.doesNotMatch(sql, /drop\s|delete\s+from|truncate/i, 'additive migration only');
});

test('Learning room lists cases five at a time', async () => {
  const html = await read('../public/phong-hoc/index.html');
  assert.match(html, /const PAGE=5;/);
  assert.match(html, /data-v="pg"/);
});
