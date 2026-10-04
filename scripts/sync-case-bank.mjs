// Đồng bộ ngân hàng ca: public/tu-chan/index.html là nguồn chuẩn (141 ca).
// Phòng học (public/phong-hoc/index.html) giữ bản sao cùng nội dung lâm sàng;
// riêng `intro` và `name` do từng chế độ tự viết nên không bị ghi đè.
// Dùng: node scripts/sync-case-bank.mjs          (ghi file)
//       node scripts/sync-case-bank.mjs --check  (chỉ kiểm tra, thoát 1 nếu lệch)
import { readFileSync, writeFileSync } from 'node:fs';

const TC = new URL('../public/tu-chan/index.html', import.meta.url);
const PH = new URL('../public/phong-hoc/index.html', import.meta.url);
export const OWN_FIELDS = ['intro', 'name'];
export const EXTRA_FIELDS = ['track', 'mode', 'nguon_kiem', 'nguon_yhct', 'so_lieu_kiem'];

export function readBank(html) {
  const m = html.match(/id="bank-data">([\s\S]*?)<\/script>/);
  return JSON.parse(m[1]);
}
export function readPhBank(html) {
  const start = html.indexOf('const BANK = ') + 'const BANK = '.length;
  let depth = 0, i = start, inStr = false, esc = false;
  for (; i < html.length; i++) {
    const ch = html[i];
    if (inStr) { if (esc) esc = false; else if (ch === '\\') esc = true; else if (ch === '"') inStr = false; continue; }
    if (ch === '"') inStr = true;
    else if (ch === '[') depth++;
    else if (ch === ']') { depth--; if (depth === 0) { i++; break; } }
  }
  return { start, end: i, bank: JSON.parse(html.slice(start, i)) };
}
export function buildPhBank(tc, ph) {
  const byId = new Map(tc.map(c => [c.id, c]));
  return ph.map(p => {
    const t = byId.get(p.id);
    if (!t) throw new Error('Phòng học có ca không có trong Tứ Chẩn: ' + p.id);
    const out = {};
    for (const k of Object.keys(p)) out[k] = OWN_FIELDS.includes(k) ? p[k] : t[k];
    for (const k of EXTRA_FIELDS) if (t[k] !== undefined) out[k] = t[k];
    return out;
  });
}
if (process.argv[1] === new URL(import.meta.url).pathname) {
  const tc = readBank(readFileSync(TC, 'utf8'));
  const html = readFileSync(PH, 'utf8');
  const { start, end, bank } = readPhBank(html);
  const ids = new Set(bank.map(c => c.id));
  const missing = tc.filter(c => !ids.has(c.id)).map(c => c.id);
  if (missing.length) { console.error('Phòng học thiếu ca:', missing.join(', ')); process.exit(1); }
  const next = JSON.stringify(buildPhBank(tc, bank));
  const cur = html.slice(start, end);
  if (process.argv.includes('--check')) { if (next !== cur) { console.error('Phòng học lệch ngân hàng chuẩn. Chạy: node scripts/sync-case-bank.mjs'); process.exit(1); } console.log('Phòng học khớp ngân hàng chuẩn.'); }
  else { writeFileSync(PH, html.slice(0, start) + next + html.slice(end)); console.log('Đã đồng bộ', bank.length, 'ca vào Phòng học.'); }
}
