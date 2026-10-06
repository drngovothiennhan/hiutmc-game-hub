# Clinical review flags — Phòng Cận Lâm Sàng

Mục đích: danh sách chỉ để người duyệt chuyên môn xem lại. Đây **không phải** danh sách chặn adapter và không tự sửa nội dung lâm sàng.

Luật ghi nhận: lựa chọn điều trị thuộc `phap`, `phuong`, `huyet` có nội dung trùng với chuỗi công khai. Tên huyệt/vùng giải phẫu trong bệnh sử hoặc khám có thể là dữ kiện lâm sàng hợp lệ.

| case_id | trường | lựa chọn trùng | đoạn trích |
|---|---|---|---|
| `kham-dau-nua-dau-can-duong` | `history[0].response` | Thái dương | Đau nửa đầu bên phải, thường từ thái dương lan ra sau mắt, đau theo nhịp mạch đập. Mỗi cơn 6 đến 24 giờ, 2 đến 3 cơn mỗi tháng. |
| `kham-dau-nua-dau-can-duong` | `examination[4].finding` | Thái dương | Ấn đau vùng thái dương phải và cơ thang hai bên. Không cứng gáy. |
| `kham-dau-nua-dau-can-duong` | `examination[8].finding` | Thái dương | Không đau vùng xoang, khớp thái dương hàm không đau. |
| `dau-nua-dau-can-duong-thuong-cang` | `history[0].response` | Thái dương | Đau nhói, giật theo nhịp mạch ở thái dương và hốc mắt một bên, thường bên trái, đôi khi đổi bên. |
| `dau-nua-dau-can-duong-thuong-cang` | `examination[4].finding` | Phong trì | Cơ thái dương, cơ chẩm trái co cứng, ấn đau điểm Phong trì và Thái dương. |
| `dau-nua-dau-can-duong-thuong-cang` | `examination[4].finding` | Thái dương | Cơ thái dương, cơ chẩm trái co cứng, ấn đau điểm Phong trì và Thái dương. |
| `yhct-kham-108` | `examination[4].finding` | Phong trì | Co cứng cơ thang và nâng vai phải, điểm đau Kiên tỉnh và Phong trì, xoay cổ phải khoảng 50 độ, xoay trái 75 độ, gập duỗi hạn chế nhẹ. |
| `yhct-kham-108` | `examination[4].finding` | Kiên tỉnh | Co cứng cơ thang và nâng vai phải, điểm đau Kiên tỉnh và Phong trì, xoay cổ phải khoảng 50 độ, xoay trái 75 độ, gập duỗi hạn chế nhẹ. |

## Cảnh báo bỏ dấu — không chặn

- `kham-thong-kinh-khi-tre-huyet-u`, `examination[1].finding`: “Chất lưỡi tím tối, có điểm ứ huyết hai bên rìa, rêu trắng mỏng.” từng bị so khớp bỏ dấu với lựa chọn “Huyết hải”. Theo D1 đây chỉ là cảnh báo, không phải vi phạm.
