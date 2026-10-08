# Gia Viên Dược Thảo (ảnh thật 3D) — kịch bản, cách chơi và kế hoạch thay thế

Cập nhật 08/10/2026. Bản chạy: `public/gia-vien-duoc-thao-preview/index.html` (một file, không phụ thuộc thư viện ngoài).
Xem thử: `https://game-hub-intro-ux.hiutmc-game-hub.pages.dev/gia-vien-duoc-thao-preview/` (thêm `?mode=fp` để mở thẳng 3D).

## 1. Game này là gì

Game tham quan và học nhận biết cây trong khu vườn dược thảo **thật**, dựng hoàn toàn từ ảnh và video thật của vườn (bố cục từ 12/09 đến 30/09/2026, không có người). Không có cảnh do AI tạo. Có ba cách xem: Ảnh thật (11 khung), Khám phá thực cảnh (6 trạm 2.5D có điểm chạm) và Góc nhìn thứ nhất 3D (6 trạm toàn cảnh quanh người chơi, trong đó 2 trạm là lưu trữ bố cục cũ).

Đây **không** phải game trồng cây của Gia Viên hiện tại (trồng, tưới, bón, thu hoạch, ví tín dụng). Hai game khác nhau về vòng chơi; xem mục 6 về việc thay thế.

## 2. Kịch bản

**Mở đầu (hộp thoại lần đầu vào game).** Sáng nay người chơi nhận chìa khoá khu vườn dược thảo của khoa. Bảng danh sách cây đã treo ở giàn, nhưng các nhãn còn chờ người kiểm lại. Nhiệm vụ: đi hết vườn, tìm đúng từng cây, mở thẻ cây, và ghi lại vườn đã đổi thế nào so với mấy tháng trước.

**Chương 1 · Bước vào vườn.** Người chơi ghé đủ 6 trạm 2.5D và đứng ở 4 trạm 3D hiện trạng. Mục tiêu là quen đường đi và các mốc: giàn, bảng danh sách, đèn trụ, tường tranh, hàng bồn đen.

**Chương 2 · Tìm và biết cây.** Mỗi nhiệm vụ cho một gợi ý nhìn (ví dụ "cây lá dài hẹp trong chậu đỏ"). Người chơi chạm điểm vàng đúng vị trí; chạm đúng thì mở **thẻ cây** kèm một câu hỏi về đặc điểm nhận biết. Trả lời đúng lần đầu được điểm đầy đủ, trả lời sau khi sai được điểm thấp hơn.

**Chương 3 · Vườn đổi theo thời gian.** Người chơi mở hai trạm lưu trữ (10/07 và 06/06) trong 3D. Mỗi trạm bật một câu hỏi đối chiếu: tường phía sau giàn đã được vẽ lại thành gì, và vì sao ảnh cũ nằm ở mục Lưu trữ.

**Kết.** Khi đủ ba chương, hiện màn hoàn thành với điểm, hạng và lời nhắc rằng tên cây còn là định danh tạm.

## 3. Điểm và hạng

| Việc | Điểm | Số lần |
|---|---|---|
| Ghé một trạm 2.5D lần đầu | 5 | 6 |
| Đứng ở một trạm 3D hiện trạng lần đầu | 5 | 4 |
| Tìm đúng cây của nhiệm vụ | 10 | 5 |
| Câu hỏi thẻ cây, đúng ngay lần đầu | 10 (sai trước rồi đúng: 5) | 5 |
| Câu đối chiếu theo thời gian | 10 | 2 |
| **Tối đa** | **170** | |

Hạng: Khách tham quan (0), Học việc (40), Người giữ vườn (90), Người giữ vườn xuất sắc (140).

Tiến trình lưu trong `localStorage` của trình duyệt (khoá `gv-thuc-canh-v1`), có nút "Chơi lại từ đầu". **Chưa ghi vào Study OS**, không phát tín dụng hay phần thưởng thật; thẻ thông báo điều này ngay trong game.

## 4. Nội dung thẻ cây (định danh tạm)

Nhận diện bằng mắt từ ảnh. Tên, độ chắc và vị trí đều là tạm, chờ danh mục chính thức và mã QR.

