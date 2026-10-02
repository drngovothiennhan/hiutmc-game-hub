# Kiểm định ngân hàng ca Viện Thực Hành — 02/10/2026

Phạm vi: ngân hàng ca nhúng trong `public/phong-hoc/index.html` và `public/tu-chan/index.html`, hợp đồng kiểm thử, RPC phát ca và danh mục production.

## Kết quả đã xác minh

- Tổng ngân hàng: **50 ca**.
- Trạng thái nội bộ: **40 `draft` + 10 `nhap`**.
- Không phát hiện trùng `id` hoặc trùng tiêu đề.
- Production trước hotfix có 50/50 dòng `active=true`; 10 ca `nhap` đã bị đồng bộ ngoài ý định. Hotfix ngày 02/10/2026 đã đưa 10 ca này về `active=false`, còn 40 ca hoạt động (20 `capcuu`, 20 `kham`).
- Nút đồng bộ cũ gửi toàn bộ `BASE` lên RPC và không gửi `status`. Bản sửa lọc `status !== "nhap"`, gửi `status`, và RPC máy chủ fail-closed cho ca mới thiếu trạng thái hợp lệ.

## Nợ cấu trúc bệnh án

### 16 ca đã có HBU một phần nhưng còn thiếu 4 trường
Thiếu: `ly_do_vao_vien`, `benh_su`, `chan_doan_phan_biet`, `dieu_tri`.

`chan-tam-thong`, `trung-phong`, `trung-thu`, `hao-suyen`, `vi-quan-thong`, `tiet-ta`, `huyen-vung`, `yeu-thong`, `thong-phong`, `truong-ung`, `soc-phan-ve-thuoc`, `suy-tim-mat-bu-thuy-thung`, `mat-ngu-tam-ty-luong-hu`, `liet-day-vii-ngoai-bien`, `stemi-thanh-duoi`, `phan-ve-phu-thanh-quan`.

### 24 ca chưa có `nguon` và chưa có bộ HBU đầy đủ

`dot-quy-thieu-mau-cap`, `ha-duong-huyet-nang`, `xhth-tren-xo-gan`, `co-giat-do-sot-cao-tre-em`, `thung-o-loet-da-day-ta-trang`, `ngo-doc-phospho-huu-co`, `nhiem-toan-ceton-dai-thao-duong`, `vo-lach-chan-thuong-bung-kin`, `thai-ngoai-tu-cung-vo`, `kham-tyc-viem-mui-di-ung`, `kham-nhi-bieng-an-ty-hu`, `kham-ho-man-viem-phe-quan-dam-thap`, `kham-dau-nua-dau-can-duong`, `kham-thong-ta-ruot-kich-thich`, `kham-thong-kinh-khi-tre-huyet-u`, `kham-tieu-khat-dai-thao-duong-tip-2`, `kham-tao-bon-man-cao-tuoi-da-benh`, `canh-vai-tay-thoai-hoa-csc`, `thoai-hoa-khop-goi-han-that`, `toa-cot-phong-thoat-vi-dia-dem`, `hoi-chung-ong-co-tay-huyet-hu`, `viem-quanh-khop-vai-dong-cung`, `dau-nua-dau-can-duong-thuong-cang`, `di-chung-tai-bien-khi-hu-huyet-u`.

### 10 ca Nội tiêu hóa mới

`noi-tieu-hoa-001` đến `noi-tieu-hoa-010` có đủ 17 nhóm HBU trong dữ liệu hiện tại và có `nguon`, nhưng vẫn mang `status: "nhap"`. Chúng phải được rà nội dung/nguồn trước khi đổi trạng thái phát hành.

## Lệch quy ước Nội/Ngoại và YHCT

Theo quy ước hiện hành, ca Nội/Ngoại không dùng mã V/M/T cho vọng/văn/thiết. Hiện còn 6 ca được logic xếp vào y học hiện đại nhưng vẫn có V/M/T:

- `co-giat-do-sot-cao-tre-em`
- `thung-o-loet-da-day-ta-trang`
- `ngo-doc-phospho-huu-co`
- `nhiem-toan-ceton-dai-thao-duong`
- `vo-lach-chan-thuong-bung-kin`
- `thai-ngoai-tu-cung-vo`

Cần quyết định rõ: chuyển các dòng này sang khám y học hiện đại (`K`/mô tả cơ quan) hoặc chuyển cả ca sang nhóm Đông–Tây y với đủ `bd/bc/the/phap/phuong/huyet`. Không để trạng thái lai vì Phòng học tự sinh câu hỏi từ cấu trúc ca.

## Lệch schema

- Mẫu ca mới yêu cầu `setting`, `nguon`, `can_doi_chieu`; dữ liệu Phòng học cũ chưa đồng nhất với schema này. Sau kiểm tra runtime ngày 02/10/2026, `tests[][1]` và số phút trong `actions` được xác nhận là **phút mô phỏng thực sự làm trôi thời gian ca**, không phải trường chi phí hay trường chưa định nghĩa.
- Ngân hàng hiện chưa có khóa `can_doi_chieu` một cách nhất quán ở các ca cũ. Các ghi chú kỹ thuật sai về `tests[][1]` trong 10 ca Nội tiêu hóa đã được loại bỏ; `can_doi_chieu` chỉ nên giữ nội dung thực sự cần rà chuyên môn/nguồn.
- Nhiều nhóm `opt` cũ có 5 lựa chọn, trong khi mẫu mới quy định 4 lựa chọn (trừ `phuong`/`huyet`). Runtime vẫn xử lý được nhưng schema và tài liệu đang lệch nhau.
- Phòng học tự sinh câu hỏi/đáp án từ `opt`, `tests`, `actions`, `teach`; vì vậy sai dữ kiện trong ngân hàng sẽ trực tiếp biến thành đáp án chấm điểm sai.

## Thứ tự rà chuyên môn đề nghị

1. Ca cấp cứu/nguy cơ tử vong và hành động `++/!`.
2. 10 ca Nội tiêu hóa `nhap`: kiểm chứng từng tiêu chuẩn chẩn đoán, cận lâm sàng, xử trí và nguồn.
3. 16 ca HBU một phần: bổ sung đủ 4 trường còn thiếu.
4. 24 ca cũ: bổ sung HBU, nguồn và trường `can_doi_chieu`.
5. Chuẩn hóa 6 ca lai YHHĐ/YHCT và chuẩn hóa schema toàn ngân hàng.

Không đổi ca sang trạng thái “đã duyệt chuyên môn” chỉ dựa trên kiểm tra kỹ thuật.


## Chuẩn schema mới đã chốt

- Bệnh án HBU cho ca mới dùng đủ 17 mục: `hanh_chinh`, `ly_do_vao_vien`, `benh_su`, `tien_su`, `luoc_qua_co_quan`, `kham_hien_tai`, `can_lam_sang`, `tom_tat`, `dat_van_de`, `chan_doan_so_bo`, `bien_luan`, `sinh_ly_benh`, `chan_doan_phan_biet`, `chan_doan_xac_dinh`, `dieu_tri`, `tien_luong`, `du_phong`.
- `tests`: `[tên, số_phút_mô_phỏng, kết_quả, e|n|w]`.
- `actions`: `++|+|-|!Tên|số_phút_mô_phỏng|lý do`.
- Các trường phút mô phỏng tác động trực tiếp đến đồng hồ và độ ổn định của bệnh nhân trong game, nên phải được cân chỉnh như một phần logic ca, không chỉ là metadata.
