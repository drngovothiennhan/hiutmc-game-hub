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
2. Admin mở mục "Quản trị ngân hàng ca" trong game, bấm "Đồng bộ danh mục ca lên máy chủ" để ca mới được phát ngẫu nhiên.
