# Nghiệm thu bối cảnh – hình ảnh – nội dung (Trực, Viện Thực Hành Lâm Sàng)

Khung đối chiếu (dùng như bảng kiểm, không phải chứng nhận):
- INACSL Healthcare Simulation Standards of Best Practice – Simulation Design: độ trung thực vật lý, khái niệm, tâm lý.
- NLN/Jeffries Simulation Design Scale: mục "độ trung thực" và "mục tiêu rõ ràng".
- Nielsen heuristic #2 "Match between system and real world": hình ảnh, chữ phải khớp thực tế lâm sàng.
- Chỉ số giá trị nội dung (CVI) cần ≥ 3–5 chuyên gia chấm: **chưa có**, cần giảng viên/bác sĩ của Viện thực hiện.

## Cổng tự động (chạy trong `npm test` và khi dựng 141 ca)
1. Mọi ca dựng được cảnh (đủ ảnh), không lỗi script: đạt 141/141.
2. Không còn câu meta "Ca tự soạn phục vụ đào tạo…" trong nội dung ca (đã chuyển vào ô thông tin).
3. Cảnh khớp kịch bản: nơi chốn (`scene`), giới, tuổi, xưng hô, người nhà chỉ khi kịch bản nêu.
4. Tư thế khớp lâm sàng: chấn thương nằm, đau bụng cúi/co, nặng thì nằm giường.
5. Ảnh không bị cắt: quét viền từng ô ảnh; ô bị cắt nằm trong danh sách `BADCELL` và không được dùng.

## Đã xem trực quan cả 141 cảnh (ảnh tổng hợp)
- Giường/chân giường đủ, không mẩu thừa, bác sĩ quay về phía bệnh nhân, người nhà đúng giới/quan hệ.

## Đã khắc phục bằng bộ ảnh mới (04/10)
- Nội trú người lớn: 8 tư thế trên giường đủ trong ô (`bn_*`), không còn ô bị cắt; cấp cứu không còn dùng chung một ảnh.
- Ngoại trú đồ đời thường (`ngt_*`, độ phân giải cao) cho phòng khám/châm cứu và Y Quán.
- Nằm sấp châm cứu cho bé trai, bé gái, nam già, nữ già (`cham_*`).

## Còn thiếu
- Nội trú trẻ em vẫn dùng bộ `be_*` cũ (7 tư thế, giường đủ nhưng ít biểu cảm).
- Chỉ số CVI cần chuyên gia chấm.
