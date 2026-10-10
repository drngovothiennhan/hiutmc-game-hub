# Xử lý ảnh thật cho Gia Viên Dược Thảo

Ba tập lệnh Python để làm ra các tệp trong `public/gia-vien-duoc-thao-preview/assets/` từ ảnh nguồn của chủ vườn. Chạy lại được khi có ảnh mới hoặc ảnh gốc nét hơn. Chỉ cần khi cập nhật ảnh; **không chạy trong CI hay lúc build**.

Cần Python 3 với `Pillow`, `numpy`, `opencv-python`, `scipy`. Luôn chạy bằng `python3 -I` (không nạp mã từ thư mục hiện tại).

## Quy tắc bắt buộc

- **Chỉ ảnh thật.** Không tạo, không vẽ, không dùng AI sinh cảnh. Cho phép: cắt, đổi kích thước, gỡ dòng chữ ghi thông số máy ảnh ở mép dưới.
- **Không có người trong ảnh.** Ảnh có người hoặc nghi có người (kể cả bóng rất nhỏ ở cuối lối đi, vùng kính toà nhà) thì **cắt bỏ vùng đó**; không xoá hoặc vá bằng AI. Vùng cắt an toàn của từng ảnh nằm ở biến `panos` trong `03_export_assets.py`. Ảnh mới thêm phải được xem lại bằng mắt (cả bản phóng to ở rìa ảnh) trước khi khai báo.
- Bố cục phải là hiện trạng (tranh tường phong cảnh xanh, giàn trồng đứng). Ảnh bố cục cũ chỉ vào nhóm "Lưu trữ".
- Tệp xuất ra phải nằm trong ngân sách của `test/gia-vien-thuc-canh.test.js` (web ≤ 650 KB, thumb ≤ 60 KB, fp ≤ 1400 KB) và mọi tệp trong `assets/` phải được game dùng.

## Các bước

1. `01_clean_watermark.py` — gỡ dòng chữ thông số máy ảnh (Xiaomi) ở giữa mép dưới ảnh gốc 4000×3000, chỉ trong vùng sân gạch.

   ```
   python3 -I 01_clean_watermark.py anh_goc.jpg anh_da_sach.png
   ```

2. `02_calibrate_cylinder.py` — tìm góc nhìn ngang (`hfov`), tỉ lệ chiều cao (`v`) và hàng ngang tầm mắt (`cy`) của một ảnh toàn cảnh ghép sẵn bằng cách so khớp với các ảnh đơn đã biết tiêu cự. Kết quả đưa vào `fpStations` (`proj:'cylinder'`, `hfov`, `v`, `cy`). Tỉ lệ ảnh phải bằng `hfov` (rađian) chia `v`, sai lệch tối đa 4% (test kiểm tra).

   ```
   python3 -I 02_calibrate_cylinder.py pano.jpg ref1.jpg:f_px ref2.jpg:x
   ```

3. `03_export_assets.py` — xuất toàn bộ ảnh cho game (nền WebP cho 3D, bản nét cao `-hi.webp`, ảnh web JPG, ảnh thu nhỏ, ảnh cận cắt từ ảnh gốc nét cao).

   ```
   python3 -I 03_export_assets.py \
     --clean DIR_ANH_DA_GO_CHU \
     --panos DIR_TOAN_CANH \
     --canon DIR_CANON \
     --out ../../public/gia-vien-duoc-thao-preview/assets
   ```

   - `--clean`: `IMG_20260912_065456.png`, `IMG_20260926_065323.png`, `IMG_20260926_065339.png` (đầu ra của bước 1).
   - `--panos`: `p2.jpg p3.jpg p5.jpg p6.jpg p7.jpg p8.jpg p10.jpg` (toàn cảnh ngày 10/10 do chủ vườn gửi; ảnh qua khung chat bị thu về 2576 px bề ngang).
   - `--canon` (tuỳ chọn): `IMG_3503.JPG` (Canon EOS 50D, 16/09/2026).

   Tập lệnh in dung lượng từng tệp. Sau đó chạy `npm test` và mở trang bằng `?st=<mã trạm>` để xem trạm vừa đổi.

## Ảnh toàn cảnh đã dùng (10/10/2026)

| Tệp nguồn | Dùng làm | Tệp xuất |
|---|---|---|
| p8 | Trạm 3D "Giữa sân" + khung Ảnh thật | `fp/2026-10-giua-san`, `web/2026-10-toan-canh-giua-san` |
| p7 | Trạm 3D "Sát giàn" + khung Ảnh thật | `fp/2026-10-sat-gian`, `web/2026-10-sat-gian` |
| p3 | Trạm 3D "Lối vào sân" + khung Ảnh thật | `fp/2026-10-loi-vao`, `web/2026-10-loi-vao-san` |
| p5, p10, p6, p2 | Khung Ảnh thật | `web/2026-10-duoi-mai-che`, `…-giang-trong-dung`, `…-cum-cay-trai-gian`, `…-canh-giang-dung` |
| p1, p4, p9 | Chưa dùng (chụp cúi sát bồn, méo mạnh khi ghép) | — |

Muốn nét hơn: thay các tệp `p*.jpg` bằng ảnh gốc (mỗi ảnh dưới 10 MB để đọc được từ Drive), chạy lại bước 2 cho thông số mới nếu kích thước đổi, cập nhật vùng cắt `crop`/`tx` trong `03_export_assets.py` theo tỉ lệ mới rồi xuất lại.
