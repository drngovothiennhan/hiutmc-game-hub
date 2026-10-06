# ADR-002 — Phát hành tạm thời các ca chưa kiểm duyệt chuyên môn

## Quyết định của chủ dự án

> “Trước mắt đưa các case lên hoạt động và gán nhãn case do A.I mô phỏng. Sau đó cuối tuần sẽ kiểm duyệt 1 lần.”

**Ngày/giờ:** 06/10/2026 15:04 (UTC+07:00)  
**Người quyết định:** Ths. Ngô Võ Thiện Nhân

## Phạm vi

Cho phép nội dung mô phỏng chưa được kiểm duyệt chuyên môn được phục vụ trong cửa sổ thử nghiệm có kiểm soát, với nhãn do máy chủ trả về. Ca chưa duyệt vẫn giữ review_status=CHUA_DUYET; ca đã duyệt không mang nhãn thử nghiệm.

## Chốt chặn

1. Fail-closed: thiếu cấu hình, tắt hoặc quá hạn chỉ phục vụ DA_DUYET.
2. Hết hạn đề xuất: 2026-10-12T23:59:59+07:00.
3. Production vẫn bắt buộc câu “DUYỆT ÁP PRODUCTION”.
4. Không sửa 001–008.
5. Không sửa app.js, service-worker.js, package*.json, public/vien-thuc-hanh/index.html.
6. Không thêm dependency.
7. Không tự đặt DA_DUYET.
8. Không viết nhận xét lâm sàng thay người duyệt.
9. Không đưa answer key/grading metadata vào public payload trước submit.
10. QA chỉ được áp dụng sau lệnh riêng của kiến trúc sư.

## Hết hạn / gia hạn

Không tự động gia hạn. Chỉ gia hạn khi có quyết định mới của chủ dự án/kiến trúc sư, ghi rõ thời hạn mới và lý do. Khi hết hạn, gate fail-closed và chỉ DA_DUYET được phục vụ.

## Người chịu trách nhiệm kiểm duyệt

**Ths. Ngô Võ Thiện Nhân (sinh viên Y khoa ngành YHCT)** chịu trách nhiệm kiểm duyệt theo từng lô.

## Trạng thái

ADR đề xuất L1. Chưa áp dụng SQL, chưa mở QA, chưa mở production.
