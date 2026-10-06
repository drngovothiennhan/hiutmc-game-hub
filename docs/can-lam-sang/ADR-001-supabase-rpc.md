# ADR-001 — Phòng Cận Lâm Sàng: Supabase schema riêng + RPC server-side

- Trạng thái: ĐÃ DUYỆT KIẾN TRÚC CHO BƯỚC 1
- Ngày: 2026-10-06
- Phạm vi tài liệu này: quyết định kiến trúc; Bước 1A không tạo database, không chạy SQL ghi, không nối runtime.

## Quyết định

Phòng Cận Lâm Sàng dùng frontend tĩnh trên Cloudflare Pages và backend dữ liệu/chấm bài qua Supabase schema riêng + RPC server-side. Không tạo D1 hoặc Worker API mới ở giai đoạn này. Media/R2 để quyết định ở Bước 2c/2d.

Module mới chỉ nối hệ thống cũ bằng `case_id`. Không sửa/refactor engine, ngân hàng ca, Y Quán, Phòng Học hoặc Trực hiện tại. Đối tượng duy nhất ngoài schema `can_lam_sang_private` được phép tạo/drop là 3 hàm `public.cls_*_v1`.

## Lý do

1. Auth/session Supabase và `case_id` đã tồn tại, giảm số lớp tích hợp.
2. RPC server-side phù hợp yêu cầu không phát đáp án chuẩn trước khi nộp.
3. Schema riêng và migration additive cho phép rollback độc lập, không ALTER dữ liệu ca cũ.
4. Frontend vẫn là Pages nên route mới có thể đi qua gateway `/apps/game-hub/*` hiện hữu mà không cần sửa Worker gateway.

## Ràng buộc bắt buộc

### Feature flag — tắt phải tắt thật

Tên cờ: `clinical_lab_room_v1`.

Khi triển khai DB ở bước sau, RPC phải kiểm tra cờ trên server trước khi trả CaseBundle hoặc nhận submission. Khi cờ tắt, RPC trả mã nghiệp vụ `chua_mo` và không trả payload ca/đáp án.

Frontend `/can-lam-sang/` phải là bootstrap tối thiểu. Nó chỉ được dynamic-import mã module sau khi server xác nhận flag bật. Khi flag tắt, mã CBC/ECG/X-quang/nghe tim-phổi không được tải.

Bước 1A chưa tạo route hoặc RPC; đây là hợp đồng cho bước tiếp theo.

### Public CaseBundle là whitelist

Public CaseBundle chỉ được dựng từ các trường được khai báo trong `case-bundle.v1.schema.json` với `additionalProperties:false`.

Không áp dụng chiến lược serialize object nội bộ rồi xóa trường nhạy cảm.

Các trường legacy `opt`, `actions`, `teach`, các marker `+`, `~`, `++`, `-`, `!` và mọi grading metadata không được đi vào public bundle.

Adapter tách dữ liệu thành:
- `public_bundle`: stimulus lâm sàng được whitelist;
- `answer_key`: chỉ server dùng.

### Trạng thái nguồn và ca legacy

Toàn bộ 156 ca cũ khi qua adapter được đặt `review_status=CHUA_DUYET`.

Mọi nguồn legacy được gắn `provenance_tags=["legacy_unverified"]`, `review_status=CHUA_DUYET`. Không suy diễn `draft` thành `DA_DUYET`.

Thiếu reviewer hoặc license thì resource không thể đạt `DA_DUYET`.

### Data origin

Mọi CaseBundle bắt buộc `data_origin` thuộc `synthetic|anonymized`. Adapter legacy hiện đặt `synthetic` vì ngân hàng hiện hữu được khai báo là ca mô phỏng/giả định. Không dùng dữ liệu định danh bệnh nhân thật.

Chủ dự án xác nhận 2026-10-06: 156 ca là ca mô phỏng, không dùng bệnh án thật.

### Sinh dữ liệu xác định

Mọi generator của module phải lấy seed từ hash của:
`case_id + module + schema_version`.

Thư viện chuẩn cho module là `src/can-lam-sang/lib/seeded-rng.mjs`.

Cấm `Math.random()` và cấm `ORDER BY random()` trong pipeline sinh dữ liệu cận lâm sàng. Golden test cố định chuỗi để phát hiện thay đổi thuật toán ngoài ý muốn.

### Đáp án sau submit

RPC lấy CaseBundle công khai không được trả `answer_key`.

RPC submit ở bước sau sẽ nhận submission, chấm trên server và chỉ khi submission hợp lệ mới trả kết quả/đáp án/giải thích tương ứng.

## Service worker

`service-worker.js` hiện cache danh sách CORE gồm route cũ nhưng không có `/can-lam-sang/`. Fetch handler không chặn route mới: GET cùng origin được network-first và response hợp lệ có thể được cache sau lần truy cập. Nếu offline trước lần truy cập đầu tiên, navigation fallback hiện về root cache thay vì route CLS.

Theo yêu cầu Bước 1A: chỉ ghi nhận hành vi này, không sửa `service-worker.js`.

## Rollback dự kiến

Vì module tách route/schema/RPC và feature flag mặc định tắt, rollback vận hành ưu tiên là tắt `clinical_lab_room_v1`. Migration tương lai phải additive và không phụ thuộc thay đổi bảng legacy.

## Ngoài phạm vi Bước 1A

- Không tạo bảng/schema/RPC Supabase.
- Không sửa `public/vien-thuc-hanh/index.html`.
- Không sửa `service-worker.js`.
- Không tạo route runtime.
- Không quyết định R2/media.
