// Gắn kết quả tra cứu nguồn (data/nguon-registry.json) vào từng ca của ngân hàng chuẩn.
// Mỗi ca nhận `nguon_kiem`: [{i, loai, id?, pmid?, doi?, url?, so?, ngay?, ghi_chu?}] — i là chỉ số trong `nguon`.
// loai: pubmed | huong_dan_web (trang chính thức đã xác nhận) | van_ban_byt (đã xác nhận tồn tại, CHƯA đối chiếu nội dung) | can_sua | khong_xac_nhan
//       | khong_dinh_danh | sach_giao_trinh | chua_tra.
// Đây là kiểm tra tự động, không thay thế thẩm định chuyên môn: ca vẫn ở trạng thái draft.
// Dùng: node scripts/apply-source-registry.mjs          (ghi file rồi chạy sync-case-bank)
//       node scripts/apply-source-registry.mjs --check  (thoát 1 nếu lệch)
import { readFileSync, writeFileSync } from 'node:fs';
import { readBank } from './sync-case-bank.mjs';

const TC = new URL('../public/tu-chan/index.html', import.meta.url);
const REG = JSON.parse(readFileSync(new URL('../data/nguon-registry.json', import.meta.url), 'utf8'));
const PLACEHOLDER = /xem can_doi_chieu|bản cập nhật hiện hành|bản cập nhật gần nhất|số quyết định và|quyết định hiện hành|bản hiện/i;
const BOOK = /giáo trình|sabiston|rockwood|mandell|bệnh học ngoại khoa|townsend|textbook/i;
const FIX = [[/^Ten Broek RPG et al\. Benchmarking of the Management of adhesive small bowel obstruction.*$/,
  'Ten Broek RPG et al. Bologna guidelines for diagnosis and management of adhesive small bowel obstruction (ASBO): 2017 update of the evidence-based guidelines from the WSES ASBO working group. World J Emerg Surg 2018;13:24.']];

// Nguồn trích sai chủ đề: gỡ khỏi ca (QĐ 3319/QĐ-BYT là đái tháo đường típ 2, không phải nội tiết chung/bão giáp).
const REMOVE = [{ id: 'noi-noi-tiet-001', re: /3319\/QĐ-BYT/ }];

export function classify(s) {
  const t = s.toLowerCase();
  const hits = REG.muc.filter(e => e.alt.some(g => g.every(x => t.includes(x))) && !(e.no || []).some(x => t.includes(x)));
  if (hits.length) return hits.map(e => {
    const o = { loai: e.loai, id: e.id };
    for (const k of ['pmid', 'doi', 'url', 'so', 'ngay', 'ghi_chu']) if (e[k]) o[k] = e[k];
    return o;
  });
  if (PLACEHOLDER.test(s)) return [{ loai: 'khong_dinh_danh' }];
  if (BOOK.test(s)) return [{ loai: 'sach_giao_trinh' }];
  return [{ loai: 'chua_tra' }];
}

export function annotate(bank) {
  return bank.map(c => {
    const out = { ...c };
    let nguon = (c.nguon || []).map(s => { for (const [re, to] of FIX) if (re.test(s)) return to; return s; });
    for (const r of REMOVE) if (r.id === c.id) { const rest = nguon.filter(s => !r.re.test(s)); if (rest.length) nguon = rest; }
    if (c.mode === 'tay') {
      const yhct = nguon.filter(s => s.includes('5013/QĐ-BYT'));
      const rest = nguon.filter(s => !s.includes('5013/QĐ-BYT'));
      if (yhct.length && rest.length) { nguon = rest; out.nguon_yhct = yhct; }
    }
    out.nguon = nguon;
    out.nguon_kiem = nguon.flatMap((s, i) => classify(s).map(k => ({ i, ...k })));
    return out;
  });
}

if (process.argv[1] === new URL(import.meta.url).pathname) {
  const html = readFileSync(TC, 'utf8');
  const m = html.match(/(id="bank-data">)([\s\S]*?)(<\/script>)/);
  const bank = readBank(html);
  const next = JSON.stringify(annotate(bank));
  if (process.argv.includes('--check')) {
    if (next !== JSON.stringify(bank)) { console.error('Nguồn chưa được gắn kết quả tra cứu. Chạy: node scripts/apply-source-registry.mjs'); process.exit(1); }
    console.log('Kết quả tra cứu nguồn đã khớp.');
  } else {
    writeFileSync(TC, html.replace(m[0], m[1] + next + m[3]));
    const cnt = {};
    for (const c of annotate(bank)) for (const k of c.nguon_kiem) cnt[k.loai] = (cnt[k.loai] || 0) + 1;
    console.log('Đã gắn nguon_kiem cho', bank.length, 'ca.', cnt);
  }
}
