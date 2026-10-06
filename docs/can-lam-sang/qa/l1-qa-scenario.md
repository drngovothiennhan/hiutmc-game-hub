# QA L1 — Kịch bản chờ cấp phép

**Chưa chạy.** Kịch bản này chỉ được thực thi khi kiến trúc sư cấp lệnh QA riêng. Không chạy production và không đặt `DA_DUYET`.

| ID | Kịch bản | Kết quả bắt buộc |
|---|---|---|
| K-L1-1 | Chạy `001_cls_foundation.sql` trên QA | Foundation tồn tại; feature flag đóng |
| K-L1-2 | Chạy `002_cls_rpc.sql` trên QA | RPC foundation đúng chữ ký/quyền |
| K-L1-3 | Chạy `005_cls_cbc_tables.sql` trên QA | CBC tables + RLS đúng |
| K-L1-4 | Chạy `006_cls_cbc_rpc.sql` trên QA | CBC start/get/submit đúng contract |
| K-L1-5 | Chạy `009_cls_publish_gate.sql` trên QA | Gate fail-closed; config RLS; không client EXECUTE |
| K-L1-6 | Với ca `DA_DUYET` | Không có `review_label` |
| K-L1-7 | Bật `unreviewed_enabled=true` và đặt hạn riêng bằng UPDATE trên QA | Ca `CHUA_DUYET` còn hạn trả nhãn |
| K-L1-8 | Sau khi hết hạn | `CHUA_DUYET` bị fail-closed |
| K-L1-9 | Chạy `011_cls_core_submit_validation.sql` | Submit core đúng 3 tham số; hợp lệ ghi submission/reveal; sai khóa/giá trị/object rỗng/thiếu khóa bị từ chối; idempotent `da_nop` |
| K-L1-10 | Kiểm trả nhãn core sau submit | `review_status/review_label` do server trả |
| K-L1-11 | Chạy `010_cls_publish_gate_rollback.sql` | Phục hồi đúng RPC 002/006; chỉ xóa helper/config mới |
| K-L1-12 | Kiểm sau rollback | RPC gốc tồn tại; quyền đúng; không còn publish config/helper |

**Điều kiện ghi nhận:** lưu project ref QA, thời điểm, SQL đã chạy, return code thực tế và kết quả từng K-L1. Không dùng token/secret trong báo cáo.
