# Runbook phát hành CBC Step 2a-5 — Production

> **Tài liệu — KHÔNG THỰC THI trong bước 2a-5 hiện tại.**
>
> Không có bước nào dưới đây được phép chạy chỉ vì tài liệu này tồn tại.

## 0. Điều kiện tiên quyết

- [ ] Có pattern CBC-P01 ở trạng thái **DA_DUYET** theo giao thức A7, với hồ sơ nguồn và chữ ký hợp lệ.
- [ ] Có câu lệnh rõ ràng của kiến trúc sư: **DUYỆT ÁP PRODUCTION**.
- [ ] QA E1–E9 đã PASS đầy đủ.
- [ ] Không còn lỗi hoặc cảnh báo blocker từ QA.
- [ ] Có phương án rollback và người chịu trách nhiệm xác nhận rollback.
- [ ] Xác nhận đúng project production: `gzmpnsrwqjpsbklyflqr`.

**Điểm dừng:** nếu bất kỳ mục nào chưa đạt, DỪNG — không chạy SQL production.

## 1. Áp dụng foundation

**Người duyệt:** [Kiến trúc sư / người được ủy quyền]

**Lệnh kiểm trước:** xác nhận project ref là `gzmpnsrwqjpsbklyflqr`; xác nhận chưa có thay đổi ngoài phạm vi.

**Lệnh áp dụng:** `001_cls_foundation.sql`

**Lệnh kiểm sau:** kiểm tra schema/tables foundation tồn tại; kiểm tra feature flag `clinical_lab_room_v1` có `enabled=false`, `audience=allowlist`, allowlist rỗng.

**Điểm dừng:** nếu flag không đúng trạng thái đóng, DỪNG và rollback.

## 2. Áp dụng RPC nền

**Người duyệt:** [Kiến trúc sư / người được ủy quyền]

**Lệnh áp dụng:** `002_cls_rpc.sql`

**Lệnh kiểm sau:** xác nhận `cls_flag_status_v1()` và các RPC foundation tồn tại; xác nhận quyền EXECUTE chỉ dành cho `authenticated`.

**Điểm dừng:** không tiếp tục nếu quyền hoặc search_path sai.

## 3. Áp dụng CBC schema

**Người duyệt:** [Kiến trúc sư / người được ủy quyền]

**Lệnh áp dụng:** `005_cls_cbc_tables.sql`

**Lệnh kiểm sau:** kiểm tra bốn bảng CBC tồn tại, RLS bật, không cấp quyền trực tiếp cho client roles.

**Điểm dừng:** không seed pattern/scenario nếu schema chưa đạt.

## 4. Áp dụng CBC RPC

**Người duyệt:** [Kiến trúc sư / người được ủy quyền]

**Lệnh áp dụng:** `006_cls_cbc_rpc.sql`

**Lệnh kiểm sau:** chỉ kiểm tra cấu trúc/quyền/RPC contract theo hồ sơ đã phê duyệt; **không dùng dữ liệu thử nghiệm trên production** và không in JWT/token.

**Điểm dừng:** mọi return-code hoặc quyền khác kỳ vọng => DỪNG.

## 5. Tạo cờ đóng

**Người duyệt:** [Kiến trúc sư / người được ủy quyền]

**Lệnh kiểm:** `clinical_lab_room_v1` phải ở `enabled=false`, `audience=allowlist`, allowlist rỗng.

**Hành động:** tạo/đảm bảo cờ với đúng trạng thái trên.

**Điểm dừng:** chưa được đưa bất kỳ user nào vào allowlist.

## 6. Seed pattern đã duyệt

**Người duyệt:** [Người duyệt CBC-P01]

**Lệnh áp dụng:** seed **chỉ pattern DA_DUYET** đã được duyệt; không seed pattern fixture/chưa duyệt.

**Lệnh kiểm:** kiểm tra pattern ID, review metadata, reference metadata, mapping và scenario count.

**Điểm dừng:** nếu có bất kỳ pattern ngoài danh sách đã duyệt, DỪNG và rollback.

## 7. Bật allowlist nhóm thử

**Người duyệt:** [Kiến trúc sư]

**Lệnh kiểm trước:** xác nhận danh sách user thử đã được cung cấp và đúng đối tượng.

**Hành động:** chỉ thêm nhóm thử vào allowlist; vẫn giữ `enabled=true` + `audience=allowlist`.

**Điểm dừng:** không chuyển sang `all_authenticated`.

## 8. Kiểm production sau mở thử

**Người duyệt:** [Kiến trúc sư]

Kiểm tối thiểu:

- flag status đúng đối với user trong/ngoài allowlist;
- CBC start/get/submit đúng contract;
- 13 chỉ số và đơn vị đúng pattern đã duyệt;
- không lộ answer key/pattern metadata trước submit;
- retry/duplicate submit trả đúng code;
- giới hạn lượt hoạt động đúng;
- log không chứa secret/JWT.

**Điểm dừng:** bất kỳ FAIL nào => không mở rộng allowlist.

## 9. Rollback

**Người duyệt rollback:** [Kiến trúc sư]

**Trước rollback:** nếu có submissions, xử lý guard dữ liệu theo đúng quy trình; không tự ý bỏ guard.

**Lệnh rollback CBC:** `007_cls_cbc_rollback.sql`

**Lệnh rollback foundation:** `003_cls_rollback.sql`

**Lệnh kiểm sau rollback:** xác nhận RPC/tables/schema liên quan đã được xử lý đúng và feature flag không còn mở.

**Điểm dừng:** nếu rollback bị guard chặn vì có dữ liệu, DỪNG — không dùng tuỳ tiện để ép xóa dữ liệu.

## 10. Quy tắc không tự ý

- Kiểm tra production sau mở thử chỉ thực hiện theo lệnh **DUYỆT ÁP PRODUCTION** và không dùng dữ liệu thử nghiệm để kiểm chức năng.

- Không áp production khi chưa có **DUYỆT ÁP PRODUCTION**.
- Không tự đặt pattern thành DA_DUYET.
- Không thay đổi production project ref.
- Không in secret, publishable key, JWT hoặc user token vào báo cáo.
- Không merge PR code/docs nếu chưa có lệnh merge.
