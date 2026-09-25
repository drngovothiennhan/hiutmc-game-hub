const labels = [
  'Nhận dạng dược liệu', 'Tính vị – quy kinh', 'Công năng – chủ trị',
  'Tứ chẩn', 'Biện chứng', 'Phương tễ', 'Kinh lạc', 'Huyệt', 'Lâm sàng'
];

export function renderSkillMatrix() {
  return `<section class="card"><div class="section-heading"><div><p class="eyebrow">MA TRẬN NĂNG LỰC</p><h2>Năng lực học thuật</h2></div><span class="tag tag-muted">Chưa ghi nhận sự kiện</span></div><p class="muted">Các chỉ số chỉ xuất hiện sau khi có hoạt động thật được hệ thống xác minh. Không cộng điểm từ đăng nhập hoặc thời gian online.</p><div class="skill-grid">${labels.map(label => `<div class="skill-item"><span>${label}</span><span class="skill-empty">Chưa có dữ liệu</span></div>`).join('')}</div></section>`;
}
