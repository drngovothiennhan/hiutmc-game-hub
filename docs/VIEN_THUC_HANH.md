# VIỆN THỰC HÀNH - TMC

Game mô phỏng lâm sàng tại `/tu-chan/` (trang độc lập, ngân hàng ca nhúng sẵn).

## Luồng chơi
- Người chơi chọn phòng trực: **Trực Cấp cứu** hoặc **Trực Phòng khám**. Ca bệnh do máy chủ phát ngẫu nhiên, người chơi không chọn và không biết trước.
- Ca dở được giữ lại 3 giờ: vào lại cùng phòng sẽ gặp đúng ca đó (không đổi ca bằng cách thoát).
- Ca trực (cấp cứu, nội trú) chấm theo y đa khoa. Ca phòng khám và châm cứu chấm theo YHCT.

## Hồ sơ bác sĩ dùng chung với HIU Y Quán
- Bác sĩ trong Viện là bác sĩ HIU Y Quán (bảng `y_quan_private.clinics`). Chưa mở y quán thì chưa tính EXP.
- Kết thúc ca: EXP cộng dồn vào `clinics.experience` (cùng cột Y Quán dùng để xếp hạng). Tín dụng vẫn chỉ đến từ đánh giá của bệnh nhân.
- EXP mỗi ca: 5 + 25% điểm (làm tròn) + 5 nếu điểm từ 85, +5 lần đầu gặp ca đó; bệnh nhân tử vong: 2. Ca kết thúc dưới 40 giây: 0. Trần 400 EXP mỗi ngày (giờ Việt Nam), tối đa 40 ca mỗi ngày.
- Hạng: Y sinh thực hành (0), Bác sĩ trực tập sự (100), Bác sĩ trực (300), Bác sĩ điều trị (700), Bác sĩ chính (1500), Chuyên gia (3000), Danh y (6000).

## Máy chủ (migration `20261001160000_vien_thuc_hanh_shifts_v1.sql`)
- Bảng `y_quan_private.tu_chan_catalog` (danh mục ca và phòng) và `tu_chan_shifts` (lượt trực). RLS bật, không cấp quyền trực tiếp.
- RPC: `tu_chan_profile_v1`, `tu_chan_start_shift_v1(p_room)`, `tu_chan_finish_shift_v1(p_shift_id, p_score, p_died)`, `tu_chan_register_cases_v1(p_cases)` (chỉ admin).
- Điểm do trình duyệt tính và gửi lên; máy chủ giới hạn bằng trần EXP, thời gian tối thiểu và một lượt trực chỉ ghi một lần. Nội dung ca nằm trong gói trang nên chưa bí mật tuyệt đối. Muốn chống xem trước ca cần chuyển nội dung ca về máy chủ.

## Thêm ca mới
1. Đưa tệp ca vào `bank/` của game, khai báo trong `index.json`, dựng lại `tutchan.standalone.html` và chép vào `public/tu-chan/index.html`.
2. Admin mở mục "Quản trị ngân hàng ca" trong game, bấm "Đồng bộ danh mục ca lên máy chủ". Client chỉ gửi các ca không ở trạng thái `nhap`; RPC máy chủ cũng fail-closed với ca `nhap` hoặc ca mới thiếu trạng thái hợp lệ. Việc đồng bộ không đồng nghĩa với duyệt chuyên môn.

## Hub Viện Thực Hành Lâm Sàng (`/vien-thuc-hanh/`)
- Cổng vào mới từ Game Hub: tranh cổng chào, hai lối vào ngang hàng: **Mô phỏng học thi lâm sàng** (`/phong-hoc/`, bước 1–2) và **Trực ở Viện Thực Hành** (`/tu-chan/`, bước 3). Lộ trình Học › Thi › Trực.
- `/phong-hoc/`: chế độ Học và Thi vấn đáp sinh câu hỏi từ ngân hàng nhúng. Tại đợt kiểm tra 02/10/2026 có 50 ca trong gói: 40 ca thuộc tập đang phát cho ca trực và 10 ca Nội tiêu hóa trạng thái `nhap` đang chờ rà chuyên môn. Ca `nhap` không được phép vào danh mục phát ngẫu nhiên trên máy chủ.
- Quy ước ba mục: Nội và Ngoại chỉ có bệnh án y học hiện đại; chỉ Y học cổ truyền kết hợp Đông – Tây y trong một bệnh án. Kiểm tra 02/10/2026 còn nợ chuẩn hóa dữ liệu cũ: 16 ca mới bổ sung một phần bệnh án nhưng còn thiếu 4 trường HBU; 24 ca cũ chưa có `nguon` và chưa có bộ HBU đầy đủ; 6 ca y học hiện đại còn dùng nhãn khám V/M/T kiểu YHCT. Xem `VIEN_THUC_HANH_CASE_AUDIT_2026-10-02.md`.
- Chế độ học và thi chưa cộng EXP xếp hạng của game.
