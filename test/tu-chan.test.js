import test from 'node:test';
import assert from 'node:assert/strict';
import { readFile } from 'node:fs/promises';

const read = path => readFile(new URL(path, import.meta.url), 'utf8');

test('Vien Thuc Hanh - TMC is launched from the world map as its own self-contained game', async () => {
  const map = await read('../src/data/world-map.js');
  const entry = map.match(/\{ id: 'four-diagnosis',[^\n]+/);
  assert.ok(entry);
  assert.match(entry[0], /state: 'available-live'/);
  assert.match(entry[0], /href: '\/vien-thuc-hanh\/'/);
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

test('Vien Thuc Hanh card uses its own action label and a unique bank', async () => {
  const html = await read('../public/tu-chan/index.html');
  const map = await read('../src/data/world-map.js');
  assert.match(map, /title: 'VIỆN THỰC HÀNH - TMC'/);
  assert.match(map, /actionLabel: 'Vào Viện Thực Hành'/);
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
  for (const rpc of ['tu_chan_profile_v1', 'tu_chan_start_shift_v1', 'tu_chan_finish_shift_v1', 'tu_chan_register_cases_v1']) assert.ok(html.includes(rpc), 'client missing ' + rpc);
  assert.match(html, /data-duty="\$\{k\}"/);
  const sql = await read('../supabase/migrations/20261001160000_vien_thuc_hanh_shifts_v1.sql');
  assert.match(sql, /enable row level security/);
  assert.match(sql, /experience = experience \+ gain/);
  assert.match(sql, /revoke all on function public\.tu_chan_profile_v1\(\), public\.tu_chan_start_shift_v1\(text\)[^;]*from public, anon;/);
  assert.match(sql, /tu_chan_shifts_one_open_idx/);
});

test('Catalog seeded on the server matches the embedded bank: 40 cases, 20 per room', async () => {
  const html = await read('../public/tu-chan/index.html');
  const bank = JSON.parse(html.match(/id="bank-data">([\s\S]*?)<\/script>/)[1]);
  assert.equal(bank.length, 40);
  const room = c => (c.setting === 'capcuu' || c.setting === 'giuong') ? 'capcuu' : 'kham';
  assert.equal(bank.filter(c => room(c) === 'capcuu').length, 20);
  assert.equal(bank.filter(c => room(c) === 'kham').length, 20);
  const sql = await read('../supabase/migrations/20261001160000_vien_thuc_hanh_shifts_v1.sql');
  for (const c of bank) assert.ok(sql.includes(`('${c.id}','${room(c)}'`), 'catalog missing ' + c.id);
});
