// Đối chiếu số liệu (liều, ngưỡng, thời gian) của từng ca với nguồn đọc được.
//   node scripts/apply-so-lieu.mjs          ghi vào public/tu-chan/index.html
//   node scripts/apply-so-lieu.mjs --check  thoát 1 nếu ngân hàng ca chưa khớp
// Sau đó chạy: node scripts/sync-case-bank.mjs
//
// Thang trạng thái (so_lieu_kiem.trang_thai) — KHÔNG phải "bác sĩ duyệt":
//   da_doi_chieu     mọi con số kiểm được đều khớp nguồn (hoặc đã sửa theo nguồn), không còn ý chưa đọc được
//   mot_phan         còn ý chưa đọc được nguồn
//   can_xem_lai      còn con số nghi lệch, chưa tự quyết
//   khong_co_so_lieu ca không có liều/ngưỡng để kiểm
//   chua_kiem        chưa chạy đối chiếu
// status (draft/reviewed) giữ nguyên: "reviewed" chỉ do bác sĩ duyệt.
import { readFileSync, writeFileSync } from 'node:fs';
import { readBank } from './sync-case-bank.mjs';

const TC = new URL('../public/tu-chan/index.html', import.meta.url);
const RAW = new URL('../data/so-lieu-kiem.json', import.meta.url);
const NGAY = '2026-10-05';

