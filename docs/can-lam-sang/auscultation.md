# Trạm Nghe tim & phổi 3D

- Giao diện: `public/can-lam-sang/auscultation.js`, trình xem WebGL không phụ thuộc thư viện `chest-viewer.js`.
- Backend: `supabase/proposed/can-lam-sang/017_cls_auscultation.sql` (rollback `018`). RPC: `cls_aus_start_v1`, `cls_aus_get_v1`, `cls_aus_submit_v1`. Cùng cổng `clinical_lab_room_v1` và nhãn CHƯA KIỂM DUYỆT như các trạm khác.
- Âm thanh: HLS-CMDS (Torabi, Shirani, Reilly, IEEE Data Descriptions, doi:10.1109/IEEEDATA.2025.3566012), CC BY 4.0, ghi từ mô hình lâm sàng bằng ống nghe điện tử. `scripts/can-lam-sang/build-auscultation-audio.py` chuẩn hoá âm lượng, nén MP3 và đặt tên file ngẫu nhiên.
- **Bảng id → nhãn là riêng tư**: nạp thẳng vào `can_lam_sang_private.aus_clips`, không commit vào repo công khai (`*.private.json` bị ignore).
- Mô hình 3D: BodyParts3D 4.0 (CC BY 4.0) qua Human Atlas; `scripts/can-lam-sang/build-chest-model.py`. Atlas không có mô phổi, chỉ có cây phế quản.

## Cần chuyên gia xác nhận trước khi dùng rộng
- Ý nghĩa mã vị trí của bộ dữ liệu: `RC`, `LC` (chưa dùng trong game) và các vùng phổi `RUA…LLA` (đang hiểu là vùng ngực trước: trên/giữa/dưới).
- Tại điểm không có bản ghi bất thường, game dùng bản ghi bình thường của điểm đó.
- Nhịp nhanh và block nhĩ thất là rối loạn nhịp, không phải một âm đơn lẻ.
- Vị trí 4 ổ van và 6 vùng phổi trên mô hình là minh hoạ học tập.
