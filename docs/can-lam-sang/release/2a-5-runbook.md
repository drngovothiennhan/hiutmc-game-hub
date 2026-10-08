# Runbook Phòng Cận Lâm Sàng — ADR-002 / Bước 3

> Tài liệu này mô tả quy trình đề xuất và QA. Không tự thực thi SQL production, không tự mở cờ và không tự merge.

## 0. Nguyên tắc

- 156 ca lõi giữ `review_status=CHUA_DUYET`; tuyệt đối không tự đặt `DA_DUYET`.
- Ca được phục vụ thử nghiệm chỉ khi server gate `clinical_lab_room_v1` cho phép tài khoản trong allowlist.
- Nhãn server trả về: **Ca mô phỏng do A.I mô phỏng — CHƯA KIỂM DUYỆT**.
- Cửa sổ ADR-002 hết hạn lúc **2026-10-12T23:59:59+07:00**; không tự gia hạn.
- Không đưa answer key, grading metadata, giải thích hoặc nguồn vào public bundle trước khi nộp.
- Không chạy dữ liệu thử trên production. QA dùng project **HIU TMC Game Hub G3 QA** hoặc môi trường được kiến trúc sư chỉ định.
- Không ghi token, JWT, publishable key hoặc dữ liệu người dùng vào báo cáo.

## 1. Chuẩn bị nội dung

1. Adapter legacy tạo `public_bundle` whitelist-only và `answer_key` server-only.
2. Public bundle có choices chỉ gồm văn bản cho từng nhóm chẩn đoán và hành động.
3. Choices được xáo trộn xác định theo `case_id`; không dùng `Math.random()`.
4. Tất cả ca lõi và resources legacy giữ `CHUA_DUYET`.

## 2. Seed đề xuất

- Chạy `node supabase/proposed/can-lam-sang/004_cls_seed_generator.mjs --sql`.
- Kiểm tra đủ 156 ca, không có `DA_DUYET`.
- Nếu tổng case seed vượt 400 KB, dùng các lô `seed-core-A.sql` … `seed-core-H.sql`, tối đa 20 ca/lô.
- Seed idempotent và không thay đổi runtime flag.
- Ghi SHA-256 + byte của từng file seed vào PR.

## 3. RPC list/get/submit

- `cls_list_cases_v1()`: chỉ trả metadata công khai, review fields và trạng thái đã nộp của chính user.
- `cls_get_case_v1(case_id)`: chỉ trả public bundle khi content gate cho phép.
- `cls_submit_v1(case_id,'core',answers)`: kiểm tra choices theo answer key server-side; chỉ sau submit mới trả title reveal, resources, notes và teaching explanation.
- `cls_get_submission_v1(case_id)`: chỉ đọc kết quả đã nộp của chính user; không dùng `cls_submit_v1(...,{})` để truy hồi.
- `da_nop`: UI hiển thị lại kết quả đã nộp, không coi là lỗi.
- `chua_mo`: UI hiển thị phòng chưa mở.
- `khong_tim_thay`: UI hiển thị không tìm thấy ca.
- `answers_khong_hop_le`: UI yêu cầu chọn lại.
- `khong_xac_thuc`: UI yêu cầu đăng nhập.

## 4. Mở cờ thử nghiệm

- Kiến trúc sư kiểm tra flag đang đúng allowlist.
- Chỉ sau khi QA đạt mới thêm tài khoản thử vào allowlist.
- Không chuyển audience sang toàn bộ authenticated nếu chưa có quyết định riêng.
- Khi hết hạn ADR-002, gate phải fail-closed nếu chưa có quyết định gia hạn mới.

## 5. QA tối thiểu

- Build sạch, `npm test` xanh, verify dist xanh.
- Với toàn bộ 156 ca: choices khớp answer key; payload có giá trị lạ bị loại.
- Public bundle không chứa answer key/explanation/grading metadata ngoài text choices.
- UI hoạt động ở 360×640, bàn phím truy cập được, không tràn ngang.
- Kiểm tra flag off/on và các return-code ở trên.
- Nếu có SQL tool: chỉ QA project; tự dọn dữ liệu thử sau kiểm tra.
- Nếu không có SQL tool: ghi rõ **QA SQL chưa chạy, chờ Claude**.

## 6. Production

Không áp SQL production trong Bước 3. Kiến trúc sư tự áp SQL, mở cờ và merge sau khi nghiệm thu độc lập.

## 7. Rollback

- Thứ tự rollback bắt buộc: `015_cls_get_submission_v1_rollback.sql` → `013_cls_list_cases_v1_rollback.sql` → `010_cls_publish_gate_rollback.sql`.
- Không tự drop foundation hoặc dữ liệu đã seed.
- Nếu rollback bị guard dữ liệu chặn, dừng và báo kiến trúc sư.

## 8. Script bật cờ (không chạy trong Bước 3)

- Script tách riêng: `016_cls_enable_unreviewed_2026-10-12.sql`.
- Script đặt `unreviewed_enabled=true` và hạn `2026-10-12T23:59:59+07:00`.
- Chỉ kiến trúc sư quyết định và thực thi sau khi QA đạt; PR này không chạy script.