// Sửa theo nguồn đọc được. Áp dụng cho mọi trường chữ của ca (trừ nguon*, verify).
export const FIXES = [
  // Paracetamol: giữ phác đồ 3 túi (nhãn thuốc) nhưng ghi rõ phác đồ 2 túi ANZ 2020; than hoạt có cửa sổ 2 giờ.
  { id: 'noi-cap-cuu-101', from: 'Đã quá 6 giờ, không còn lợi ích rõ trừ khi nghi uống phối hợp thuốc khác; không phải ưu tiên.', to: 'Đã quá cửa sổ khoảng 2 giờ (đến 4 giờ nếu liều rất lớn), không còn lợi ích rõ trừ khi nghi uống phối hợp thuốc khác; không phải ưu tiên.' },
  { id: 'noi-cap-cuu-101', from: 'rồi 100 mg/kg trong 16 giờ|5|', to: 'rồi 100 mg/kg trong 16 giờ (phác đồ 3 túi theo nhãn thuốc; hướng dẫn ANZ 2020 dùng 2 túi: 200 mg/kg trong 4 giờ rồi 100 mg/kg trong 16 giờ)|5|' },
  { id: 'noi-cap-cuu-101', from: 'trong 1000 mL trong 16 giờ.', to: 'trong 1000 mL trong 16 giờ (phác đồ 3 túi theo nhãn thuốc; ANZ 2020 dùng 2 túi: 200 mg/kg trong 4 giờ rồi 100 mg/kg trong 16 giờ).' },
  // Say nóng
  { id: 'noi-cap-cuu-105', from: 'diazepam 5 đến 10 mg tĩnh mạch', to: 'diazepam 10 mg tĩnh mạch, lặp lại theo đáp ứng' },
  { id: 'noi-cap-cuu-105', from: 'Diazepam 5 đến 10 mg tĩnh mạch cho co giật', to: 'Diazepam 10 mg tĩnh mạch (lặp lại theo đáp ứng) cho co giật' },
  // Đuối nước: ngưỡng 90%, theo dõi 4-8 giờ, bỏ số PEEP không có nguồn
  { id: 'noi-cap-cuu-106', from: 'SpO2 dưới khoảng 92%', to: 'SpO2 dưới khoảng 90%' },
  { id: 'noi-cap-cuu-106', from: 'PEEP 5 đến 8 cmH2O hoặc CPAP', to: 'PEEP hoặc CPAP' },
  { id: 'noi-cap-cuu-106', from: 'ít nhất 6 đến 8 giờ', to: 'ít nhất 4 đến 8 giờ' },
  { id: 'noi-cap-cuu-106', from: 'theo dõi 6 đến 8 giờ, X-quang ngực lặp lại', to: 'theo dõi 4 đến 8 giờ, X-quang ngực khi còn triệu chứng' },
  { id: 'noi-cap-cuu-106', from: 'giá trị PEEP 5 đến 8 cmH2O', to: 'mức PEEP' },
  { id: 'noi-cap-cuu-106', from: 'tối thiểu (6 đến 8 giờ)', to: 'tối thiểu (4 đến 8 giờ)' },
  // Methanol: ethanol liều nạp 7,5 mL/kg (MSF)
  { id: 'noi-cap-cuu-107', from: 'ethanol 10% 8 đến 10 mL/kg', to: 'ethanol 10% 7,5 mL/kg' },
  // Bệnh não gan
  { id: 'noi-cap-cuu-108', from: 'lactulose 300 mL pha 700 mL nước', to: 'lactulose 300 mL pha trong 1 lít nước' },
  { id: 'noi-cap-cuu-108', from: '300 mL lactulose pha 700 mL nước', to: '300 mL lactulose pha trong 1 lít nước' },
  { id: 'noi-cap-cuu-108', from: 'thụt tháo 300 mL pha 700 mL nước', to: 'thụt tháo 300 mL pha trong 1 lít nước' },
  { id: 'noi-cap-cuu-108', from: 'tối đa 8 đến 10 mmol/L/24 giờ', to: 'tối đa 8 mmol/L/24 giờ' },
  { id: 'noi-cap-cuu-108', from: 'không tăng quá 8 đến 10 mmol/L trong 24 giờ', to: 'không tăng quá 8 mmol/L trong 24 giờ' },
  { id: 'noi-cap-cuu-108', from: 'không quá 8 đến 10 mmol/L trong 24 giờ', to: 'không quá 8 mmol/L trong 24 giờ' },
  // Tăng kali: canxi gluconat 10% 30 mL (UKKA)
  { id: 'noi-cap-cuu-005', from: 'Canxi gluconat 10% 10 mL (hoặc canxi clorua 10% 5 đến 10 mL) tiêm tĩnh mạch chậm', to: 'Canxi gluconat 10% 30 mL (hoặc canxi clorua 10% 10 mL) tiêm tĩnh mạch chậm trong 5 đến 10 phút' },
  { id: 'noi-cap-cuu-005', from: 'Canxi gluconat 10% 10 mL tĩnh mạch chậm trong 2 đến 3 phút', to: 'Canxi gluconat 10% 30 mL tĩnh mạch chậm trong 5 đến 10 phút' },
  // Trạng thái động kinh: AES chỉ nói lặp lại 1 lần; midazolam IM là liều đơn
  { id: 'noi-cap-cuu-003', from: 'Diazepam 10 mg tiêm tĩnh mạch chậm (hoặc midazolam 10 mg tiêm bắp nếu chưa có đường truyền), lặp lại 1 lần sau 5 phút nếu còn co giật', to: 'Diazepam 10 mg tiêm tĩnh mạch chậm, lặp lại 1 lần nếu còn co giật (hoặc midazolam 10 mg tiêm bắp liều đơn nếu chưa có đường truyền)' },
  // Viêm phổi cộng đồng: ngưỡng oxy 90%; chọn nơi điều trị bằng PSI hoặc CURB-65
  { id: 'noi-ho-hap-003', from: 'SpO2 dưới 92%', to: 'SpO2 dưới 90%' },
  { id: 'noi-ho-hap-003', from: 'chọn nơi điều trị dựa vào CURB-65,', to: 'chọn nơi điều trị dựa vào PSI hoặc CURB-65 kèm đánh giá lâm sàng,' },
  // STEMI: ESC 2023
  { id: 'noi-tim-mach-001', from: 'Thời gian cửa đến bóng dưới 90 phút (trong 120 phút nếu chuyển viện) quyết định lượng cơ tim cứu được.', to: 'Thời gian từ chẩn đoán đến luồn dây càng ngắn càng tốt: mục tiêu trong 60 phút nếu đến thẳng cơ sở có can thiệp, tối đa 120 phút nếu chuyển viện (ESC 2023); thời gian này quyết định lượng cơ tim cứu được.' },
  { id: 'noi-tim-mach-001', from: 'mục tiêu cửa đến bóng dưới 90 phút (tổng thời gian từ chẩn đoán đến luồn dây dưới 120 phút nếu chuyển viện)', to: 'mục tiêu từ chẩn đoán đến luồn dây trong 60 phút (tối đa 120 phút nếu chuyển viện, ESC 2023)' },
  // Đái tháo đường: LDL-C theo mức nguy cơ (ADA)
  { id: 'noi-noi-tiet-002', from: 'LDL-C dưới 1,8 mmol/L khi nguy cơ rất cao', to: 'LDL-C dưới 1,8 mmol/L khi có thêm yếu tố nguy cơ tim mạch (dưới 1,4 mmol/L nếu đã có bệnh tim mạch do xơ vữa)' },
  // Viêm phúc mạc: kháng sinh sau kiểm soát nguồn
  { id: 'ngoai-bung-006', from: 'kháng sinh 4 đến 7 ngày', to: 'kháng sinh khoảng 3 đến 5 ngày sau kiểm soát nguồn nhiễm (kéo dài theo đáp ứng lâm sàng)' },
  // Phospho hữu cơ: hội chứng trung gian đến 96 giờ
  { id: 'ngo-doc-phospho-huu-co', from: 'theo dõi 24 đến 72 giờ', to: 'theo dõi 24 đến 96 giờ' },
  // Viêm túi mật: TG18 không gắn cứng mốc thời gian
  { id: 'ngoai-bung-004', from: 'ưu tiên trong 72 giờ đầu và không quá 7 đến 10 ngày từ khi khởi phát khi đủ điều kiện gây mê', to: 'khi bệnh nhân đủ điều kiện (chỉ số CCI, ASA-PS) tại cơ sở có phẫu thuật viên nội soi kinh nghiệm, không gắn cứng mốc thời gian từ khi khởi phát (TG18); đủ điều kiện gây mê' },
  { id: 'ngoai-bung-004', from: 'tốt nhất trong vòng 72 giờ đến 7 ngày khi đủ điều kiện', to: 'sớm khi bệnh nhân đủ điều kiện (CCI, ASA-PS) tại cơ sở có kinh nghiệm' },
  { id: 'ngoai-bung-004', from: 'Đau hạ sườn phải kéo dài trên 6 giờ kèm sốt', to: 'Đau hạ sườn phải kèm sốt' },
  // Vết thương hỏa khí/hội chứng khoang
  { id: 'ngoai-cap-cuu-005', from: 'đóng muộn hoặc ghép da sau 48-72 giờ', to: 'tái khám và cắt lọc lại sau 48-72 giờ; đóng trì hoãn thường khoảng ngày 5, ghép da nếu không đóng được' },
  // Chấn thương sọ não
  { id: 'ngoai-chan-thuong-001', from: 'theo dõi tri giác và đồng tử mỗi 15 phút', to: 'theo dõi tri giác và đồng tử thường xuyên (tối thiểu mỗi giờ, dày hơn khi diễn biến xấu)' },
  // Xuất huyết tiêu hóa: ngưỡng truyền máu ACG/ICG
  { id: 'ngoai-cap-cuu-104', from: 'Truyền dịch tinh thể ấm thận trọng và truyền hồng cầu lắng để đạt Hb 7 đến 9 g/dL, tránh dịch quá nhiều', to: 'Truyền dịch tinh thể thận trọng và truyền hồng cầu lắng khi Hb dưới 7 g/dL (dưới 8 g/dL nếu có bệnh tim mạch), tránh dịch quá nhiều' },
  { id: 'ngoai-cap-cuu-104', from: 'truyền máu hạn chế (Hb 7 đến 9 g/dL)', to: 'truyền máu hạn chế (ngưỡng Hb dưới 7 g/dL theo ACG; dưới 8 g/dL theo ICG)' },
  { id: 'ngoai-cap-cuu-104', from: 'Hb dưới 7 g/dL (mục tiêu 7 đến 9 g/dL)', to: 'Hb dưới 7 g/dL (dưới 8 g/dL nếu có bệnh tim mạch)' },
];

