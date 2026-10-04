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

## Còn dưới 9/10 – cần ảnh vẽ lại (không thể sửa bằng code)
- Bệnh nhân người lớn: ô 3, 5, 6 bị cắt ở ảnh gốc (giường mất đuôi/đầu). Tạm thời: ca ổn ở nội trú ngồi ghế cạnh giường trống; cấp cứu dùng ô nằm ngửa. Hệ quả: nhiều ca cấp cứu dùng cùng một ảnh.
- Bệnh nhân khám ngoại trú (phòng khám, châm cứu) đang mặc đồ ngủ bệnh viện: cần bộ ảnh đồ đời thường (dùng chung cho Y Quán).
- Biểu cảm bệnh nhi; nằm sấp cho trẻ em/người già.
