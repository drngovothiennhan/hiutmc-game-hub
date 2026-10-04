# VIỆN THỰC HÀNH - TMC

Game mô phỏng lâm sàng tại `/tu-chan/` (trang độc lập, ngân hàng ca nhúng sẵn).

## Luồng chơi
- Người chơi chọn khoa trực: **Nội**, **Ngoại** (chỉ y học hiện đại) hoặc **Y học cổ truyền** (kết hợp Đông Tây y). Chỉ phát ca thuộc khoa đã chọn. Ca bệnh do máy chủ phát ngẫu nhiên, người chơi không chọn và không biết trước.
- Ca dở được giữ lại 3 giờ: bấm vào khoa bất kỳ sẽ gặp lại đúng ca đó (không đổi ca bằng cách thoát).
- Ca trực (cấp cứu, nội trú) chấm theo y đa khoa. Ca phòng khám và châm cứu chấm theo YHCT.

## Hồ sơ bác sĩ dùng chung với HIU Y Quán
- Bác sĩ trong Viện là bác sĩ HIU Y Quán (bảng `y_quan_private.clinics`). Chưa mở y quán thì chưa tính EXP.
- Kết thúc ca: EXP cộng dồn vào `clinics.experience` (cùng cột Y Quán dùng để xếp hạng). Tín dụng vẫn chỉ đến từ đánh giá của bệnh nhân.
- EXP mỗi ca: 5 + 25% điểm (làm tròn) + 5 nếu điểm từ 85, +5 lần đầu gặp ca đó; bệnh nhân tử vong: 2. Ca kết thúc dưới 40 giây: 0. Trần 400 EXP mỗi ngày (giờ Việt Nam), tối đa 40 ca mỗi ngày.
- Hạng: Y sinh thực hành (0), Bác sĩ trực tập sự (100), Bác sĩ trực (300), Bác sĩ điều trị (700), Bác sĩ chính (1500), Chuyên gia (3000), Danh y (6000).

## Máy chủ (migration `20261001160000_vien_thuc_hanh_shifts_v1.sql`)
- Bảng `y_quan_private.tu_chan_catalog` (danh mục ca, phòng và khoa `track`) và `tu_chan_shifts` (lượt trực). RLS bật, không cấp quyền trực tiếp.
- RPC: `tu_chan_profile_v1`, `tu_chan_start_shift_v2(p_track)` (noi|ngoai|yhct; v1 theo phòng còn giữ cho bản cũ), `tu_chan_finish_shift_v1(p_shift_id, p_score, p_died)`, `tu_chan_register_cases_v1(p_cases)` (chỉ admin).
- Điểm do trình duyệt tính và gửi lên; máy chủ giới hạn bằng trần EXP, thời gian tối thiểu và một lượt trực chỉ ghi một lần. Nội dung ca nằm trong gói trang nên chưa bí mật tuyệt đối. Muốn chống xem trước ca cần chuyển nội dung ca về máy chủ.

## Thêm ca mới
1. Đưa tệp ca vào `bank/` của game, khai báo trong `index.json`, dựng lại `tutchan.standalone.html` và chép vào `public/tu-chan/index.html`.
2. Admin mở mục "Quản trị ngân hàng ca" trong game, bấm "Đồng bộ danh mục ca lên máy chủ". Client chỉ gửi các ca không ở trạng thái `nhap`; RPC máy chủ cũng fail-closed với ca `nhap` hoặc ca mới thiếu trạng thái hợp lệ. Việc đồng bộ không đồng nghĩa với duyệt chuyên môn.

