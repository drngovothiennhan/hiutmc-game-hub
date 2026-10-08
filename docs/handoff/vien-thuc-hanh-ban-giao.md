# Bàn giao: Viện Thực Hành (HIU TMC)

Đọc file này trước khi làm bất kỳ việc gì. Cập nhật lần cuối: 2026-10-08 (giờ Việt Nam).

## 1. Bối cảnh
- Chủ sở hữu sản phẩm: **drngovothiennhan** (người dùng). Người này duyệt mọi thay đổi chạm vào trang đang chạy.
- **Viện Thực Hành là một phần của HIU TMC**, KHÔNG thuộc GameHub. Có thể phát triển thành app riêng sau này. Xem `docs/can-lam-sang/ADR-003-vien-thuc-hanh-tach-rieng.md`.
- Viện gồm: học lâm sàng, học cận lâm sàng (Phòng Cận Lâm Sàng), trực bệnh viện. Mỗi khu phải nâng cấp độc lập được.
- Hiện mã Viện vẫn nằm trong repo `hiutmc-game-hub` (thư mục `public/can-lam-sang`, `src/can-lam-sang`). Việc tách repo đang chờ người dùng tạo repo trống `vien-thuc-hanh`.

## 2. Trạng thái hiện tại
- `main` (repo `hiutmc-game-hub`) có: PR #134 (đổi tên, chia chuyên khoa, 5 ca/trang) và PR #135 (nhãn AI dạng chip, khối "Thông tin về nội dung AI", ADR-003). Cả hai đã deploy production.
- Nhánh `claude/xquang-hoc-lieu` (commit `6f59d3f`): bản nháp 10 ca X-quang ngực mô phỏng + kế hoạch. **Chưa mở PR, chưa duyệt.** Nhãn trong file này còn là nhãn dài cũ, cần đổi sang chip AI khi merge.
- Đáp án X-quang: `data/can-lam-sang/xquang/cases.answer-key.private.json`. File này bị `.gitignore` chặn, **chỉ tồn tại trên máy làm việc cũ**. Không commit.
- Chưa có chuyên gia nào duyệt nội dung. Mọi ca hiện có đều là mô phỏng do AI soạn.

## 3. Quy tắc nội dung (đã thống nhất với người dùng)
- Nội dung chưa được chuyên gia xác nhận hoặc chưa có nguồn rõ ràng: đánh dấu bằng **chip "AI"** nhỏ ở góc thẻ ca. Không đặt nhãn dài trên từng ca.
- Giải thích đầy đủ đặt trong khối "Thông tin về nội dung AI" trên trang chủ phòng.
- Nội dung chỉ có giá trị tham khảo thực hành, không dùng để chẩn đoán hay điều trị.
- Không bịa dữ liệu học viên (tên, điểm, bảng xếp hạng). Hiển thị trạng thái rỗng khi thiếu dữ liệu thật.
- Đáp án và giải thích không đưa vào bundle công khai trước khi nộp bài. Dùng `*.private.json` cho các file này.

## 4. Quy tắc làm việc (quan trọng)
- **Không merge PR và không deploy production khi chưa có người dùng duyệt.** Ngoại lệ đã có: PR #134 và #135 được duyệt rõ ràng.
- Không sửa SQL production, không bật cờ `clinical_lab_room_v1`, không chạy `016_cls_enable_unreviewed_2026-10-12.sql`. Đó là việc của kiến trúc sư sau khi QA đạt (theo runbook). Cửa sổ ADR-002 hết hạn **2026-10-12 23:59 (+07)**.
- Làm việc trên nhánh riêng, mở PR vào `main`, chờ CI xanh rồi mới đề xuất merge.
- Repo `hiutmc-game-hub` deploy production tự động khi có push lên `main` (workflow `cloudflare-production.yml`). Không có bước duyệt riêng, nên mọi merge vào `main` là deploy ngay.
- Repo `hiutmc-ecosystem` có `CLAUDE.md` riêng, quy định `feature → main → production`, tên nhánh `claude/<topic>`. Quy tắc này khác với game-hub. **Chưa rõ quy trình nào áp dụng cho Viện**, cần hỏi người dùng khi tách repo.

## 5. Quirk môi trường (đã gặp nhiều lần)
- Clone là shallow và chỉ theo dõi `main`. Sau khi push nhánh mới, ref `origin/<nhánh>` có thể không tự tạo, khiến hook báo "unpushed commits". Cách xử lý:
  `git fetch --depth=50 origin +refs/heads/<nhánh>:refs/remotes/origin/<nhánh>`
  `git config branch.<nhánh>.remote origin` và `git config branch.<nhánh>.merge refs/heads/<nhánh>`
- Không dùng `gh pr create` (GraphQL bị chặn). Dùng `gh api repos/<owner>/<repo>/pulls -X POST ...`.
- Không cài `node_modules` được trong sandbox (registry trả 403). Không build được local. Dựa vào CI (`npm ci`, test, build, preview).
- Dùng `git push -u origin <nhánh>`, sau đó chạy lệnh fetch ở trên.

## 6. Cấu trúc code chính
- `public/can-lam-sang/bootstrap.js`: trang chủ phòng, cổng cờ, điều hướng.
- `public/can-lam-sang/core.js`: Luyện ca bệnh (danh sách theo chuyên khoa, 5 ca/trang, chi tiết ca, chấm).
- `public/can-lam-sang/cbc.js`: Đọc xét nghiệm máu.
- `public/can-lam-sang/auscultation.js` + `chest-viewer.js`: Nghe tim phổi 3D.
- `public/can-lam-sang/index.html`: CSS chung của phòng.
- `src/can-lam-sang/core/specialties.mjs`: phân nhóm chuyên khoa theo mã ca (gán ở frontend, không đổi SQL).
- `src/can-lam-sang/core/ui-helpers.mjs`, `src/can-lam-sang/cbc/*`: logic dùng chung.
- `supabase/proposed/can-lam-sang/`: SQL và seed đề xuất (chưa áp production).
- `docs/can-lam-sang/`: ADR, runbook, thiết kế, QA.
- Phụ thuộc vào GameHub khi tách: `src/auth/session.js`, `src/config.js`, dự án Supabase dùng chung.

## 7. Việc đang chờ
1. Người dùng tạo repo trống `vien-thuc-hanh` trên GitHub (Private hoặc Public, không README, không .gitignore, không license). **Tôi không tự tạo được repo.**
2. Sau khi có repo: giai đoạn 1 tách mã Viện, copy phần đăng nhập và cấu hình cần thiết, giữ chung Supabase, deploy Cloudflare Pages riêng. Chờ người dùng xác nhận trước khi bắt đầu.
3. Nhánh X-quang: người dùng duyệt nội dung, chuyên gia xác nhận, rồi mới mở PR.
4. Hỏi người dùng quy trình deploy cho Viện (theo `main` của GameHub hay theo `production` của ecosystem).

## 8. Gợi ý cho người tiếp nhận
- Đọc file này, rồi đọc `ADR-003`, `ADR-002`, `docs/can-lam-sang/release/2a-5-runbook.md`.
- Trước khi sửa code, kiểm tra `git status` và nhánh hiện tại.
- Với mọi việc chạm trang đang chạy hoặc dữ liệu production, hỏi người dùng trước.
