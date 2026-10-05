# Bàn giao cho ChatGPT và Gemini (khi Claude hết hạn mức)

Cập nhật 05/10/2026. Đọc file này trước khi làm bất kỳ việc nào. Repo công khai: https://github.com/drngovothiennhan/hiutmc-game-hub

## Bối cảnh một đoạn
Viện Thực Hành Lâm Sàng HIU TMC là game mô phỏng ca lâm sàng (141 ca: 63 Nội, 42 Ngoại, 36 YHCT). Ca Nội và Ngoại chỉ dùng y học hiện đại. Ca YHCT kết hợp Đông và Tây y. Kế hoạch: `docs/DOI_CHIEU_SO_LIEU_2026-10-05.md`. Chưa thu tiền. Thành viên HIU TMC chơi đủ, thành viên ngoài chơi gần đủ, khách chơi thử.

## Quy tắc cứng (vi phạm là hỏng việc)
1. **Không sửa trực tiếp** `public/tu-chan/index.html`, `public/phong-hoc/index.html` hay thư mục `supabase/`. Chỉ tạo file kết quả và đưa vào `incoming/`.
2. **Không đổi `status`** của ca. Chỉ bác sĩ mới được ghi "đã duyệt". Không viết "đã duyệt", "đã xác nhận bởi bác sĩ".
3. **Không bịa** liều, ngưỡng, số hiệu văn bản, PMID, đường dẫn. Không đọc được nguồn thì ghi `khong_doi_chieu_duoc`. Một câu trả lời trung thực "không đọc được" tốt hơn một câu trả lời đoán.
4. Mỗi con số phải kèm: tên nguồn, đường dẫn mở được, và **trích nguyên văn ngắn** (tiếng gốc) chứa con số đó.
5. Trả lời bằng tiếng Việt. Kết quả là JSON hoặc CSV thuần, không kèm giải thích dài.
6. Làm từng lô nhỏ (tối đa 8 ca hoặc 30 ý mỗi lần). Quá dài thì dừng và báo.
7. Không dùng tên, địa chỉ người thật.

## Việc 1: Đọc văn bản gốc để đóng các ý còn mở (ưu tiên số 1)
Dành cho: ChatGPT hoặc Gemini có duyệt web và đọc được PDF.