## Hub Viện Thực Hành Lâm Sàng (`/vien-thuc-hanh/`)
- Cổng vào mới từ Game Hub: tranh cổng chào, hai lối vào ngang hàng: **Mô phỏng học thi lâm sàng** (`/phong-hoc/`, bước 1–2) và **Trực ở Viện Thực Hành** (`/tu-chan/`, bước 3). Lộ trình Học › Thi › Trực.
- `/phong-hoc/`: chế độ Học và Thi vấn đáp sinh câu hỏi từ ngân hàng nhúng. Tại đợt kiểm tra 02/10/2026 có 50 ca trong gói: 40 ca thuộc tập đang phát cho ca trực và 10 ca Nội tiêu hóa trạng thái `nhap` đang chờ rà chuyên môn. Ca `nhap` không được phép vào danh mục phát ngẫu nhiên trên máy chủ.
- Quy ước ba mục: Nội và Ngoại chỉ có bệnh án y học hiện đại; chỉ Y học cổ truyền kết hợp Đông – Tây y trong một bệnh án. Kiểm tra 02/10/2026 còn nợ chuẩn hóa dữ liệu cũ: 16 ca mới bổ sung một phần bệnh án nhưng còn thiếu 4 trường HBU; 24 ca cũ chưa có `nguon` và chưa có bộ HBU đầy đủ; 6 ca y học hiện đại còn dùng nhãn khám V/M/T kiểu YHCT. Xem `VIEN_THUC_HANH_CASE_AUDIT_2026-10-02.md`.
- Chế độ học và thi chưa cộng EXP xếp hạng của game.

## Lịch sử và điểm theo kỹ năng
- Mỗi ca trực khi kết thúc gửi thêm điểm 6 kỹ năng (0 đến 100): hỏi bệnh, khám, cận lâm sàng, chẩn đoán, xử trí, an toàn người bệnh. Máy chủ chỉ nhận đúng 6 khóa này và chặn giá trị trong khoảng 0 đến 100.
- Sảnh Trực có mục "Hồ sơ trực": điểm trung bình theo kỹ năng (20 ca gần nhất), số ca theo khoa, 10 ca gần đây và gợi ý kỹ năng cần luyện.
- RPC: `tu_chan_finish_shift_v2(p_shift_id, p_score, p_died, p_skills)` (gọi lại v1 để tính EXP) và `tu_chan_history_v1(p_limit)`. Cột mới `y_quan_private.tu_chan_shifts.skills`.
- Điểm do trình duyệt gửi lên, giống điểm tổng trước đây. Chưa dùng làm cơ sở thi cử hay xếp hạng công khai.

## Phòng học lâm sàng
- Danh sách ca ở Học và Thi hiển thị 5 ca mỗi trang, có nút Trước, Sau.

## Giải đấu tuần, huy hiệu, cá nhân hóa (03/10/2026)
- **Sự kiện tuần (giải đấu)** hiện ở pop-up nút "Sự kiện tuần" trên ảnh Cổng HIU TMC của trang `/vien-thuc-hanh/`, không nằm trong sảnh trực. Nút "Vào thi đấu" mở `/tu-chan/?arena=<khoa>` và tự nhận ca của sự kiện. Máy chủ (`20261003220000_vien_thuc_hanh_giai_dau_v1.sql`): mỗi khoa mỗi tuần (tuần ISO, giờ Việt Nam) có tối đa 3 ca cố định cho mọi người, chốt ở lần gọi đầu trong `y_quan_private.tu_chan_challenges`. RPC `tu_chan_challenge_v1(p_track)` trả ca, kết quả của tôi và top 10; `tu_chan_start_challenge_v1(p_track)` nhận ca kế tiếp chưa thi. Chỉ tính điểm lượt hoàn tất đầu tiên của mỗi ca; lượt dưới 60 giây không có điểm. Bảng chỉ hiện tên (`hiu_y_quan_profiles.display_name`) và tổng điểm, không hiện số ca. Bảng trống thì hiện trạng thái trống. Chỉ ca đang hoạt động trong danh mục được vào sự kiện: ca `nhap` không vào.
- Điểm vẫn do trình duyệt gửi lên nên bảng xếp hạng dùng để luyện tập và thi đua, chưa nên dùng để trao giải thật.
- **Hồ sơ trực** thu gọn (mở khi bấm), chỉ chủ tài khoản xem được; không hiện số ca ở sảnh. Danh sách ca đã trực nằm trong mục ẩn, mỗi ca có nút "Xem lại để học" (chơi lại không tính EXP, không vào sự kiện). Không có chức năng công khai ca cho người khác.
- **Huy hiệu**: tính ở trình duyệt từ `tu_chan_history_v1` (50 ca gần nhất), không lưu riêng.
- **Diễn biến trong ca**: ca cấp cứu báo điều dưỡng khi độ ổn định qua 65, 45, 25 với số liệu monitor lúc đó. **Chuỗi xử trí chuẩn** và nhận xét việc đầu tiên hiện ở màn kết quả. **Bàn giao SBAR** (A: chẩn đoán, R: điều trị) là phần luyện, không tính điểm.
- **Cá nhân hóa HIU Y Quán theo cấp** nằm ở trang HIU Y Quán trong Game Hub (tab "Y quán của tôi"), không nằm trong Viện Thực Hành (sảnh trực chỉ hiện lại màu, khung, lời chào đã chọn). Migration `20261003230000_vien_thuc_hanh_ca_nhan_hoa_v1.sql`: cấp = hạng + 1 (cấp 4 từ 700 EXP, EXP dùng chung). Cấp 4 đổi tên hiển thị, lời chào, màu Hoa đào và Chàm, khung trúc; cấp 5 màu Mực nho, khung sen, trang phục Học viện; cấp 6 khung rồng, trang phục Tông sư; cấp 7 màu Vàng Danh y. Kiểm tra cấp ở máy chủ trong `tu_chan_personalize_v1`; hai hàm cũ `hiu_y_quan_activate_v1` (đổi tên khi đã có hồ sơ) và `hiu_y_quan_customize_v1` (đổi áo) được thêm kiểm tra cấp. Hồ sơ đang có áo hoặc tên sẵn vẫn giữ nguyên.
- Đồ họa mở rộng: xem `docs/CHATGPT_PROMPT_DO_HOA.md`.