| Mã tạm | Cây | Độ chắc | Trạm | Câu hỏi thẻ cây |
|---|---|---|---|---|
| Tạm 01 | Sả | 0,60 | 4 (phải sân) | Đặc điểm nhận ra sả |
| Tạm 02 | Sắn dây | 0,50 | 3 (giàn chính diện) | Sắn dây thuộc dạng cây nào |
| Tạm 03 | Bạc hà | 0,35 (vị trí chỉ là đoán) | 4 (phải sân) | Đặc điểm dễ kiểm tra khi nhận biết bạc hà |
| Tạm 04 | Nhóm gừng/riềng (chưa chốt) | 0,40 | 3 (giàn chính diện) | Phần dùng làm gia vị của họ Gừng |
| Tạm 05 | Lưỡi hổ | 0,85 | 6 (dọc tường) | Đặc điểm dễ nhận ra lưỡi hổ |

Thư mục Drive "MÃ QR CÂY THUỐC" hiện chỉ có 3 mã: Bạc hà, Sim, Sắn dây. Chưa đọc được nội dung bên trong mã. **Sim** chưa thấy trong ảnh nào nên chưa đưa vào game.

Quy tắc nội dung: câu hỏi chỉ về đặc điểm nhận biết và về đối chiếu bố cục. Không có liều dùng, công dụng điều trị hay chỉ dẫn lâm sàng. Mọi thông tin dược liệu cần đối chiếu nguồn (G4 trong `GAME_CONTRACTS.md`) trước khi bổ sung.

## 5. Cách thêm cây khi có danh mục chính thức

Trong `index.html`, sửa bốn khối dữ liệu (không cần đổi logic):

1. `plants`: thêm cây (`id`, `code`, `name`, `latin`, `confidence`, `scene`, `title`, `why`, `hint`, `status`). Khi có số chính thức thì đổi `code` từ "Tạm 0x" sang số thật.
2. `quests`: thêm một nhiệm vụ trỏ tới `plantId`.
3. `scenes[].hotspots`: thêm `{plantId, x, y}` (toạ độ 0–1 trên ảnh của trạm).
4. `plantQuiz`: thêm câu hỏi thẻ cây (`q`, `opts`, `ok`, `why`).

Điểm tối đa (`GV_MAX`) và danh sách chương tự cập nhật theo dữ liệu. Đổi bộ câu hỏi hoặc tên cây sẽ không làm hỏng tiến trình đã lưu; đổi `id` của cây thì tiến trình của cây đó coi như chưa mở.

## 6. Thay thế Gia Viên Dược Thảo đang chạy trên Study OS

**Hiện trạng đã đọc trong repo.** Gia Viên đang chạy là game có máy chủ làm chủ dữ liệu (Supabase dùng chung với Study OS): trồng, tưới, bón, thu hoạch, kho giống, kho dược liệu, ví tín dụng, 9 ô vườn và phần thưởng mốc `herb_garden_claim_milestone_v1`. `docs/GAME_CONTRACTS.md` quy định không đổi gameplay đang chạy và không tạo bản lưu rỗng thay cho dữ liệu cũ. Trong Hub, mục `garden` mở runtime Study OS, mục `garden-continuation` là phần mở rộng trong Hub.

**Vì sao chưa thay thẳng.** Gia Viên Dược Thảo 3D chưa ghi được gì lên máy chủ. Nếu thay ngay, thành viên mất đường vào ví tín dụng, kho giống và các ô vườn đã mở; đây là thay đổi không rút lại được với dữ liệu thật. Vì vậy bản này được làm **sẵn sàng thay thế**, chưa thay.

**Ba bước để thay, theo thứ tự an toàn:**

