// Kiểm tra dữ liệu và ảnh của game "Gia Viên Dược Thảo · thực cảnh".
// Đọc đúng khối /* ==== DATA:BEGIN … DATA:END ==== */ trong index.html (dữ liệu thuần, không đụng DOM)
// rồi đối chiếu với các tệp ảnh thật trong assets/. Không cần trình duyệt.
import test from 'node:test';
import assert from 'node:assert/strict';
import vm from 'node:vm';
import { existsSync, readFileSync, readdirSync, statSync } from 'node:fs';
import { join, resolve, basename } from 'node:path';

const ROOT = resolve(import.meta.dirname, '..', 'public', 'gia-vien-duoc-thao-preview');
const html = readFileSync(join(ROOT, 'index.html'), 'utf8');
const block = html.match(/\/\* ==== DATA:BEGIN[^\n]*\n([\s\S]*?)\/\* ==== DATA:END ==== \*\//);
assert.ok(block, 'index.html phải có khối DATA:BEGIN … DATA:END');
const D = vm.runInNewContext(`${block[1]};({ASSET,FP_BASE,photos,plants,quests,scenes,fpStations,plantQuiz,timeQuiz,faceCards})`, {}, { timeout: 3000 });
const { ASSET, FP_BASE, photos, plants, quests, scenes, fpStations, plantQuiz, timeQuiz, faceCards } = D;

const A = join(ROOT, 'assets');
const rel = url => url.replace('/gia-vien-duoc-thao-preview/assets/', '');
// Quy tắc thay đường dẫn giống webSrc/thumbSrc trong index.html
const webFile = src => join(A, 'web', rel(src));
const thumbFile = src => join(A, 'thumb', rel(src));
const uniq = arr => new Set(arr).size === arr.length;
const num = v => typeof v === 'number' && Number.isFinite(v);

// ---- đọc kích thước ảnh (JPEG / WebP) không cần thư viện ----
function imageSize(file) {
  const b = readFileSync(file);
  if (b[0] === 0xff && b[1] === 0xd8) { // JPEG: tìm đoạn SOFn
    let i = 2;
    while (i < b.length) {
      if (b[i] !== 0xff) { i++; continue; }
      const mk = b[i + 1];
      if (mk >= 0xc0 && mk <= 0xcf && ![0xc4, 0xc8, 0xcc].includes(mk)) return { w: b.readUInt16BE(i + 7), h: b.readUInt16BE(i + 5) };
      i += 2 + b.readUInt16BE(i + 2);
    }
  }
  if (b.toString('ascii', 0, 4) === 'RIFF' && b.toString('ascii', 8, 12) === 'WEBP') {
    const k = b.toString('ascii', 12, 16);
    if (k === 'VP8 ') return { w: b.readUInt16LE(26) & 0x3fff, h: b.readUInt16LE(28) & 0x3fff };
    if (k === 'VP8L') { const v = b.readUInt32LE(21); return { w: (v & 0x3fff) + 1, h: ((v >> 14) & 0x3fff) + 1 }; }
    if (k === 'VP8X') return { w: b.readUIntLE(24, 3) + 1, h: b.readUIntLE(27, 3) + 1 };
  }
  throw new Error('Không đọc được kích thước ảnh: ' + file);
}

test('khối dữ liệu đọc được và có đủ các phần', () => {
  for (const [name, v] of Object.entries({ photos, plants, quests, scenes, fpStations, faceCards })) assert.ok(Array.isArray(v) && v.length > 0, `${name} rỗng`);
  assert.equal(ASSET, '/gia-vien-duoc-thao-preview/assets/');
  assert.equal(FP_BASE, ASSET + 'fp/');
});

test('Ảnh thật: id không trùng, đủ ảnh web + thumb, ảnh mới trước ảnh bố cục cũ', () => {
  assert.ok(uniq(photos.map(p => p.id)), 'id ảnh bị trùng');
  for (const p of photos) {
    assert.ok(p.src.startsWith(ASSET), `${p.id}: src sai`);
    assert.ok(existsSync(webFile(p.src)), `${p.id}: thiếu ảnh web ${webFile(p.src)}`);
    assert.ok(existsSync(thumbFile(p.src)), `${p.id}: thiếu ảnh thumb ${thumbFile(p.src)}`);
    assert.ok(p.title && p.desc && Array.isArray(p.tags) && p.tags.length, `${p.id}: thiếu chữ`);
    if (p.fp) assert.ok(fpStations.some(s => s.id === p.fp), `${p.id}: fp ${p.fp} không có trạm`);
  }
  const firstOld = photos.findIndex(p => p.era === 'old');
  assert.ok(firstOld > 0, 'phải có ảnh bố cục cũ và không đứng đầu');
  assert.ok(photos.slice(firstOld).every(p => p.era === 'old'), 'ảnh bố cục cũ phải xếp liền ở cuối');
  for (const p of photos.slice(firstOld)) assert.match(p.title, /^Lưu trữ/, `${p.id}: ảnh cũ phải gắn nhãn Lưu trữ`);
  for (const p of photos.slice(0, firstOld)) assert.doesNotMatch(p.title, /^Lưu trữ/, `${p.id}: ảnh hiện trạng không được gắn Lưu trữ`);
  assert.equal(photos[0].id, 'p-1010-giua', 'khung đầu tiên phải là ảnh mới nhất');
});

test('Khám phá 6 trạm: ảnh có đủ, toạ độ điểm chạm nằm trong ảnh, cây có thật', () => {
  assert.equal(scenes.length, 6);
  scenes.forEach((s, i) => assert.equal(s.id, i));
  for (const s of scenes) {
    assert.ok(existsSync(webFile(s.photo)), `trạm ${s.id}: thiếu ảnh web`);
    assert.ok(existsSync(thumbFile(s.photo)), `trạm ${s.id}: thiếu ảnh thumb`);
    for (const h of s.hotspots) {
      assert.ok(plants.some(p => p.id === h.plantId), `trạm ${s.id}: cây ${h.plantId} không có`);
      assert.ok(num(h.x) && num(h.y) && h.x >= 0 && h.x <= 1 && h.y >= 0 && h.y <= 1, `trạm ${s.id}: toạ độ ngoài ảnh`);
    }
  }
});

test('Trạm 3D: tệp ảnh, thông số phép chiếu khớp kích thước ảnh, liên kết và điểm chạm hợp lệ', () => {
  assert.ok(uniq(fpStations.map(s => s.id)), 'id trạm bị trùng');
  assert.equal(fpStations[0].id, 's-1010-giua', 'trạm đầu tiên phải là ảnh mới nhất');
  // id cũ giữ nguyên để tiến trình đã lưu trên máy người chơi không mất
  for (const id of ['s-0930', 's-0912', 's-0926p', 's-0926w', 's-0710', 's-0606']) assert.ok(fpStations.some(s => s.id === id), `mất trạm cũ ${id}`);
  for (const s of fpStations) {
    assert.ok(['now', 'old'].includes(s.era), `${s.id}: era`);
    assert.ok(['cylinder', 'sphere', 'plane'].includes(s.proj), `${s.id}: proj`);
    const f = join(A, 'fp', s.file);
    assert.ok(existsSync(f), `${s.id}: thiếu ${s.file}`);
    assert.ok(existsSync(join(A, 'fp', s.file.replace(/\.(jpg|webp)$/, '-thumb.jpg'))), `${s.id}: thiếu thumb`);
    if (s.hi) assert.ok(existsSync(join(A, 'fp', s.hi)), `${s.id}: thiếu bản nét cao ${s.hi}`);
    assert.ok(num(s.hfov) && s.hfov > 20 && s.hfov < 200, `${s.id}: hfov`);
    // kích thước ảnh phải đúng với phép chiếu đã hiệu chỉnh, nếu không cảnh 3D bị méo
    const { w, h } = imageSize(f), aspect = w / h, D2R = Math.PI / 180;
    let want;
    if (s.proj === 'cylinder') want = (s.hfov * D2R) / s.v;
    else if (s.proj === 'sphere') want = s.hfov / s.v;
    else want = Math.tan(s.hfov * D2R / 2) / Math.tan(s.vfov * D2R / 2);
    assert.ok(Math.abs(aspect / want - 1) < 0.04, `${s.id}: tỉ lệ ảnh ${aspect.toFixed(3)} lệch phép chiếu ${want.toFixed(3)}`);
    if (s.hi) { const hs = imageSize(join(A, 'fp', s.hi)); assert.ok(Math.abs(hs.w / hs.h / aspect - 1) < 0.01, `${s.id}: bản nét cao khác tỉ lệ`); }
    if (s.proj === 'cylinder') assert.ok(num(s.v) && s.v > 0 && num(s.cy) && s.cy > 0 && s.cy < 1, `${s.id}: v/cy`);
    if (s.proj === 'plane') assert.ok(num(s.vfov), `${s.id}: vfov`);
    for (const l of s.links) {
      assert.ok(fpStations.some(x => x.id === l.to), `${s.id}: liên kết tới ${l.to} không có`);
      assert.ok(num(l.yaw) && typeof l.label === 'string' && l.label.length > 0 && l.label.length <= 24, `${s.id}: nhãn/hướng liên kết`);
    }
    assert.ok(Array.isArray(s.targets), `${s.id}: thiếu targets`);
    for (const t of s.targets) {
      assert.ok(plants.some(p => p.id === t.plant), `${s.id}: cây ${t.plant} không có`);
      assert.ok(num(t.u) && num(t.v) && t.u >= 0 && t.u <= 1 && t.v >= 0 && t.v <= 1 && num(t.r) && t.r > 0 && t.r < 15, `${s.id}: điểm chạm ngoài ảnh`);
    }
  }
});

test('Nhiệm vụ làm được ở cả 3D lẫn 2.5D, thẻ cây hợp lệ', () => {
  assert.ok(uniq(plants.map(p => p.id)) && uniq(quests.map(q => q.id)));
  for (const q of quests) {
    const p = plants.find(x => x.id === q.plantId);
    assert.ok(p, `nhiệm vụ ${q.id}: cây ${q.plantId} không có`);
    assert.ok(scenes.some(s => s.hotspots.some(h => h.plantId === p.id)), `${p.id}: không tìm được trong 2.5D`);
    assert.ok(fpStations.some(s => s.era === 'now' && s.targets.some(t => t.plant === p.id)), `${p.id}: không tìm được trong 3D hiện trạng`);
    assert.ok(!fpStations.some(s => s.era === 'old' && s.targets.length), 'trạm lưu trữ không được có điểm tìm cây');
    // mô tả nhiệm vụ không lộ tên cây (tên chỉ hiện khi tìm đúng)
    const bare = p.name.replace(/ \(chưa chốt\)/, '').toLowerCase();
    assert.ok(!`${q.title} ${q.desc}`.toLowerCase().includes(bare), `nhiệm vụ ${q.id} lộ tên cây "${bare}"`);
    const z = plantQuiz[p.id];
    assert.ok(z && z.opts.length >= 2 && Number.isInteger(z.ok) && z.ok >= 0 && z.ok < z.opts.length, `${p.id}: câu hỏi thẻ cây`);
  }
  assert.equal(quests.length, plants.length, 'mỗi cây một nhiệm vụ');
});

test('Tên cây của nhiệm vụ không lộ ở khung ảnh, trạm 2.5D và trạm 3D; không có nút chỉ sẵn vị trí cây', () => {
  // Tên chỉ hiện khi người chơi tìm đúng cây. Tách "Nhóm gừng/riềng (chưa chốt)" thành "gừng" và "riềng".
  const words = [...new Set(plants.flatMap(p => p.name.replace(/\(.*?\)/g, '').split('/').map(s => s.replace(/^nhóm\s+/i, '').trim().toLowerCase()).filter(Boolean)))];
  assert.ok(words.length >= plants.length, 'phải rút được tên cây để kiểm tra');
  const has = (text, w) => new RegExp(`(^|[^\\p{L}])${w.replace(/[.*+?^${}()|[\]\\]/g, '\\$&')}([^\\p{L}]|$)`, 'iu').test(text);
  const texts = [
    ...photos.map(p => [`ảnh ${p.id}`, [p.title, p.desc, ...(p.tags || [])].join(' | ')]),
    ...scenes.map(s => [`trạm 2.5D ${s.id}`, [s.name, s.desc].join(' | ')]),
    ...fpStations.map(s => [`trạm 3D ${s.id}`, [s.name, s.desc, ...(s.links || []).map(l => l.label)].join(' | ')]),
  ];
  for (const [label, text] of texts) for (const w of words) assert.ok(!has(text, w), `${label} lộ tên cây "${w}"`);
  // Nút "Tới điểm nóng" từng chọn sẵn cây của trạm và hiện tên: trái với cách chơi tự tìm.
  assert.doesNotMatch(html, /Tới điểm nóng|id="focusBtn"/);
});

test('Câu đối chiếu thời gian chỉ gắn với trạm lưu trữ; ảnh nhận mặt có đủ', () => {
  for (const [sid, t] of Object.entries(timeQuiz)) {
    const s = fpStations.find(x => x.id === sid);
    assert.ok(s && s.era === 'old', `${sid}: câu đối chiếu phải gắn trạm lưu trữ`);
    assert.ok(Number.isInteger(t.ok) && t.ok >= 0 && t.ok < t.opts.length);
  }
  for (const c of faceCards) assert.ok(existsSync(join(A, c.img)), `${c.id}: thiếu ảnh ${c.img}`);
});

test('Nội dung không có hướng dẫn điều trị/liều dùng', () => {
  const text = JSON.stringify({ photos, plants, quests, scenes, fpStations, plantQuiz, timeQuiz, faceCards });
  assert.doesNotMatch(text, /liều (dùng|lượng)|điều trị|chữa (bệnh|khỏi)|trị (bệnh|ho|đau|ung thư)|\buống mỗi|\d\s?mg\b/i);
});

test('Không có tệp ảnh thừa trong assets và dung lượng nằm trong ngân sách', () => {
  const used = { web: new Set(), thumb: new Set(), fp: new Set() };
  for (const p of [...photos, ...scenes.map(s => ({ src: s.photo }))]) { used.web.add(basename(p.src)); used.thumb.add(basename(p.src)); }
  for (const s of fpStations) {
    used.fp.add(s.file); used.fp.add(s.file.replace(/\.(jpg|webp)$/, '-thumb.jpg'));
    if (s.hi) used.fp.add(s.hi);
  }
  const limits = { web: 650 * 1024, thumb: 60 * 1024, fp: 1400 * 1024 };
  for (const dir of ['web', 'thumb', 'fp']) {
    for (const f of readdirSync(join(A, dir))) {
      assert.ok(used[dir].has(f), `assets/${dir}/${f} không được dùng ở đâu (xoá hoặc khai báo)`);
      assert.ok(statSync(join(A, dir, f)).size <= limits[dir], `assets/${dir}/${f} quá nặng cho di động`);
    }
    for (const f of used[dir]) assert.ok(existsSync(join(A, dir, f)), `thiếu assets/${dir}/${f}`);
  }
});

test('Điểm tối đa và hạng khớp nhau (không thể lên hạng cao nhất nếu thiếu điểm)', () => {
  const P = html.match(/const POINTS=\{([^}]*)\}/)[1];
  const pts = Object.fromEntries(P.split(',').map(x => x.split(':')).map(([k, v]) => [k, +v]));
  const ranks = [...html.matchAll(/\[(\d+),'[^']+'\]/g)].map(m => +m[1]).filter((n, i, a) => a.indexOf(n) === i);
  const max = scenes.length * pts.scene + fpStations.filter(s => s.era === 'now').length * pts.fp + plants.length * (pts.quest + pts.quizFirst) + Object.keys(timeQuiz).length * pts.time + faceCards.length * pts.faceFirst;
  assert.ok(Math.max(...ranks) < max, `hạng cao nhất (${Math.max(...ranks)}) phải thấp hơn điểm tối đa ${max}`);
});

test('Video đi bộ và poster có mặt, được dùng trong trang và nằm trong ngân sách di động', () => {
  const walkDir = join(A, 'walk');
  assert.ok(existsSync(join(walkDir, 'vuon-di-bo.mp4')), 'thiếu assets/walk/vuon-di-bo.mp4');
  assert.ok(existsSync(join(walkDir, 'poster.jpg')), 'thiếu assets/walk/poster.jpg');
  assert.ok(statSync(join(walkDir, 'vuon-di-bo.mp4')).size <= 8 * 1024 * 1024, 'video đi bộ quá nặng cho di động');
  assert.ok(statSync(join(walkDir, 'poster.jpg')).size <= 200 * 1024, 'poster quá nặng');
  for (const f of readdirSync(walkDir)) assert.match(html, new RegExp(f.replace('.', '\\.')), `assets/walk/${f} không được dùng ở đâu`);
});

test('Chế độ Đi bộ có chặng theo thứ tự thời gian và không nêu tên cây', () => {
  const m = html.match(/const WALK=\{[\s\S]*?chapters:\[([\s\S]*?)\]\};/);
  assert.ok(m, 'thiếu khai báo WALK.chapters');
  const ts = [...m[1].matchAll(/\{t:(\d+(?:\.\d+)?)/g)].map(x => +x[1]);
  assert.ok(ts.length >= 4, 'cần ít nhất 4 chặng');
  assert.deepEqual(ts, [...ts].sort((a, b) => a - b), 'các chặng phải theo thứ tự thời gian');
  assert.equal(ts[0], 0, 'chặng đầu phải bắt đầu từ 0 giây');
  for (const p of plants) assert.doesNotMatch(m[1], new RegExp(`\\b${p.name.replace(/[.*+?^${}()|[\]\\]/g, '\\$&')}\\b`, 'i'));
});
