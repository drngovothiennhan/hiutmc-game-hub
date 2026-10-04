import test from 'node:test';
import assert from 'node:assert/strict';
import { readFile, access } from 'node:fs/promises';

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

test('Catalog on the server covers the whole bank: 40 seeded + 101 enabled by the owner on 2026-10-04', async () => {
  const html = await read('../public/tu-chan/index.html');
  const bank = JSON.parse(html.match(/id="bank-data">([\s\S]*?)<\/script>/)[1]);
  assert.equal(bank.length, 141);
  const room = c => (c.setting === 'capcuu' || c.setting === 'giuong') ? 'capcuu' : 'kham';
  const seed = await read('../supabase/migrations/20261001160000_vien_thuc_hanh_shifts_v1.sql');
  const more = await read('../supabase/migrations/20261004080000_vien_thuc_hanh_bat_ca_nhap.sql');
  for (const c of bank) assert.ok(seed.includes(`('${c.id}','${room(c)}'`) || more.includes(`('${c.id}','${room(c)}'`), 'catalog missing ' + c.id);
});


test('Intake cases cannot be synced into the random duty catalog', async () => {
  const html = await read('../public/tu-chan/index.html');
  assert.match(html, /BASE\.filter\(c => c\.status !== 'nhap'\)/);
  assert.match(html, /c\.setting === 'capcuu' \|\| c\.setting === 'giuong'/);
  assert.match(html, /status: c\.status \|\| 'draft'/);

  const bank = JSON.parse(html.match(/id="bank-data">([\s\S]*?)<\/script>/)[1]);
  assert.equal(bank.filter(c => c.status === 'nhap').length, 0, 'owner enabled all intake cases on 2026-10-04');
  const intake = bank.filter(c => /-(0\d\d|10\d)$/.test(c.id) && /^(noi|ngoai|yhct)-/.test(c.id) && !(c.nguon === undefined));
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

test('Weekly tournament: same cases for everyone, first attempt counts, leaderboard is real data only', async () => {
  const html = await read('../public/tu-chan/index.html');
  const hub = await read('../public/vien-thuc-hanh/index.html');
  assert.match(html, /tu_chan_start_challenge_v1/);
  assert.match(html, /get\('arena'\)/, 'duty page starts the event case from the hub link');
  assert.doesNotMatch(html, /id="arena"/, 'the event lives in the gate pop-up, not inside the duty hall');
  assert.match(hub, /<dialog class="ev"/);
  assert.match(hub, /tu_chan_challenge_v1/);
  assert.match(hub, /Chưa có ai hoàn tất ca nào trong tuần này/, 'honest empty state, no invented leaderboard');
  assert.doesNotMatch(hub, /r\.n\b/, 'leaderboard must not show how many cases a doctor did');
  const sql = await read('../supabase/migrations/20261003220000_vien_thuc_hanh_giai_dau_v1.sql');
  assert.match(sql, /enable row level security/);
  assert.match(sql, /interval '60 seconds'/, 'very fast submissions earn no points');
  assert.match(sql, /distinct on \(s\.member_id, s\.case_id\)/, 'only the first finished attempt counts');
  assert.match(sql, /revoke all on function public\.tu_chan_challenge_v1\(text\), public\.tu_chan_start_challenge_v1\(text\) from public, anon;/);
  assert.doesNotMatch(sql, /drop\s|delete\s+from|truncate/i, 'additive migration only');
});

test('Personalization is unlocked by level and enforced on the server', async () => {
  const yq = await read('../public/y-quan-live/game.js');
  assert.match(yq, /tu_chan_personalize_v1/, 'personalization lives in HIU Y Quan (Game Hub)');
  assert.match(yq, /tu_chan_personal_v1/);
  const html = await read('../public/tu-chan/index.html');
  assert.doesNotMatch(html, /tu_chan_personalize_v1/, 'no personalization form inside the Vien Thuc Hanh duty hall');
  const sql = await read('../supabase/migrations/20261003230000_vien_thuc_hanh_ca_nhan_hoa_v1.sql');
  for (const k of ['locked:rename:4', 'locked:outfit:%', 'locked:theme:%', 'locked:frame:%']) assert.ok(sql.includes(k), 'missing gate ' + k);
  assert.match(sql, /not in \('male','female'\)|clean_outfit not in/);
  assert.match(sql, /nm ~ '\[<>&\[:cntrl:\]\]'/, 'names must reject markup characters');
  assert.match(sql, /Cần đạt cấp 4/, 'legacy rename path is gated too');
  assert.match(sql, /revoke all on function public\.tu_chan_personal_v1\(\), public\.tu_chan_personalize_v1\(text, text, text, text, text\) from public, anon;/);
  assert.doesNotMatch(sql, /drop\s|delete\s+from|truncate/i);
});

test('Gameplay additions: events from monitor values, combo, SBAR handover, badges from real history', async () => {
  const html = await read('../public/tu-chan/index.html');
  assert.match(html, /const EV_STEPS = \[65, 45, 25\]/);
  assert.match(html, /function buildSbar/);
  assert.match(html, /function badgeList/);
  assert.match(html, /p_limit: 50/);
  assert.doesNotMatch(html, /leaderboard\s*=\s*\[\s*\{/i, 'no hard-coded leaderboard');
});

test('Duty profile is collapsed and private: no case counts, cases only for the owner to review', async () => {
  const html = await read('../public/tu-chan/index.html');
  assert.match(html, /<details id="hist-d"/);
  assert.match(html, /Chỉ mình bạn xem được/);
  assert.match(html, /data-review=/);
  assert.doesNotMatch(html, /<span>Ca trực<\/span>/, 'case count is hidden');
  assert.doesNotMatch(html, /tu_chan_showcase/, 'no public showcase of cases');
});

test('doctor portrait uses the pose and expression sheets and they exist', async () => {
  const { access } = await import('node:fs/promises');
  const html = await read('../public/tu-chan/index.html');
  assert.match(html, /function docPortrait/);
  assert.match(html, /DOCBASE \+ g \+ '-' \+ kind \+ '\.webp'/);
  assert.match(html, /tu_chan_abandon_v1/);
  assert.doesNotMatch(html, /url\((['"]?)\.\.\//);
  for (const f of ['nam-bieucam', 'nu-bieucam', 'nam-dongtac', 'nu-dongtac', 'nam-di', 'nu-di', 'nam-chay', 'nu-chay']) await access(new URL(`../public/tu-chan/bacsi/${f}.webp`, import.meta.url));
});

test('Story banners and the running doctor are removed (the scene shows the actual case)', async () => {
  const html = await read('../public/tu-chan/index.html');
  assert.doesNotMatch(html, /function storyStart|function runner|storyImg|id="sprites"/);
  await assert.rejects(access(new URL('../public/tu-chan/tranh/01.webp', import.meta.url)));
});

test('patient state sheets and prop icons exist', async () => {
  const { access } = await import('node:fs/promises');
  const html = await read('../public/tu-chan/index.html');
  assert.match(html, /function patPortrait/);
  assert.match(html, /function propIcon/);
  for (const v of ['nam_tre', 'nu_tre', 'nam_gia', 'nu_gia']) await access(new URL(`../public/tu-chan/benhnhan/${v}-trangthai.webp`, import.meta.url));
  for (const k of ['huyet_ap', 'phim_xquang', 'bb_stethoscope', 'soc_dien', 'phieu_xn', 'truyen_dich']) await access(new URL(`../public/tu-chan/vat/${k}.webp`, import.meta.url));
});

test('Trực: room scenes use prop, patient and acting-doctor art, driven by case scene/sex/age', async () => {
  const html = await read('../public/tu-chan/index.html');
  for (const f of ['sceneWard', 'sceneER', 'sceneClinic', 'sceneAcu', 'sceneBed', 'docScene', 'docPose', 'docExpr', 'patientAt', 'patCell']) assert.match(html, new RegExp('(function|const) ' + f));
  for (const k of ['monitor', 'truyen_dich', 'xe_cap_cuu', 'den_kham', 'cua_so_ngay', 'tu_thuoc', 'ban_lam_viec', 'ban_kham', 'rem_ngan', 'tu_dung_cu']) await access(new URL(`../public/tu-chan/canh/${k}.webp`, import.meta.url));
  for (const v of ['nam_tre', 'nu_tre', 'nam_gia', 'nu_gia']) for (let i = 1; i <= 7; i++) await access(new URL(`../public/tu-chan/canh/${v}-${i}.webp`, import.meta.url));
  assert.match(html, /const docKey = \(\) => S\.av === 'female' \? 'dfF' : 'dmF'/);
});

test('Every case has a scene that matches its story (place, sex, age, honorific)', async () => {
  const html = await read('../public/tu-chan/index.html');
  const bank = JSON.parse(html.match(/id="bank-data">([\s\S]*?)<\/script>/)[1]);
  const ok = ['giuong', 'capcuu', 'phongkham', 'chamcuu'];
  for (const c of bank) {
    assert.ok(ok.includes(c.scene), c.id + ' needs scene');
    const t = c.intro.replace(/^Ca tự soạn[^.]*\.\s*/i, '').toLowerCase().slice(0, 170);
    if (/^phòng khám|tại phòng khám|đến phòng khám/.test(t)) assert.equal(c.scene, 'phongkham', c.id + ' says clinic');
    if (/phòng cấp cứu|khoa cấp cứu|đến cấp cứu|vào cấp cứu/.test(t)) assert.equal(c.scene, 'capcuu', c.id + ' says ER');
    const n = c.name.toLowerCase();
    if (/^(ông|anh|chú)\b/.test(n)) assert.equal(c.sex, 'nam', c.id);
    if (/^(bà|cô|chị)\b/.test(n)) assert.equal(c.sex, 'nữ', c.id);
    if (/^(ông|bà)\b/.test(n)) assert.ok(c.age >= 40, c.id + ' honorific vs age');
  }
});

test('One doctor identity: Y Quán portraits come from the same doctor pack as the duty game', async () => {
  const { stat } = await import('node:fs/promises');
  for (const f of ['doctor-male', 'doctor-female']) assert.ok((await stat(new URL(`../public/y-quan-live/art/${f}.webp`, import.meta.url))).size > 3000);
});

test('Patient posture follows the clinical story: trauma and fractures lie down, sitting only when stable', async () => {
  const html = await read('../public/tu-chan/index.html');
  assert.match(html, /const TRAUMA = \/gãy\|trật khớp\|chấn thương\|ngã/);
  assert.match(html, /const vitStable = /);
  assert.match(html, /if \(TRAUMA\.test\(c\.title/);
});

test('Child patients use their own art and the acting doctor faces the patient', async () => {
  const html = await read('../public/tu-chan/index.html');
  for (const v of ['be_trai', 'be_gai']) for (let i = 1; i <= 7; i++) await access(new URL(`../public/tu-chan/canh/${v}-${i}.webp`, import.meta.url));
  assert.match(html, /const patArt = c => c\.age < 12/);
  /* ảnh gốc của bác sĩ quay sang TRÁI: đứng bên phải giường thì giữ nguyên, đứng bên trái bệnh nhân thì lật */
  assert.match(html, /docScene\(262, 262, 200, false\)/);
  assert.match(html, /docScene\(130, 262, 200, true\)/);
});

test('Prone acupuncture art and companions (người nhà) are wired into the scenes', async () => {
  const html = await read('../public/tu-chan/index.html');
  for (const f of ['cham_nu', 'cham_nam']) await access(new URL(`../public/tu-chan/canh/${f}.webp`, import.meta.url));
  for (const g of ['nam', 'nu']) for (let i = 1; i <= 5; i++) await access(new URL(`../public/tu-chan/canh/nhanha_${g}-${i}.webp`, import.meta.url));
  assert.match(html, /function famInfo\(c\)/);
  assert.match(html, /famAt\(352, 268, 170, famCell\(kind\)\)/);
  assert.match(html, /nu_tre: 'cham_nu' \}\)\[patArt\(S\.c\)\] \|\| 'cham_nam'/);
  /* người nhà chỉ xuất hiện khi kịch bản nói rõ ai đưa bệnh nhân đến */
  const m = html.match(/id="bank-data"[^>]*>([\s\S]*?)<\/script>/), bank = JSON.parse(m[1]);
  const re = /(^|[\s,.;:(])(vợ|chồng|con gái|con trai|con dâu|con rể|người con|mẹ|bố|cha|người nhà|người thân|bạn|chị gái|anh trai|em gái|em trai)((?:(?!được)[^.,;]){0,14}?)\s(đưa|bế|dẫn|đi cùng|chở|phát hiện|cõng|đỡ)(?=[\s,.;]|$)/i;
  assert.ok(bank.filter(c => re.test(c.intro.slice(0, 420))).length >= 15);
});

test('Acceptance gates: no meta sentence in cases; adult inpatients use complete-bed art', async () => {
  const html = await read('../public/tu-chan/index.html');
  const bank = JSON.parse(html.match(/id="bank-data"[^>]*>([\s\S]*?)<\/script>/)[1]);
  for (const c of bank) assert.ok(!/Ca tự soạn/.test(JSON.stringify(c)), c.id + ' still has meta sentence');
  assert.match(html, /const BN_ON = false;/);
  assert.match(html, /const BADCELL = \{ nam_tre: \[5, 6\]/);
  assert.match(html, /function bnAt\(old, cx, yb\)/);
  for (const v of ['nam_tre', 'nu_tre', 'nam_gia', 'nu_gia']) for (let i = 1; i <= 8; i++) await access(new URL(`../public/tu-chan/canh/bn_${v}-${i}.webp`, import.meta.url));
  for (const v of ['nam_tre', 'nu_tre', 'nam_gia', 'nu_gia', 'be_trai', 'be_gai']) for (let i = 1; i <= 7; i++) await access(new URL(`../public/tu-chan/canh/ngt_${v}-${i}.webp`, import.meta.url));
  for (const v of ['be_gai', 'be_trai', 'nam_gia', 'nu_gia']) await access(new URL(`../public/tu-chan/canh/cham_${v}.webp`, import.meta.url));
  assert.match(html, /cham_be_gai/);
});

test('Respiratory cases show oxygen equipment and the matching patient state portrait', async () => {
  const html = await read('../public/tu-chan/index.html');
  assert.match(html, /const oxyProp = /);
  assert.match(html, /\(base === 3 \|\| base === 4\) && st < 85\) return base/);
});