// Ca còn con số nghi lệch hoặc nguồn thứ cấp chưa đủ tin: chưa tự quyết, không nâng trạng thái.
export const CAN_XEM_LAI = {
  'noi-nhiem-001': 'Tốc độ bù dịch sốt xuất huyết người lớn: bản tóm tắt tự động của QĐ 3705 cho số khác; cần đọc nguyên văn văn bản.',
  'ngoai-chan-thuong-005': 'Mức chỉnh dịch bỏng "10 đến 20% mỗi giờ" so với "khoảng 1/3": cần đối chiếu hướng dẫn ABA nguyên văn.',
  'noi-ho-hap-002': 'Ngưỡng PaCO2 để thở không xâm nhập: BTS dùng trên 6,5 kPa (khoảng 49 mmHg), ca ghi 45 mmHg (GOLD); cần chọn một nguồn.',
  'noi-ho-hap-003': 'Cấy máu/đờm thường quy và mốc kháng sinh trong 4 giờ: ATS/IDSA 2019 không khuyến cáo thường quy cho viêm phổi không nặng.',
};

const WRONG = /^(-|!)/; // tiền tố của lựa chọn sai chủ ý: -, --, !

function strings(o, path, out) {
  if (typeof o === 'string') out.push([path, o]);
  else if (Array.isArray(o)) o.forEach((v, i) => strings(v, path + '[' + i + ']', out));
  else if (o && typeof o === 'object') for (const k of Object.keys(o)) strings(o[k], path ? path + '.' + k : k, out);
  return out;
}
function mapStrings(o, fn, path = '') {
  if (typeof o === 'string') return fn(path, o);
  if (Array.isArray(o)) return o.map((v, i) => mapStrings(v, fn, path + '[' + i + ']'));
  if (o && typeof o === 'object') {
    const r = {};
    for (const k of Object.keys(o)) {
      const p = path ? path + '.' + k : k;
      r[k] = /^(nguon|nguon_kiem|nguon_yhct|verify|so_lieu_kiem)/.test(k) && !path ? o[k] : mapStrings(o[k], fn, p);
    }
    return r;
  }
  return o;
}

