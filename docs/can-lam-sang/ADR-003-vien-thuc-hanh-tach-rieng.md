# ADR-003: Viện Thực Hành là một phần của HIU TMC, không thuộc GameHub

Trạng thái: **Đề xuất** — chờ chủ sở hữu chọn cách tách (xem mục "Cần quyết định").

## Bối cảnh
- Viện Thực Hành gồm học lâm sàng, học cận lâm sàng và trực bệnh viện. Đây là một phần của HIU TMC.
- Hiện mã của Phòng Cận Lâm Sàng đang nằm trong repo `hiutmc-game-hub`, nên người đọc dễ hiểu nhầm là thuộc GameHub.
- Viện có thể được phát triển thành ứng dụng riêng trong tương lai.

## Quyết định
1. Viện Thực Hành là một khối riêng của HIU TMC, ngang hàng với GameHub, không nằm trong GameHub.
2. Bên trong Viện, các khu (Phòng Cận Lâm Sàng, học lâm sàng, trực) được phân tách để có thể nâng cấp độc lập. Các khu không chia sẻ mã giao diện ngoài CSS chung.
3. Nội dung chưa có xác nhận chuyên gia hoặc chưa có nguồn gốc rõ ràng được ghi là **nội dung do AI mô phỏng, chỉ có giá trị tham khảo thực hành**.
   - Mỗi ca có ký hiệu **AI** nhỏ ở góc thẻ.
   - Phần giải thích đầy đủ nằm trong khối "Thông tin về nội dung AI" trên trang chủ phòng, không đặt trên từng ca.

## Hệ quả
- Trạng thái hiện tại vẫn chạy trên hosting của GameHub; việc tách hosting chưa làm.
- Mỗi khu có file riêng: `core.js` (Luyện ca bệnh), `cbc.js` (Đọc xét nghiệm máu), `auscultation.js` (Nghe tim phổi 3D). Chỉ `index.html` và `bootstrap.js` là điểm chung.

## Cần quyết định (chủ sở hữu)
- Cách tách: (a) repo mới `vien-thuc-hanh` và Cloudflare Pages riêng; hoặc (b) giữ trong repo hiện tại, chỉ đổi thư mục và đường dẫn. Đề xuất: (a).
- Nếu chọn (a), chủ sở hữu cần tạo repo trống trên GitHub. Tôi không có quyền tạo repo mới trong phiên này.
