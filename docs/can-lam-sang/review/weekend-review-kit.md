# Weekend Review Kit — 156 ca mô phỏng

Tất cả 156 ca legacy qua adapter đều giữ `review_status=CHUA_DUYET`. Không tự chuyển `DA_DUYET`.

## Cấu trúc 8 lô

Danh sách mã 156 ca do kiến trúc sư đã trích từ `public/tu-chan/index.html` và gửi chủ dự án dưới dạng CSV. File này **không tự chép lại mã ca**; khi duyệt, chủ dự án gửi danh sách mã chính thức của từng lô.

| Lô | Số ca | Quy tắc |
|---|---:|---|
| A | 20 | 3 ca gắn cờ ở đầu lô: `kham-dau-nua-dau-can-duong`, `dau-nua-dau-can-duong-thuong-cang`, `yhct-kham-108` |
| B | 20 | Dùng đúng danh sách mã từ CSV |
| C | 20 | Dùng đúng danh sách mã từ CSV |
| D | 20 | Dùng đúng danh sách mã từ CSV |
| E | 20 | Dùng đúng danh sách mã từ CSV |
| F | 20 | Dùng đúng danh sách mã từ CSV |
| G | 20 | Dùng đúng danh sách mã từ CSV |
| H | 16 | Dùng đúng danh sách mã từ CSV |

## Phiếu review từng ca

Mỗi ca trong danh sách duyệt phải có:

| Trường | Nội dung |
|---|---|
| case_id | Mã ca chính thức từ CSV |
| title | Tiêu đề từ source bank |
| specialty | Chuyên khoa/track từ source bank |
| reason | Lý do ưu tiên/review |
| checks | Các điểm cần kiểm |
| notes | Ghi chú reviewer |

Không tự bịa case_id, tiêu đề, chuyên khoa hoặc kết luận lâm sàng. Không ghi nhận xét lâm sàng do AI tự viết như kết luận.

## Giao thức duyệt theo lô

Chủ dự án ghi:

`TÔI DUYỆT LÔ <tên lô> gồm các mã <danh sách mã> theo phiếu duyệt <link>, ngày <ngày>.`

Kiến trúc sư xác nhận:

`DUYỆT NỘI DUNG LÔ <tên lô>`

Chỉ sau hai xác nhận mới tạo PR đặt `DA_DUYỆT` **đúng các mã đã liệt kê**, kèm `reviewer`, `approved_at` và `approval_ref`. Ca Cần sửa hoặc Loại không được đặt `DA_DUYỆT`.

## Batch review

Ưu tiên lô A và các ca gắn cờ trước; sau đó review theo chuyên khoa. Chia mỗi phiên thành 10–20 ca để người duyệt xử lý một batch, nhưng vẫn giữ nguyên danh sách mã nguồn.
