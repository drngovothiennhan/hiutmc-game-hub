# Chuẩn hóa nguồn ngân hàng ca — đợt 1 (04/10/2026)

**Phạm vi:** 141 ca / 328 chuỗi nguồn; ưu tiên ca cấp cứu và hành động nguy cơ cao (chế độ `tay`).
**Phương pháp:** tra tự động PubMed (khớp tác giả/tạp chí/năm/tập/trang, hoặc tiêu đề) và văn bản pháp luật Bộ Y tế. Dữ liệu: `data/nguon-registry.json`; gắn vào ca bằng `node scripts/apply-source-registry.mjs`.
**Giới hạn:** chỉ xác nhận *nguồn có tồn tại và đúng định danh*, CHƯA đối chiếu từng đáp án với nội dung hướng dẫn và CHƯA có thẩm định bác sĩ. Mọi ca vẫn `draft`.

## Kết quả
| loại | số liên kết |
|---|---|
| chua_tra | 161 |
| pubmed | 99 |
| sach_giao_trinh | 44 |
| van_ban_byt | 43 |
| khong_dinh_danh | 26 |
| khong_xac_nhan | 2 |

- Ca có ≥1 nguồn xác nhận: **108/141**; riêng chế độ cấp cứu (`tay`): **73/105**.
- PubMed: 99 liên kết (PMID trong `nguon_kiem`). Văn bản BYT xác nhận tồn tại: 5331/QĐ-BYT (2020), 3610/QĐ-BYT (2015), TT 51/2017/TT-BYT, 5013/QĐ-BYT (2020), 3705/QĐ-BYT (2019), 5481/QĐ-BYT (2020), 708/QĐ-BYT (2015).

## Lỗi nguồn đã sửa / gắn cờ
1. **Bão giáp (`noi-noi-tiet-001`)** trích QĐ 3319/QĐ-BYT — thực chất là hướng dẫn *đái tháo đường típ 2* → đã gỡ.
2. **`ngoai-bung-002`**: tiêu đề Bologna ASBO sai ("Benchmarking…") → sửa theo PubMed (WJES 2018;13:24, PMID 29946347).
3. **10 ca cấp cứu** trích QĐ 5013/QĐ-BYT (khung YHCT kết hợp) → chuyển sang `nguon_yhct`, không còn nằm trong `nguon` của chế độ cấp cứu.
4. **Đã xác nhận là có thật** (từng nghi là ngày tương lai): AHA/ASA 2026 đột quỵ cấp (Stroke 2026, PMID 41582814); WSES 2025 viêm ruột thừa (JAMA Surg 2026, PMID 41604201). AHA/ASA 2026 có bài đề xuất đính chính (PMID 42535283) → theo dõi khi chốt đáp án.
5. **Chưa xác nhận được:** ESC HF 2026 (không thấy trên PubMed); QĐ 4132/QĐ-BYT viêm màng não mủ (ca `noi-nhiem-002`).
6. **Cần sửa tên:** ARDS 2024 — bank ghi "ATS, ESICM, SCCM", PubMed ghi hướng dẫn chính thức của ATS; ECC/ALS — bank không ghi năm (nay là AHA 2025, ERC 2025); WSES CRC emergencies ghi 2017, PubMed 2018.
7. **26 chuỗi "không định danh"** (vd. "số quyết định xem can_doi_chieu", "bản cập nhật hiện hành") — phải bổ sung số/năm trước khi VERIFIED.

## Việc còn lại (đợt 2)
- Ca cấp cứu chưa có nguồn xác nhận (32): hao-suyen, ha-duong-huyet-nang, noi-tieu-hoa-001, noi-tieu-hoa-003, noi-tieu-hoa-004, noi-tieu-hoa-006, noi-tieu-hoa-008, noi-tieu-hoa-009, noi-ho-hap-001, noi-ho-hap-002, noi-ho-hap-005, noi-than-001, noi-than-002, ngoai-bung-003, ngoai-bung-008, ngoai-chan-thuong-002, ngoai-chan-thuong-003, ngoai-chan-thuong-004, ngoai-chan-thuong-005, ngoai-chan-thuong-006, ngoai-tiet-nieu-001, ngoai-tiet-nieu-002, ngoai-tiet-nieu-003, ngoai-vu-001, ngoai-noi-tiet-001, noi-cap-cuu-005, noi-cap-cuu-104, ngoai-cap-cuu-001, ngoai-cap-cuu-002, ngoai-cap-cuu-004, ngoai-cap-cuu-005, ngoai-cap-cuu-106 — chủ yếu ATLS/GINA/NICE/KDIGO/EAU/QĐ BYT không số.
- 161 chuỗi `chua_tra` (NICE, WHO, GINA/GOLD, ATLS, KDIGO, EAU, QĐ BYT khác) cần tra link chính thức.
- Đối chiếu nội dung từng đáp án (ngưỡng, liều, thời gian) với nguồn đã xác nhận, rồi mới chuyển TECH PASS → MEDICAL REVIEW.
