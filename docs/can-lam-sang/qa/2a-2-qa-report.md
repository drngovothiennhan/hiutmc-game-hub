# Step 2a-2 QA report

## K1–K10

| Test | Kết quả | Bằng chứng tóm tắt |
|---|---|---|
| K1 | PASS | Không có scenario được duyệt → `chua_co_scenario`. |
| K2 | PASS | 7 payload lỗi → `answers_khong_hop_le`; cùng attempt vẫn nộp hợp lệ được. |
| K3 | PASS | Submit hợp lệ → `ok=true`, 13/13. |
| K4 | PASS | User khác attempt → `khong_tim_thay`, không lộ dữ liệu. |
| K5 | PASS | Feature flag tắt → `chua_mo`. |
| K6 | PASS | Lượt mở thứ 4 → `qua_3_luot_mo`; lượt thứ 11 → `qua_10_luot_ngay`. |
| K7 | PASS | Hai phiên đồng thời tại ngưỡng 3 không vượt quá 3 attempt. |
| K8 | PASS | Hết scenario vẫn có thể start lại và chọn lại scenario. |
| K9 | PASS | Quyền anon/authenticated không được đọc trực tiếp CBC attempts. |
| K10 | PASS | Start/get trước submit không lộ `pattern_id`, `answer_key`, `expected_classifications`. |

**Tổng: 10 PASS / 0 FAIL / 0 CHƯA CHẠY.**

## 007 rollback

- (a) Có attempt: rollback bị chặn bởi guard.
- (b) Sau cleanup: rollback chạy sạch.

QA cuối sạch; không ghi secret, token hoặc ID người dùng.
