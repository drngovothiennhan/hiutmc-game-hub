-- Viện Thực Hành (04/10/2026): chuẩn hóa chế độ chơi theo phòng trực.
-- Ca cấp cứu / bệnh phòng chỉ dùng y học hiện đại nên thuộc khoa Nội hoặc Ngoại;
-- khoa Y học cổ truyền chỉ giữ ca phòng khám và châm cứu (kết hợp Đông Tây y).
-- Phần YHCT của 14 ca này được giữ trong dữ liệu ca (yhct_hau_cap) để dùng sau.
-- Chỉ đổi cột track, idempotent, không đụng tới lịch sử trực.
update y_quan_private.tu_chan_catalog set track = 'noi'
 where case_id in (
  'chan-tam-thong',
  'trung-phong',
  'trung-thu',
  'hao-suyen',
  'tiet-ta',
  'huyen-vung',
  'soc-phan-ve-thuoc',
  'suy-tim-mat-bu-thuy-thung',
  'stemi-thanh-duoi',
  'phan-ve-phu-thanh-quan',
  'dot-quy-thieu-mau-cap',
  'ha-duong-huyet-nang',
  'xhth-tren-xo-gan'
 ) and track is distinct from 'noi';

update y_quan_private.tu_chan_catalog set track = 'ngoai'
 where case_id in (
  'truong-ung'
 ) and track is distinct from 'ngoai';
