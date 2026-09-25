import { LEGACY_STUDY_OS } from '../config.js';

export const worldMap = [
  { id: 'garden', title: 'Gia Viên Dược Thảo', area: 'Dược liệu học · phần hiện tại', description: 'Gia Viên bản Study OS; tiến trình hiện có vẫn được giữ nguyên.', state: 'available-legacy', href: `${LEGACY_STUDY_OS}/garden`, icon: '✿' },
  { id: 'garden-continuation', title: 'Khu vườn mở rộng', area: 'Gia Viên Dược Thảo · Game Hub', description: 'Vào Gia Viên trong Game Hub bằng tài khoản HIU TMC đã được duyệt; tiến trình bên trong vườn vẫn mở theo lượt chơi.', state: 'locked-continuation', href: '/garden-continuation', icon: '✿' },
  { id: 'clinic', title: 'HIU Y Quán', area: 'Y quán · nhiều người chơi', description: 'Mở y quán, mô phỏng ca bệnh, khám tại y quán thành viên khác, nhận đánh giá và xếp hạng tín dụng trên máy chủ.', state: 'available-live', href: '/y-quan-live/', icon: '☯' },
  { id: 'four-diagnosis', title: 'Tứ Chẩn Các', area: 'Vọng · Văn · Vấn · Thiết', description: 'Khu vực học thuật được mở theo từng giai đoạn.', state: 'planned', href: '', icon: '診' },
  { id: 'meridian', title: 'Kinh Lạc Đường', area: 'Kinh lạc · huyệt vị', description: 'Khu vực thử thách kinh lạc dự kiến kết nối với 3D Atlas.', state: 'planned', href: '', icon: '經' },
  { id: 'formulas', title: 'Phương Tễ Các', area: 'Phương tễ', description: 'Khu vực nhận dạng và phân tích phương tễ.', state: 'planned', href: '', icon: '方' },
  { id: 'library', title: 'Y Thư Các', area: 'Kinh điển · Trung Y Văn', description: 'Khu vực kết nối tri thức đã được kiểm chứng.', state: 'planned', href: '', icon: '書' },
  { id: 'martial', title: 'Võ Đường', area: 'Dưỡng sinh', description: 'Khu vực dự kiến cho thực hành dưỡng sinh.', state: 'planned', href: '', icon: '武' }
];

export function isLaunchable(place) {
  return (place.state === 'available-legacy' && /^https:\/\//.test(place.href)) || (place.state === 'available-live' && /^\//.test(place.href));
}
