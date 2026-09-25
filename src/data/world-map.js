import { LEGACY_STUDY_OS } from '../config.js';

export const worldMap = [
  { id: 'garden', title: 'Gia Viên Dược Thảo', area: 'Dược liệu học · phần hiện tại', description: 'Hoàn thành các vòng tại Study OS để đủ điều kiện mở phần tiếp nối trong Game Hub.', state: 'available-legacy', href: `${LEGACY_STUDY_OS}/garden`, icon: '✿' },
  { id: 'garden-continuation', title: 'Khu vườn mở rộng', area: 'Gia Viên Dược Thảo · Game Hub', description: 'Tiếp tục Gia Viên trong Game Hub sau khi hệ thống xác nhận hoàn thành đủ 9 ô tại Study OS.', state: 'locked-continuation', href: '/garden-continuation', icon: '✿' },
  { id: 'clinic', title: 'HIU Y Quán', area: 'Lâm sàng mô phỏng', description: 'Luyện tư duy lâm sàng qua runtime hiện có.', state: 'available-legacy', href: `${LEGACY_STUDY_OS}/garden?game=hiu-y-quan`, icon: '☯' },
  { id: 'four-diagnosis', title: 'Tứ Chẩn Các', area: 'Vọng · Văn · Vấn · Thiết', description: 'Khu vực học thuật được mở theo từng giai đoạn.', state: 'planned', href: '', icon: '診' },
  { id: 'meridian', title: 'Kinh Lạc Đường', area: 'Kinh lạc · huyệt vị', description: 'Khu vực thử thách kinh lạc dự kiến kết nối với 3D Atlas.', state: 'planned', href: '', icon: '經' },
  { id: 'formulas', title: 'Phương Tễ Các', area: 'Phương tễ', description: 'Khu vực nhận dạng và phân tích phương tễ.', state: 'planned', href: '', icon: '方' },
  { id: 'library', title: 'Y Thư Các', area: 'Kinh điển · Trung Y Văn', description: 'Khu vực kết nối tri thức đã được kiểm chứng.', state: 'planned', href: '', icon: '書' },
  { id: 'martial', title: 'Võ Đường', area: 'Dưỡng sinh', description: 'Khu vực dự kiến cho thực hành dưỡng sinh.', state: 'planned', href: '', icon: '武' }
];

export function isLaunchable(place) {
  return place.state === 'available-legacy' && /^https:\/\//.test(place.href);
}
