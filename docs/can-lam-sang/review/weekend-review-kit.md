# Weekend Review Kit — 156 ca mô phỏng

Tất cả 156 ca legacy qua adapter đều giữ review_status=CHUA_DUYET. Không tự chuyển DA_DUYET.

## Ưu tiên đã có cờ

| case_id | tiêu đề | chuyên khoa | lý do ưu tiên | Đạt | Cần sửa | Loại | ghi chú |
|---|---|---|---|---|---|---|---|
| kham-dau-nua-dau-can-duong | [đọc từ bank] | [đọc từ bank] | clinical review flag | ☐ | ☐ | ☐ | |
| dau-nua-dau-can-duong-thuong-cang | [đọc từ bank] | [đọc từ bank] | clinical review flag | ☐ | ☐ | ☐ | |
| yhct-kham-108 | [đọc từ bank] | [đọc từ bank] | clinical review flag | ☐ | ☐ | ☐ | |

## Các nhóm ưu tiên đã xác định từ audit

- 10 ca noi-tieu-hoa-001 đến noi-tieu-hoa-010: đang nhap.
- 16 ca thiếu HBU: chan-tam-thong, trung-phong, trung-thu, hao-suyen, vi-quan-thong, tiet-ta, huyen-vung, yeu-thong, thong-phong, truong-ung, soc-phan-ve-thuoc, suy-tim-mat-bu-thuy-thung, mat-ngu-tam-ty-luong-hu, liet-day-vii-ngoai-bien, stemi-thanh-duoi, phan-ve-phu-thanh-quan.
- 24 ca thiếu nguon/HBU: dot-quy-thieu-mau-cap, ha-duong-huyet-nang, xhth-tren-xo-gan, co-giat-do-sot-cao-tre-em, thung-o-loet-da-day-ta-trang, ngo-doc-phospho-huu-co, nhiem-toan-ceton-dai-thao-duong, vo-lach-chan-thuong-bung-kin, thai-ngoai-tu-cung-vo, kham-tyc-viem-mui-di-ung, kham-nhi-bieng-an-ty-hu, kham-ho-man-viem-phe-quan-dam-thap, kham-dau-nua-dau-can-duong, kham-thong-ta-ruot-kich-thich, kham-thong-kinh-khi-tre-huyet-u, kham-tieu-khat-dai-thao-duong-tip-2, kham-tao-bon-man-cao-tuoi-da-benh, canh-vai-tay-thoai-hoa-csc, thoai-hoa-khop-goi-han-that, toa-cot-phong-thoat-vi-dia-dem, hoi-chung-ong-co-tay-huyet-hu, viem-quanh-khop-vai-dong-cung, dau-nua-dau-can-duong-thuong-cang, di-chung-tai-bien-khi-hu-huyet-u.

## Giao thức duyệt theo lô

Chủ dự án ghi: TÔI DUYỆT LÔ <tên lô> gồm các mã <danh sách mã> theo phiếu duyệt <link>, ngày <ngày>.

Kiến trúc sư xác nhận: DUYỆT NỘI DUNG LÔ <tên lô>.

Chỉ sau hai xác nhận mới tạo PR đặt DA_DUYET đúng các mã đã liệt kê, kèm reviewer, approved_at và approval_ref. Ca Cần sửa hoặc Loại không được đặt DA_DUYET.

## Trạng thái danh sách

Repo connector hiện không trả nội dung public/tu-chan/index.html dù trả blob SHA, nên chưa thể trích xuất trung thực đủ 156 mã, tiêu đề và chuyên khoa. Không bịa các dòng còn thiếu. Khi có source bank đầy đủ, phải sinh bảng 156 dòng trước khi dùng kit.

Không ghi nhận xét lâm sàng do AI tự viết như kết luận.