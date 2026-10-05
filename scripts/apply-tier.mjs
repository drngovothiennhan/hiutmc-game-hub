// Phân quyền ca theo nhóm người chơi (khách / thành viên ngoài / thành viên HIU TMC).
// Nguồn: data/tier-config.json. Ghi trường `min_tier` vào ngân hàng ca (guest | outside | full).
// Dùng: node scripts/apply-tier.mjs          (ghi file)
//       node scripts/apply-tier.mjs --check  (chỉ kiểm tra)
//       node scripts/apply-tier.mjs --sql    (in câu lệnh SQL đồng bộ máy chủ)
import { readFileSync, writeFileSync } from 'node:fs';

const TC = new URL('../public/tu-chan/index.html', import.meta.url);
const CFG = new URL('../data/tier-config.json', import.meta.url);

export function tierOfCase(id, cfg) {
  return cfg.guest.includes(id) ? 'guest' : cfg.full.includes(id) ? 'full' : 'outside';
}
export function applyTier(bank, cfg) {
  const ids = new Set(bank.map(c => c.id));
  for (const id of [...cfg.guest, ...cfg.full]) if (!ids.has(id)) throw new Error('tier-config có id không tồn tại: ' + id);
  const dup = cfg.guest.filter(id => cfg.full.includes(id));
  if (dup.length) throw new Error('id nằm ở cả guest và full: ' + dup.join(', '));
  return bank.map(c => ({ ...c, min_tier: tierOfCase(c.id, cfg) }));
}
export function tierSql(cfg) {
  const list = a => a.map(i => `'${i}'`).join(', ');
  return `update y_quan_private.tu_chan_catalog set min_tier = 'outside';\n` +
    `update y_quan_private.tu_chan_catalog set min_tier = 'guest' where case_id in (${list(cfg.guest)});\n` +
    `update y_quan_private.tu_chan_catalog set min_tier = 'full' where case_id in (${list(cfg.full)});`;
}

if (process.argv[1] === new URL(import.meta.url).pathname) {
  const cfg = JSON.parse(readFileSync(CFG, 'utf8'));
  const html = readFileSync(TC, 'utf8');
  const m = html.match(/(id="bank-data">)([\s\S]*?)(<\/script>)/);
  const bank = JSON.parse(m[2]);
  const next = JSON.stringify(applyTier(bank, cfg));
  if (process.argv.includes('--sql')) console.log(tierSql(cfg));
  else if (process.argv.includes('--check')) { if (next !== m[2]) { console.error('min_tier lệch tier-config. Chạy: node scripts/apply-tier.mjs'); process.exit(1); } console.log('min_tier khớp tier-config.'); }
  else { writeFileSync(TC, html.replace(m[0], m[1] + next + m[3])); const c = JSON.parse(next); console.log('guest', c.filter(x => x.min_tier === 'guest').length, 'outside', c.filter(x => x.min_tier === 'outside').length, 'full', c.filter(x => x.min_tier === 'full').length); }
}
