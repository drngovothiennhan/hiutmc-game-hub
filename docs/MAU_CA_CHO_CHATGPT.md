# Mẫu soạn ca cho ChatGPT (Viện Thực Hành Lâm Sàng HIU TMC)

Dán nguyên phần "LỆNH CHO CHATGPT" bên dưới vào ChatGPT. Mỗi lần xin 5 ca, trả về JSON thuần (không giải thích), để dễ nạp.

## Mục tiêu số ca (đề xuất, chỉnh được)
- Nội: 35 ca. Ngoại: 25 ca. Y học cổ truyền: 40 ca. Tổng khoảng 100.
- Làm đợt thử trước: 5 ca mỗi mục (15 ca). Đạt chất lượng mới làm tiếp.

## Quy tắc ba mục (rất quan trọng)
- **Nội** và **Ngoại**: chỉ y học hiện đại. KHÔNG có bát cương, thể bệnh, pháp, phương, huyệt, vọng/văn/vấn/thiết.
- **Y học cổ truyền**: mỗi ca kết hợp Đông và Tây y: chẩn đoán y học hiện đại + biện chứng luận trị (bệnh danh, bát cương, thể bệnh, pháp, phương, huyệt).

## LỆNH CHO CHATGPT

Bạn là giảng viên lâm sàng soạn ca cho sinh viên y năm cuối tại Việt Nam, để luyện phản xạ thi lâm sàng. Soạn **5 ca mục [NỘI | NGOẠI | Y HỌC CỔ TRUYỀN]**, chuyên khoa/chủ đề: [điền, ví dụ: tim mạch, tiêu hóa, hô hấp…]. Mỗi ca khác bệnh, khác độ tuổi, có cả ca dễ, vừa, khó.

Yêu cầu:
1. Bám đúng mẫu bệnh án nội khoa của trường Đại học Hồng Bàng: hành chính, lý do vào viện, bệnh sử, tiền sử, khám hiện tại, cận lâm sàng, tóm tắt, biện luận, chẩn đoán sơ bộ và phân biệt, điều trị, tiên lượng, dự phòng.
2. Nội dung phải theo giáo trình hoặc hướng dẫn chính thức (Bộ Y tế, giáo trình y khoa Việt Nam, hướng dẫn quốc tế đang dùng). Ghi tên nguồn cụ thể vào trường `nguon` (tên sách/hướng dẫn, năm). Không bịa số liệu, không sao chép nguyên văn ca bệnh từ bài báo; tự viết ca mới.
3. Không dùng tên, địa chỉ hay chi tiết của người thật.
4. Nếu không chắc một chi tiết chuyên môn, ghi vào `can_doi_chieu` thay vì đoán.
5. Mục Nội và Ngoại: bỏ hẳn các khóa YHCT (`bd`, `bc`, `the`, `phap`, `phuong`, `huyet`) và các dòng khám có mã V, M, T. Mục YHCT: bắt buộc có đủ.
6. Mỗi câu hỏi bệnh sử/khám có cờ: `e` = thiết yếu, `n` = trung tính. Xét nghiệm có cờ `e` (nên làm), `n` (trung tính), `w` (lãng phí/không có chỉ định). Đáp án đúng trong `opt` đặt dấu `+` ở đầu; đáp án đúng một phần dùng `~`.
7. Mỗi nhóm lựa chọn có 4 đáp án (riêng `phuong`, `huyet` có thể nhiều hơn, nhiều đáp án đúng).
8. Trả về **một mảng JSON duy nhất**, không thêm chữ nào bên ngoài.

Mẫu một ca:

```json
{
  "id": "noi-tieu-hoa-001",
  "title": "Đau thượng vị âm ỉ",
  "kind": "Nội",
  "setting": "phongkham",
  "level": "Dễ",
  "name": "Bà L. T. H.",
  "age": 52,
  "sex": "nữ",
  "intro": "Khoa Nội, giường 12. Bà đến khám vì đau vùng thượng vị 3 tháng.",
  "vitals": {"hr": 78, "sbp": 110, "dbp": 70, "rr": 18, "t": 36.6, "spo2": 98},
  "ask": [["Đau ở đâu, đau như thế nào?", "Đau âm ỉ vùng thượng vị 3 tháng, lúc đau lúc không.", "e"]],
  "exam": [["K", "Khám bụng", "Thượng vị ấn đau nhẹ, bụng mềm.", "e"]],
  "tests": [["Nội soi dạ dày", 20, "Loét hang vị 0,5 cm, bờ đều.", "e"]],
  "opt": {
    "ydx": ["+Loét dạ dày có nhiễm H. pylori", "Hội chứng ruột kích thích", "Ung thư dạ dày", "Viêm tụy cấp"]
  },
  "actions": ["+Hướng dẫn ăn chín, ấm, chia nhỏ bữa|2|Giải thích ngắn tại sao đúng."],
  "teach": "Bài học chính của ca trong 2 đến 3 câu.",
  "hbu": {
    "ly_do_vao_vien": "...",
    "benh_su": "...",
    "tien_su": "...",
    "tom_tat": "...",
    "bien_luan": "...",
    "sinh_ly_benh": "...",
    "chan_doan_phan_biet": "...",
    "dieu_tri": "...",
    "tien_luong": "...",
    "du_phong": "..."
  },
  "nguon": ["Tên giáo trình hoặc hướng dẫn, năm"],
  "can_doi_chieu": [],
  "status": "nhap"
}
```

Ghi chú về `kind`: "Nội", "Ngoại" hoặc "YHCT". Với mục YHCT thêm trong `opt` các khóa `bd`, `bc`, `the`, `phap`, `phuong`, `huyet` giống ca mẫu YHCT của game, và dòng `exam` dùng mã V (vọng), M (văn), T (thiết), K (khám).

## Cách nạp sau khi ChatGPT soạn xong
1. Bạn gửi JSON cho Claude (dán hoặc tệp).
2. Claude kiểm tra đúng mẫu, đúng quy tắc ba mục, không trùng ca, rồi nạp vào ngân hàng ở nhánh xem thử.
3. Bạn xem bản xem thử, đồng ý rồi mới phát hành. Ca nào còn `can_doi_chieu` hoặc `status: nhap` được gắn nhãn "chưa đối chiếu nguồn".