## Gói 1 đồ họa bác sĩ (03/10/2026)
Đã dùng: `public/tu-chan/bacsi/{nam,nu}-bieucam.webp` (6 biểu cảm) và `{nam,nu}-dongtac.webp` (12 tư thế nửa người), đã cắt, canh đáy, nén WebP. Trong ca trực, ảnh bác sĩ cạnh khung thoại đổi theo thao tác vừa làm (nghe tim phổi, huyết áp, bắt mạch, khám bụng, hồi sức, chỉ định xét nghiệm, hội chẩn) và theo độ ổn định, trực đêm; màn kết quả hiện biểu cảm theo điểm.
Chưa dùng vì ảnh lỗi: ô 3/4 sau của `goc`, toàn bộ `di` và `chay` (mất chân, hình vỡ). Cần ChatGPT vẽ lại 3 tệp này. `nghi` nam dùng được, chưa gắn.

## Bộ đồ họa mới (04/10/2026)
Thay toàn bộ gói 1 bằng bộ PNG nền trong suốt mới (bác sĩ nam tóc đen, nữ tóc nâu buộc cao, phong cách chibi): `public/tu-chan/bacsi/{nam,nu}-{bieucam,dongtac,di,chay}.webp`. Thêm 6 tranh `public/tu-chan/tranh/01..06.webp` (960×540).
- Chưa dùng: góc nhìn `goc`, `nghi` (giữ trong bản gốc, chưa cắt).

## Gói 2 bệnh nhân và gói 3 đạo cụ (04/10/2026)
`public/tu-chan/benhnhan/{nam,nu}_{tre,gia}-trangthai.webp` (10 nét mặt) và `public/tu-chan/vat/*.webp` (30 đạo cụ, 96 px). Ảnh bệnh nhân đối diện bác sĩ, đổi theo độ ổn định (đau ngực, khó thở, vã mồ hôi, li bì, mê man) và theo kết quả ca. Biểu tượng đạo cụ hiện cạnh các mục khám, xét nghiệm, xử trí theo từ khóa (`PROPS` trong `tu-chan/index.html`). Chưa dùng: tư thế toàn thân (`tuthe`), đi bộ, 8 góc của bệnh nhân, và các vật to (giường, cửa, rèm, xe cấp cứu…) vì cảnh vector hiện tại chưa có chỗ ghép.

## Cảnh phòng Trực vẽ lại (gói 2 + gói 3)

Bốn phòng (nội trú, cấp cứu, phòng khám, châm cứu) dùng ảnh `public/tu-chan/canh/` (đạo cụ + 7 tư thế bệnh nhân mỗi biến thể).
Bác sĩ đứng trong phòng làm đúng động tác vừa thực hiện (`docPose()`), hàng chân dung chỉ còn biểu cảm (`docExpr()`).
Ảnh chưa tải xong thì chỉ hiện nền phòng, rồi tự vẽ lại khi tải xong.

