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

test('Catalog on the server covers the whole bank: 40 seeded + 101 enabled by the owner on 2026-10-04 + 15 added on 2026-10-05', async () => {
  const html = await read('../public/tu-chan/index.html');
  const bank = JSON.parse(html.match(/id="bank-data">([\s\S]*?)<\/script>/)[1]);
  assert.equal(bank.length, 156);
  const room = c => (c.setting === 'capcuu' || c.setting === 'giuong') ? 'capcuu' : 'kham';
  const seed = await read('../supabase/migrations/20261001160000_vien_thuc_hanh_shifts_v1.sql');
  const more = await read('../supabase/migrations/20261004080000_vien_thuc_hanh_bat_ca_nhap.sql') + await read('../supabase/migrations/20261005130000_vien_thuc_hanh_them_5_ca_noi.sql') + await read('../supabase/migrations/20261005150000_vien_thuc_hanh_them_5_ca_noi_lo2.sql') + await read('../supabase/migrations/20261005170000_vien_thuc_hanh_them_5_ca_noi_lo3.sql');
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
  assert.match(html, /docScene\(kid \? 262 : 288, 262, 200, false\)/);
  assert.match(html, /docScene\(130, 262, 200, true\)/);
});

test('Prone acupuncture art and companions (người nhà) are wired into the scenes', async () => {
  const html = await read('../public/tu-chan/index.html');
  for (const f of ['cham_nu', 'cham_nam']) await access(new URL(`../public/tu-chan/canh/${f}.webp`, import.meta.url));
  for (const g of ['nam', 'nu']) for (let i = 1; i <= 5; i++) await access(new URL(`../public/tu-chan/canh/nhanha_${g}-${i}.webp`, import.meta.url));
  assert.match(html, /function famInfo\(c\)/);
  assert.match(html, /famAt\(kid \? 352 : 360, 268, 170, famCell\(kind\)\)/);
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

test('bed scenes use the 59 side-view bed images; the missing nam_gia-2 maps to a real image, never the code-drawn composite', async () => {
  const html = await read('../public/tu-chan/index.html');
  assert.match(html, /const BED_OLD = \[\];/);
  assert.match(html, /const BED_ALIAS = \{ 'nam_gia-2': 'nam_gia-1' \};/);
  for (const v of ['nam_gia', 'nu_gia', 'nam_tre', 'nu_tre', 'be_trai', 'be_gai'])
    for (let i = 1; i <= 10; i++) {
      if (v === 'nam_gia' && i === 2) continue;
      await access(new URL(`../public/tu-chan/canh/giuong/${v}-${i}.webp`, import.meta.url));
    }
});

test('Play mode follows the room: emergency and ward cases are modern medicine only, the YHCT room combines East and West', async () => {
  const html = await read('../public/tu-chan/index.html');
  const bank = JSON.parse(html.match(/id="bank-data">([\s\S]*?)<\/script>/)[1]);
  const tcmOpt = ['bd', 'bc', 'the', 'phap', 'phuong', 'huyet'];
  const modern = c => c.setting === 'capcuu' || c.setting === 'giuong';
  for (const c of bank) {
    assert.ok(['tay', 'dongtay'].includes(c.mode), c.id + ' needs mode tay|dongtay');
    assert.equal(c.mode === 'tay', modern(c), c.id + ': mode must follow the room (capcuu/giuong = tay)');
    if (c.mode === 'tay') {
      assert.ok(['noi', 'ngoai'].includes(c.track), c.id + ': a modern-only case belongs to Noi or Ngoai');
      assert.ok(!c.exam.some(e => 'VMT'.includes(e[0])), c.id + ': modern exam must not use Vong/Van/Thiet groups');
      assert.ok(!c.exam.some(e => /lưỡi/i.test(e[1])), c.id + ': modern exam must not ask for the tongue');
      for (const k of tcmOpt) assert.ok(!(c.opt && c.opt[k]), c.id + ' modern case must not carry opt.' + k);
      assert.ok(c.actions.some(a => a.startsWith('!')), c.id + ' needs a dangerous-action trap');
      assert.ok(c.exam.filter(e => e[3] === 'e').length >= 3, c.id + ' needs >= 3 key exam items');
      assert.ok(!/châm cứu|thuốc thang/i.test(c.actions.join(' ')), c.id + ': no acupuncture or decoction actions in emergency play');
    } else {
      assert.equal(c.track, 'yhct', c.id + ': combined East-West cases live in the YHCT room');
      for (const k of tcmOpt) assert.ok(c.opt && c.opt[k], c.id + ' missing opt.' + k);
      assert.ok(!c.yhct_hau_cap, c.id + ': yhct_hau_cap only belongs to modern cases');
    }
  }
  const sql = await read('../supabase/migrations/20261004150000_vien_thuc_hanh_chuan_hoa_khoa_v1.sql');
  for (const c of bank.filter(c => c.yhct_hau_cap && c.yhct_hau_cap.opt)) assert.ok(sql.includes(`'${c.id}'`), 'catalog migration missing ' + c.id);
  assert.doesNotMatch(sql, /drop\s|delete\s+from|truncate/i, 'additive migration only');
  assert.match(html, /const trackOf = c => c\.track \|\|/);
});

test('Learning room shares the duty case bank (one bank, two modes)', async () => {
  const { readBank, readPhBank, buildPhBank } = await import('../scripts/sync-case-bank.mjs');
  const tc = readBank(await read('../public/tu-chan/index.html'));
  const { bank: ph } = readPhBank(await read('../public/phong-hoc/index.html'));
  assert.equal(ph.length, tc.length, 'both modes must carry the same number of cases');
  assert.deepEqual(ph, buildPhBank(tc, ph), 'run: node scripts/sync-case-bank.mjs');
  const html = await read('../public/phong-hoc/index.html');
  assert.match(html, /const trackOf=c=>c\.track\|\|/);
  const byId = new Map(tc.map(c => [c.id, c]));
  for (const c of ph) {
    const t = byId.get(c.id);
    assert.equal(c.track, t.track, c.id + ' track differs');
    assert.equal(c.mode, t.mode, c.id + ' mode differs');
    if (c.mode === 'tay') assert.ok(!c.exam.some(e => 'VMT'.includes(e[0])), c.id + ': modern case must not use Vong/Van/Thiet in study mode');
  }
});

test('Every case source carries a verification record; modern cases cite no TCM framework', async () => {
  const { readBank } = await import('../scripts/sync-case-bank.mjs');
  const reg = JSON.parse(await read('../data/nguon-registry.json'));
  assert.ok(reg.cach && reg.ngay, 'registry must state method and date');
  const bank = readBank(await read('../public/tu-chan/index.html'));
  const LOAI = new Set(['pubmed', 'huong_dan_web', 'van_ban_byt', 'can_sua', 'khong_xac_nhan', 'khong_dinh_danh', 'sach_giao_trinh', 'chua_tra']);
  for (const c of bank) {
    assert.ok(Array.isArray(c.nguon_kiem), c.id + ' missing nguon_kiem');
    const covered = new Set(c.nguon_kiem.map(k => k.i));
    c.nguon.forEach((_, i) => assert.ok(covered.has(i), c.id + ' source #' + i + ' has no verification record'));
    for (const k of c.nguon_kiem) {
      assert.ok(LOAI.has(k.loai), c.id + ': unknown loai ' + k.loai);
      if (k.loai === 'pubmed') assert.match(k.pmid, /^\d{6,8}$/, c.id + ': pubmed entry needs a PMID');
      if (k.loai === 'huong_dan_web') assert.match(k.url, /^https:\/\//, c.id + ': web guideline needs an https url');
      if (k.loai === 'van_ban_byt') assert.ok(k.so && k.url, c.id + ': MoH entry needs so + url');
    }
    if (c.mode === 'tay') {
      assert.ok(!c.nguon.some(s => s.includes('5013/QĐ-BYT')), c.id + ': TCM framework (5013) must not be cited in modern-only play');
      assert.ok(!c.nguon.some(s => s.includes('3319/QĐ-BYT')) || c.id !== 'noi-noi-tiet-001', 'thyroid storm must not cite the diabetes decision');
    }
    assert.equal(c.status, 'draft', c.id + ': automated source check does not make a case VERIFIED');
  }
  assert.ok(bank.filter(c => c.mode === 'tay' && c.nguon_kiem.some(k => ['pubmed', 'huong_dan_web', 'van_ban_byt'].includes(k.loai))).length >= 85, 'most modern cases should have at least one confirmed source');
  const seen = new Set();
  for (const e of reg.muc) { assert.ok(!seen.has(e.id), 'duplicate registry id ' + e.id); seen.add(e.id); }
});

test('Result screen shows a four-step debrief, not only a score', async () => {
  const html = await read('../public/tu-chan/index.html');
  assert.match(html, /function debrief\(dead\)/);
  for (const t of ['Bạn đã nghĩ gì', 'Bằng chứng bạn bỏ sót', 'Quyết định làm đổi tiên lượng', 'Nếu làm lại, việc đầu tiên']) assert.ok(html.includes(t), 'debrief missing step: ' + t);
  assert.match(html, /\$\{debrief\(dead\)\}[\s\S]*<details class="dd">[\s\S]*r\.rows\.map/, 'debrief comes before the collapsed score breakdown');
  assert.match(html, /không phải từ điều bạn nghĩ/, 'must say the debrief is reconstructed from actions, not from player thoughts');
});

test('Numeric data check: a case is only "da_doi_chieu" when nothing unread or doubtful is left, and it never becomes "reviewed"', async () => {
  const { readBank } = await import('../scripts/sync-case-bank.mjs');
  const { FIXES, CAN_XEM_LAI } = await import('../scripts/apply-so-lieu.mjs');
  const bank = readBank(await read('../public/tu-chan/index.html'));
  const TT = new Set(['da_doi_chieu', 'mot_phan', 'can_xem_lai', 'khong_co_so_lieu', 'chua_kiem']);
  for (const c of bank) {
    const k = c.so_lieu_kiem;
    assert.ok(k && TT.has(k.trang_thai), c.id + ': missing so_lieu_kiem');
    assert.equal(c.status, 'draft', c.id + ': only a physician makes a case "reviewed"');
    if (k.trang_thai === 'da_doi_chieu') {
      assert.equal(k.khong_doi_chieu, 0, c.id);
      assert.equal(k.can_xem_lai, 0, c.id);
      assert.ok(k.tong > 0, c.id);
      assert.ok(c.nguon_kiem.some(s => ['pubmed', 'van_ban_byt', 'huong_dan_web'].includes(s.loai)), c.id + ': needs one confirmed source');
    }
  }
  for (const id of Object.keys(CAN_XEM_LAI)) assert.equal(bank.find(c => c.id === id).so_lieu_kiem.trang_thai, 'can_xem_lai');
  assert.ok(bank.filter(c => c.so_lieu_kiem.trang_thai === 'da_doi_chieu').length >= 50);
  // Every correction is in the bank and the superseded wording is gone.
  for (const f of FIXES) {
    const t = JSON.stringify(bank.find(c => c.id === f.id), (key, v) => /^(nguon|verify|so_lieu)/.test(key) ? undefined : v);
    assert.ok(t.includes(JSON.stringify(f.to).slice(1, -1)), f.id + ': correction missing: ' + f.to.slice(0, 50));
  }
  const html = await read('../public/tu-chan/index.html');
  assert.match(html, /Số liệu đã đối chiếu/);
});
