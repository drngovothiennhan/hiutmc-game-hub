# Đối chiếu số liệu 05/10/2026

Mục tiêu: mỗi liều, ngưỡng, mốc thời gian trong ca được đối chiếu với nguồn đọc được. Đây **không** phải bác sĩ duyệt: `status` vẫn là `draft`; chỉ bác sĩ mới được chuyển sang `reviewed`.

## Thang
- `da_doi_chieu`: mọi số kiểm được đều khớp nguồn hoặc đã sửa theo nguồn; không còn ý chưa đọc được; có ≥1 nguồn xác nhận.
- `mot_phan`: còn ý không đọc được nguồn (bị chặn, chỉ có tóm tắt).
- `can_xem_lai`: còn số nghi lệch, chưa tự quyết.
- `khong_co_so_lieu`: ca không có liều/ngưỡng.
- `chua_kiem`: chưa chạy (ca YHCT).

## Kết quả
{'nhat_quan': 118, 'khop': 147, 'lech': 47, 'khong_doi_chieu_duoc': 49, 'sai_co_y': 1} (tổng số ý đã kiểm). Chi tiết từng ý: `data/so-lieu-kiem.json`. Các sửa: `scripts/apply-so-lieu.mjs` (FIXES).

## Việc còn lại
- Ca `can_xem_lai` cần đọc nguyên văn văn bản (QĐ 3705, hướng dẫn bỏng ABA, GOLD/BTS, ATS/IDSA).
- Ca `mot_phan`: đọc lại khi có quyền truy cập nguồn (ESC 2023, ATLS, QĐ 708, NEJM).
- Ca YHCT: đối chiếu liều vị thuốc với Dược điển.
- Bác sĩ duyệt từng ca để chuyển `reviewed`.

Chạy lại: `node scripts/apply-so-lieu.mjs && node scripts/sync-case-bank.mjs`.