## Bật toàn bộ ca nháp (04/10/2026)

Chủ sở hữu quyết định bật cả 101 ca `nhap`. Trong ngân hàng nhúng, các ca này đổi sang `draft` (cùng trạng thái với 40 ca phát hành trước). Migration `20261004080000_vien_thuc_hanh_bat_ca_nhap.sql` (đã áp dụng lên production) thêm/kích hoạt dòng danh mục: tổng 141 ca hoạt động (Nội 50, Ngoại 41, YHCT 50). Cơ chế fail-closed với `nhap` vẫn giữ cho ca nhập mới sau này. Lưu ý: ca `draft` chưa phải đã duyệt chuyên môn; nên rà dần các ca tự soạn.


## Cảnh theo kịch bản và một bác sĩ duy nhất (04/10/2026)

- **Bỏ tranh truyện 01–06 và hiệu ứng bác sĩ chạy ngang**: tranh cố định không khớp bệnh nhân, bác sĩ và tốn băng thông. Cảnh phòng là phần hình ảnh chính của ca.
- **Trường `scene` trong ngân hàng ca** (`giuong`, `capcuu`, `phongkham`, `chamcuu`) xác định phòng vẽ theo câu chuyện thật (ca "đến phòng khám" ra phòng khám, ca "vào cấp cứu" ra cấp cứu). `setting` giữ nguyên cho danh mục máy chủ và cách điều trị (`TAY`). Có test đối chiếu `scene` với văn bản ca, giới tính, tuổi và cách xưng hô.
- **Tư thế bệnh nhân** do `patCell()` chọn theo phòng, bệnh cảnh (hô hấp, bụng, mất ý thức) và độ ổn định: nằm ngửa (nặng/mất ý thức), đầu cao (hô hấp), nằm nghiêng (bụng), ngồi mép giường (ổn định), ngồi ghế (phòng khám, châm cứu), cúi ôm bụng (phòng khám, đau quặn). Người bệnh dưới 12 tuổi dùng ảnh trẻ em riêng (`be_trai`, `be_gai`, 7 tư thế); chưa có ảnh biểu cảm trẻ em nên dòng chân dung trạng thái bị ẩn với trẻ.
- **Bác sĩ** đứng sát bệnh nhân, quay về phía bệnh nhân, làm đúng động tác vừa thực hiện; hàng chân dung chỉ còn biểu cảm. Bác sĩ lấy từ hồ sơ Y Quán (`doctor_avatar_id`); chưa đăng nhập dùng bác sĩ nam mặc định. Ảnh bác sĩ ở Y Quán (`y-quan-live/art/doctor-male|female.webp`) đã đổi sang cùng bộ gói 1, bỏ bộ sprite cũ trong `tu-chan`.
- Hướng nhìn: ảnh gốc của bác sĩ quay sang TRÁI. Đứng bên phải bệnh nhân (giường) thì giữ nguyên, đứng bên trái (phòng khám, châm cứu) thì lật.
- **Cần thêm ảnh**: biểu cảm trạng thái bệnh nhân trẻ em, người nhà đi cùng (mẹ của bé), tư thế nằm sấp trên bàn châm cứu.

## Y Quán: chống giật màn hình
- `game.js` dùng `paint()`: chia trang thành vùng (hero, nav, thông báo, hành trình, nội dung, chat) và chỉ thay vùng có HTML đổi; giữ vị trí cuộn. Trước đây mỗi lần chạm dựng lại toàn trang nên ảnh bị tạo lại và màn hình nhảy.
- `button:hover` chỉ áp dụng khi thiết bị có chuột (`hover:hover`) để cảm ứng không bị nhích nút.

## Y Quán: bệnh nhân (cần ảnh)
Người đến khám Y Quán là bệnh nhân ngoại trú: quần áo đời thường, không đồ bệnh viện. Chưa có bộ ảnh này; cần ChatGPT vẽ "bệnh nhân đời thường" cùng nét với Viện (nam/nữ trẻ/già, bé trai/gái) rồi tích hợp.
