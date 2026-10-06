import { PROFILES, convertValue } from './generator.mjs';

export const CBC_CODES = new Set([
  'khong_xac_thuc','chua_mo','level_khong_hop_le','qua_3_luot_mo',
  'qua_10_luot_ngay','chua_co_scenario','khong_tim_thay',
  'answers_khong_hop_le','da_nop'
]);

export function messageForCode(code) {
  const messages={
    khong_xac_thuc:'Vui lòng đăng nhập HIU TMC để tiếp tục.',
    chua_mo:'Phòng CBC hiện chưa mở.',
    level_khong_hop_le:'Mức độ bài học không hợp lệ.',
    qua_3_luot_mo:'Bạn đã đạt giới hạn 3 lượt đang mở.',
    qua_10_luot_ngay:'Bạn đã đạt giới hạn 10 lượt mới trong ngày.',
    chua_co_scenario:'Chưa có kịch bản CBC được duyệt ở mức này.',
    khong_tim_thay:'Không tìm thấy lượt học này.',
    answers_khong_hop_le:'Câu trả lời chưa hợp lệ. Hãy chọn đủ 13 chỉ số.',
    da_nop:'Lượt này đã được nộp.'
  };
  return messages[code] || 'Có lỗi khi xử lý. Vui lòng thử lại sau.';
}

export function convertProfileValue(key, value, fromProfile, toProfile) {
  if (!PROFILES[fromProfile] || !PROFILES[toProfile]) throw new Error('profile_invalid');
  return convertValue(key, value, fromProfile, toProfile);
}

export function profileUnit(key, profile) {
  return PROFILES[profile]?.[key]?.[0] || '';
}
