# Học đọc phim X-quang ngực — nội dung đề xuất

Trạng thái: **bản nháp, CHƯA KIỂM DUYỆT**. Chưa nối vào giao diện, chưa có SQL, chưa bật cờ. Mọi ca đều là ca mô phỏng do A.I soạn; không phải bệnh án thật.

## Phạm vi
- Mô-đun `xquang-nguc`, thuộc Phòng Cận Lâm Sàng trong Viện Thực Hành HIU TMC.
- Tách riêng với CBC, ca bệnh lõi và nghe tim phổi để có thể nâng cấp độc lập.
- Mục tiêu: học đọc phim theo trình tự hệ thống trước khi kết luận, và tránh đọc quá mức.

## Trình tự đọc phim (dựa trên nguồn đã kiểm tra)
Nguồn chính: patient.info, "Chest X-ray — systematic approach" (https://patient.info/doctor/investigations/chest-x-ray-systematic-approach).
1. Xác nhận đúng người bệnh và đúng phim (tên, ngày, nhãn tư thế).
2. Kiểm tra kỹ thuật: tư thế, xoay, hít vào, độ đậm nhạt.
3. Tìm vật lạ, dụng cụ (ống dẫn lưu, máy tạo nhịp, ống nội khí quản, catheter).
4. Đánh giá đường trung thất: khí quản có ở giữa không.
5. Đo chỉ số tim/ngực (dưới 0,5 là bình thường; không đánh giá được tim to trên phim thẳng AP).
6. Xem bờ tim.
7. Xem rốn phổi.
8. Khảo sát nhu mô phổi từ đỉnh đến đáy, so sánh hai bên, xem vùng ngoại biên và sau tim.
9. Xem góc sườn hoành, mặt cơ hoành.
10. Xem xương và mô mềm (gãy xương sườn: kiểm tra lại tràn khí).
11. Đọc lại các vùng hay bỏ sót: đỉnh phổi, ngoại biên, dưới cơ hoành, sau tim.

Nguồn tham khảo đã tìm: Radiopaedia, "Systematic chest radiograph assessment (approach)" (https://radiopaedia.org/articles/systematic-chest-radiograph-assessment-approach). Trang này không hiển thị đủ các bước khi tải lại, nên chưa dùng làm nguồn cho trình tự ở trên.

## Nội dung đã soạn (10 ca)
File công khai: `data/can-lam-sang/xquang/cases.public.json` (chỉ có ca, mô tả phim, câu hỏi, lựa chọn).
File đáp án: `data/can-lam-sang/xquang/cases.answer-key.private.json` (**không commit**, đúng quy ước `*.private.json`).

| Mã ca | Chủ đề | Đáp án gợi ý |
|---|---|---|
| xq-01 | Tràn khí màng phổi tự phát | Tràn khí màng phổi trái |
| xq-02 | Viêm phổi thùy dưới phải | Hoành phải còn sắc, không phải tràn dịch |
| xq-03 | Tràn dịch màng phổi | Góc sườn tù, mặt cong |
| xq-04 | Phù phổi do tim | Tim to, Kerley B |
| xq-05 | Gãy xương sườn sau chấn thương | Kiểm tra lại tràn khí |
| xq-06 | Khối phổi nghi ác tính | Chỉ định CT, không kết luận trên phim |
| xq-07 | Lao phổi thể hang đỉnh | Cần xét nghiệm vi sinh |
| xq-08 | Phim bình thường | Tránh đọc quá mức |
| xq-09 | Vị trí ống nội khí quản | Đúng vị trí |
| xq-10 | Vị trí catheter tĩnh mạch trung tâm | Vùng nối tĩnh mạch chủ trên – nhĩ phải |

## Hạn chế hiện tại
- **Không có ảnh X-quang.** Phim được mô tả bằng văn bản. Ảnh thật cần nguồn có giấy phép rõ ràng (nhiều ảnh Radiopaedia có điều kiện sử dụng hạn chế), và cần được chuyên gia chọn.
- Các ca xq-06, xq-07, xq-09, xq-10 dựa trên kiến thức lâm sàng chung, **chưa có nguồn đã kiểm chứng** trong phiên làm việc này.
- Ngưỡng vị trí ống nội khí quản và catheter cần chuyên gia hồi sức xác nhận theo hướng dẫn hiện hành.

## Cần chuyên gia xác nhận trước khi dùng
1. Toàn bộ mô tả phim và đáp án của 10 ca.
2. Nguồn cho các ca chưa có nguồn kiểm chứng.
3. Trình tự đọc phim có phù hợp với cách giảng dạy của trường không.

## Việc tiếp theo (chưa làm)
- Chuyên gia duyệt và đánh dấu từng ca.
- Quyết định có thêm ảnh X-quang thật hay không, và nguồn ảnh.
- Thiết kế giao diện và RPC chấm bài theo mẫu ADR-001, sau khi duyệt nội dung.