export function applyFixes(c) {
  const mine = FIXES.filter(f => f.id === c.id);
  if (!mine.length) return c;
  return mapStrings(c, (p, s) => {
    for (const f of mine) s = s.split(f.from).join(f.to);
    return s;
  });
}

function isWrongOption(c, claim) {
  const acts = c.actions || [];
  const key = claim.text.slice(0, 40);
  for (const a of acts) {
    const i = a.indexOf(key);
    if (i === -1) continue;
    return WRONG.test(a);
  }
  return false;
}

export function summarize(c, raw, fixedIds) {
  const claims = raw.cases[c.id];
  if (!claims) return { ngay: NGAY, trang_thai: 'chua_kiem' };
  const n = { khop: 0, nhat_quan: 0, da_sua: 0, sai_co_y: 0, can_xem_lai: 0, khong_doi_chieu: 0 };
  for (const cl of claims) {
    let v = cl.verdict;
    if (v === 'lech') v = isWrongOption(c, cl) ? 'sai_co_y' : fixedIds.has(c.id) ? 'da_sua' : 'can_xem_lai';
    if (v === 'khong_doi_chieu_duoc') v = 'khong_doi_chieu';
    if (v === 'khop' || v === 'nhat_quan') n[v]++;
    else if (n[v] !== undefined) n[v]++;
    else throw new Error(c.id + ': verdict lạ ' + v);
  }
  if (CAN_XEM_LAI[c.id]) { n.can_xem_lai = Math.max(n.can_xem_lai, 1); }
  const tong = Object.values(n).reduce((a, b) => a + b, 0);
  const ok = (c.nguon_kiem || []).some(s => s.loai === 'pubmed' || s.loai === 'van_ban_byt' || s.loai === 'huong_dan_web');
  let tt;
  if (tong === 0) tt = 'khong_co_so_lieu';
  else if (n.can_xem_lai) tt = 'can_xem_lai';
  else if (n.khong_doi_chieu) tt = 'mot_phan';
  else tt = ok ? 'da_doi_chieu' : 'mot_phan';
  const r = { ngay: NGAY, trang_thai: tt, tong, ...n };
  if (CAN_XEM_LAI[c.id]) r.ghi_chu = CAN_XEM_LAI[c.id];
  return r;
}

export function annotate(bank, raw) {
  const fixedIds = new Set(FIXES.map(f => f.id));
  return bank.map(c => {
    const fixed = applyFixes(c);
    return { ...fixed, so_lieu_kiem: summarize(fixed, raw, fixedIds) };
  });
}

if (process.argv[1] === new URL(import.meta.url).pathname) {
  const html = readFileSync(TC, 'utf8');
  const m = html.match(/(id="bank-data">)([\s\S]*?)(<\/script>)/);
  const bank = readBank(html);
  const raw = JSON.parse(readFileSync(RAW, 'utf8'));
  for (const f of FIXES) {
    const hit = bank.some(c => c.id === f.id && strings(c, '', []).some(([p, s]) => !/^(nguon|verify)/.test(p) && s.includes(f.from)));
    const done = bank.some(c => c.id === f.id && strings(c, '', []).some(([p, s]) => !/^(nguon|verify)/.test(p) && s.includes(f.to)));
    if (!hit && !done) throw new Error('Không tìm thấy chuỗi để sửa: ' + f.id + ' :: ' + f.from.slice(0, 60));
  }
  const next = JSON.stringify(annotate(bank, raw));
  const cur = JSON.stringify(bank);
  if (process.argv.includes('--check')) {
    if (next !== cur) { console.error('Ngân hàng ca chưa khớp: chạy node scripts/apply-so-lieu.mjs'); process.exit(1); }
    console.log('OK');
  } else {
    writeFileSync(TC, html.replace(m[0], m[1] + next + m[3]));
    const c = {};
    for (const x of JSON.parse(next)) c[x.so_lieu_kiem.trang_thai] = (c[x.so_lieu_kiem.trang_thai] || 0) + 1;
    console.log(c);
  }
}