Nguồn việc: file `data/so-lieu-kiem.json` (https://raw.githubusercontent.com/drngovothiennhan/hiutmc-game-hub/main/data/so-lieu-kiem.json). Lấy các ý có `verdict` là `khong_doi_chieu_duoc` hoặc `lech` thuộc các ca sau (mỗi lô chọn một nhóm):
- Lô A: `noi-nhiem-001` (cần đọc nguyên văn Quyết định 3705/QĐ-BYT năm 2019 về sốt xuất huyết Dengue: tốc độ truyền dịch người lớn).
- Lô B: `noi-than-003` (Quyết định 708/QĐ-BYT), `noi-than-001`, `noi-than-002`.
- Lô C: `noi-tim-mach-001`, `noi-tim-mach-003`, `noi-tim-mach-004` (ESC 2023 hội chứng vành cấp; AHA).
- Lô D: `noi-ho-hap-002` (GOLD 2025 và BTS: ngưỡng PaCO2 để thở không xâm nhập), `noi-ho-hap-003` (ATS/IDSA 2019), `noi-ho-hap-004`.
- Lô E: `ngoai-chan-thuong-005` (hướng dẫn bỏng ABA hoặc ISBI: mức chỉnh tốc độ dịch), `ngoai-bung-001`, `ngoai-bung-008`.
- Lô F: `noi-cap-cuu-004`, `noi-cap-cuu-102`, `noi-cap-cuu-104`.

Mẫu lệnh (dán nguyên vào ChatGPT/Gemini, thay [LÔ]):
```
Đọc kỹ docs/BAN_GIAO_AI_KHAC.md tại https://raw.githubusercontent.com/drngovothiennhan/hiutmc-game-hub/main/docs/BAN_GIAO_AI_KHAC.md rồi làm Việc 1, Lô [LÔ].
Mở https://raw.githubusercontent.com/drngovothiennhan/hiutmc-game-hub/main/data/so-lieu-kiem.json , lấy các ý của những ca trong lô có verdict là khong_doi_chieu_duoc hoặc lech.
Với từng ý, tìm nguồn chính thức đọc được (văn bản Bộ Y tế, hướng dẫn quốc tế, PubMed). Trả về MỘT mảng JSON, mỗi phần tử:
{"id":"<id ca>","loc":"<loc>","text":"<text nguyên văn>","verdict":"khop|nhat_quan|lech|khong_doi_chieu_duoc","nguon":"<tên và URL>","trich":"<trích nguyên văn ngắn có con số>","de_xuat":"<giá trị đúng nếu lech, nếu không thì rỗng>"}
Quy tắc: không đoán; không đọc được thì verdict là khong_doi_chieu_duoc và nói rõ vì sao trong trich. Không thêm chữ ngoài JSON.
```
Lưu kết quả thành file `YYYY-MM-DD_viec-1_<ai>.json` và đưa vào `incoming/`.

## Việc 2: Soạn ca Nội mới (chỉ khi Việc 1 đã có tiến triển)
Dùng nguyên mẫu trong `docs/MAU_CA_CHO_CHATGPT.md`. Mỗi lần 5 ca. Chỉ soạn ô còn trống của bảng phủ sau (đang thiếu, cần bạn xác nhận lại): Nội tiết, Huyết học, Thận tiết niệu, Cơ xương khớp, Thần kinh. Kết quả là mảng JSON, mỗi ca `"status":"draft"`, có trường `nguon` ghi rõ nguồn.

Sau đó một AI khác kiểm tra chéo: ChatGPT soạn thì Gemini kiểm, và ngược lại. Lệnh kiểm chéo:
```
Bạn là bác sĩ phản biện. Với từng ca trong mảng JSON dưới đây, liệt kê MỌI con số (liều, ngưỡng, thời gian) và đối chiếu với nguồn chính thức đọc được. Trả về bảng: id ca, con số, nguồn và trích nguyên văn, kết luận khớp/lệch/không đọc được. Không sửa ca, không đoán.
```
Chỉ ca không còn ý "lệch" hoặc "không đọc được" mới đưa vào `incoming/`.

## Việc 3: Liều vị thuốc YHCT với Dược điển Việt Nam
36 ca YHCT chưa đối chiếu. Mỗi lô 6 ca. Trích liều từng vị trong phương thuốc của ca, đối chiếu Dược điển Việt Nam V và Quyết định 5013/QĐ-BYT hoặc giáo trình Hồng Bàng. Cùng định dạng JSON như Việc 1.

## Việc không giao cho ChatGPT/Gemini (để Claude làm khi có lại hạn mức)
- Mọi thay đổi code, cơ sở dữ liệu, test, phân quyền theo nhóm (trường `tier`: khách, ngoại, đủ).
- Nạp kết quả vào ngân hàng ca, chạy test, mở PR, deploy.
- Đổi trạng thái hiển thị của ca.

## Quy tắc khi soạn ca mới (rút ra từ hai lô Việc 2, bắt buộc)
1. `id` phải chưa tồn tại. Số lớn nhất hiện có: noi-tieu-hoa 11, noi-tim-mach 7, noi-ho-hap 6, noi-noi-tiet 4, noi-than 4, noi-than-kinh 3, noi-huyet-hoc 2, noi-nhiem 3, noi-co-xuong-khop 1, ngoai-bung 8, ngoai-chan-thuong 7. Dùng số kế tiếp.
2. `level` chỉ là một trong: "Dễ", "Trung bình", "Khó" (không dùng "Vừa").
3. `setting` là "giuong" (ca Nội, Ngoại chỉ y học hiện đại).
4. Mọi hành động trong `actions` phải bắt đầu bằng một ký hiệu: "++", "+", "-" hoặc "!". Không để hành động trống ký hiệu.
5. Có ít nhất 1 hành động "!" (nguy hại), ít nhất 3 mục khám cờ "e", và `hbu` đủ các trường, kể cả `luoc_qua_co_quan`.
6. Mỗi con số (liều, ngưỡng, thời gian) phải có trong `nguon` kèm trích nguyên văn. Con số không có nguồn thì bỏ, không đoán.