1. **Chạy song song (đã làm, 08/10/2026).** Mục `garden-field` "Gia Viên Dược Thảo 3D" nằm trong `src/data/world-map.js` với `state: 'available-live'` và `href: '/gia-vien-duoc-thao-preview/'`, đứng cạnh mục Gia Viên cũ. Mục `garden` (Study OS) giữ nguyên. `test/contracts.test.js` đã cập nhật danh sách mục chạy được và thêm test kiểm tra trang tồn tại. Tên đường dẫn còn chữ preview; đổi sang `/gia-vien-thuc-canh/` khi chuyển hướng ở bước 3.
2. **Nối Study OS (cần duyệt trước).** Tiến trình và thưởng phải đi qua RPC phía máy chủ theo mẫu `herb_garden_claim_milestone_v1`: một bảng ghi nhận theo `(member_id, milestone_key)` có RLS và không cấp quyền trực tiếp, RPC chỉ cho người đã đăng nhập và đã duyệt, trình duyệt không bao giờ gửi giá trị thưởng. Đề xuất mốc: hoàn thành từng chương (3 mốc) và mở đủ 5 thẻ cây. Chưa viết migration và chưa chạm vào cơ sở dữ liệu.
3. **Chuyển hướng.** Khi bước 2 xong và đã kiểm thử bằng tài khoản thử riêng (không dùng bản lưu của thành viên thật), mới đổi mục `garden` sang game mới. Giữ nguyên runtime Study OS cũ và dữ liệu `herb_garden_*` để thành viên cũ vẫn truy cập được.

## 7. Nghiệm thu

Đã chạy (trình duyệt headless, iPhone 13 và desktop, ảnh thật từ bản build tĩnh):

- Chơi trọn vòng: ghé 6 trạm, tìm đủ 5 cây (mỗi cây trả lời sai một lần rồi đúng), đứng 4 trạm 3D hiện trạng, trả lời 2 câu đối chiếu. Kết quả 145/170 điểm, hạng cao nhất, màn hoàn thành hiện đúng.
- Tải lại trang: điểm và thẻ cây còn nguyên; hộp thoại mở đầu chỉ hiện một lần.
- Không có lỗi script. 109 test của repo đạt (1 test bỏ qua).

Chưa làm: kiểm thử trên máy thật, đồng bộ Study OS, kiểm tra thiết bị không có WebGL ngoài thông báo quay về chế độ Ảnh thật.

## 8. Việc cần chủ dự án quyết

1. Danh mục cây chính thức theo số, và nội dung mã QR của 3 mã đã có (Bạc hà, Sim, Sắn dây).
2. Bước 2 (RPC và bảng ghi nhận trên Supabase dùng chung) cần kiểm thử với phiên đăng nhập thành viên thật trên bản xem thử trước khi áp dụng.
3. Thời điểm chuyển hướng mục `garden` sang game mới (bước 3).

## 9. Cập nhật 08/10/2026 — chủ dự án quyết định thay hẳn

Chủ dự án xác nhận game cũ chỉ tồn tại trong Study OS và chọn thay hẳn. Trong Game Hub, mục `garden` giờ mở `/gia-vien-duoc-thao-preview/`; mục `garden-field` trùng đã bỏ. Runtime Study OS và dữ liệu `herb_garden_*` **không bị xoá hay sửa**. Việc ghi tiến trình lên Study OS (bước 2) vẫn chưa làm; `garden-continuation` giữ nguyên.

## 10. Cập nhật 08/10/2026 (tối) — Chương 4 "Nhận mặt cây" và ảnh mới

- **Chương 4:** 9 ảnh cận do chủ vườn chụp và gắn nhãn (cây nhót, cây mần tưới, cúc hoa, mỏ quạ, sâm bố chính, cỏ ngọt, ngũ trảo, cúc tần, cây gai). Ảnh trong game đã xoá nhãn; người chơi chọn tên đúng trong 4 đáp án. Đúng ngay lần đầu 8 điểm, sai trước rồi đúng 4 điểm. Điểm tối đa nay là 242; hạng đổi ngưỡng thành 0 / 50 / 120 / 200.
- **Đối chiếu với bảng 70 cây:** cúc hoa (18), cúc tần (19), cây gai (28 "Gai") và sâm bố chính (6 "Bổ chính sâm", cùng một cây) khớp danh mục đọc từ ảnh bảng. Các cây còn lại chưa có số.
- **Ảnh toàn cảnh mới có mã QR:** thêm 4 khung vào bộ ảnh thật (15 khung).
- Tên khoa học ghi "(tạm)" khi chưa chắc; nội dung chỉ nói đặc điểm nhận biết.
