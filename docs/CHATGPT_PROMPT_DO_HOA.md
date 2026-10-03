# Prompt nhờ ChatGPT mở rộng đồ họa Viện Thực Hành

Mục tiêu: từ hình bác sĩ và bệnh nhân hiện có, ChatGPT vẽ thêm nhiều góc nhìn, nhiều tư thế và vài khung chuyển động đơn giản của cùng một nhân vật để Claude ghép thành cảnh và mạch truyện trong game.

## Cách dùng (bạn làm 3 bước)
1. Mở https://chatgpt.com, bắt đầu một cuộc trò chuyện mới.
2. Đính kèm các ảnh trong tệp `do_hoa_hien_tai.zip` (giải nén ra: `bac_si_nam_chinh_dien.png`, `bac_si_nu_chinh_dien.png`, `benh_nhan_f3.png` đến `benh_nhan_f10.png`, `canh_giuong_b1.png` đến `b10.png`).
3. Sao chép TOÀN BỘ phần trong khung "PROMPT" bên dưới, dán vào ô chat, gửi. Làm từng gói một (Gói 1, rồi nhắn "làm tiếp Gói 2"...). Tải ảnh ChatGPT trả về, đặt tên đúng theo bảng, nén lại gửi cho Claude.

## PROMPT (sao chép từ dòng dưới đến hết khung)

```
Bạn là họa sĩ nhân vật 2D cho một game mô phỏng lâm sàng y khoa của Việt Nam (tên "Viện Thực Hành - TMC"). Tôi đính kèm hình hiện tại của bác sĩ nam, bác sĩ nữ, các bệnh nhân và cảnh giường bệnh. Hãy GIỮ NGUYÊN phong cách vẽ, bảng màu, nét viền, tỉ lệ đầu thân, gương mặt, kiểu tóc và trang phục của từng nhân vật trong ảnh đính kèm. Không đổi thiết kế nhân vật, không thêm logo hay chữ.

NHIỆM VỤ: vẽ thêm các góc nhìn và tư thế của CHÍNH các nhân vật đó để lập trình viên ghép thành cảnh và hoạt cảnh đơn giản.

YÊU CẦU CHUNG
- Nền trong suốt (PNG, alpha). Nếu không xuất được nền trong suốt thì dùng nền xanh lá thuần #00FF00 phẳng, không đổ bóng lên nền.
- Mỗi nhân vật cao đúng 440 px (bác sĩ) hoặc 360 px (bệnh nhân), chân chạm cùng một đường nền ở mọi khung. Cùng một đầu, cùng độ rộng vai ở các tư thế đứng.
- Ánh sáng từ trên trái, bóng đổ nhẹ giống ảnh gốc. Không phông nền, không đồ vật dư thừa trừ khi tôi yêu cầu.
- Mỗi tệp là một lưới (sprite sheet) các khung cách đều nhau, mỗi ô cùng kích thước, ghi rõ số ô. Không để nhân vật chạm mép ô.
- Trang phục y khoa phải đúng: bác sĩ mặc blouse trắng, đeo ống nghe, thẻ tên trống (không chữ). Bệnh nhân mặc đồ bệnh nhân như ảnh gốc.
- Chỉ vẽ động tác đơn giản, an toàn, mang tính giáo dục. Không máu me, không cảnh phản cảm.

GÓI 1: BÁC SĨ NAM VÀ BÁC SĨ NỮ (làm riêng từng người, cùng bố cục)
Tệp "bacsi_<nam|nu>_goc.png": 8 ô, mỗi ô đứng thả tay tự nhiên, theo thứ tự: chính diện, 3/4 trái, ngang trái, 3/4 sau trái, sau lưng, 3/4 sau phải, ngang phải, 3/4 phải.
Tệp "bacsi_<nam|nu>_bieucam.png": 6 ô nửa người trên chính diện: bình thường, chăm chú nghe, lo lắng, nghiêm túc ra quyết định, mỉm cười trấn an, mệt mỏi (trực đêm).
Tệp "bacsi_<nam|nu>_dongtac.png": 12 ô, mỗi ô một tư thế đứng, nhìn 3/4 phải:
 1 cầm bệnh án, 2 viết bệnh án, 3 nghe tim phổi bằng ống nghe (người bệnh ở phía trước, không vẽ người bệnh), 4 đo huyết áp (giơ tay như đang bơm), 5 sờ bắt mạch (hai ngón tay), 6 khám bụng (hai tay đặt phía trước), 7 chỉ tay ra hiệu, 8 gọi điện thoại, 9 nhìn đồng hồ đeo tay, 10 ép tim ngoài lồng ngực (hai tay thẳng, nhìn từ bên), 11 chỉ định xét nghiệm (cầm phiếu), 12 bắt tay hoặc gật đầu chào.
Tệp "bacsi_<nam|nu>_di.png": 8 ô chu kỳ đi bộ ngang phải (vòng lặp liền mạch), và "bacsi_<nam|nu>_chay.png": 6 ô chu kỳ chạy gấp ngang phải (vòng lặp liền mạch).
Tệp "bacsi_<nam|nu>_nghi.png": 4 ô chu kỳ đứng thở nhẹ (vòng lặp liền mạch, chuyển động rất nhỏ).

GÓI 2: BỆNH NHÂN (làm cho từng bệnh nhân f3 đến f10, hoặc chọn 4 người đại diện nếu quá nhiều: nam trẻ, nữ trẻ, nam lớn tuổi, nữ lớn tuổi)
Tệp "benhnhan_<tên>_goc.png": 8 góc đứng như bác sĩ.
Tệp "benhnhan_<tên>_trangthai.png": 10 ô nửa người trên chính diện: bình thường, đau (nhăn mặt), đau ngực (tay đặt lên ngực), khó thở (há miệng, vai nhô), vã mồ hôi và tái, li bì (mắt lim dim), hôn mê (nhắm mắt), sợ hãi, nhẹ nhõm, mỉm cười cảm ơn.
Tệp "benhnhan_<tên>_tuthe.png": 10 ô toàn thân: đứng, ngồi trên ghế, ngồi trên giường, nằm ngửa trên giường (nhìn từ bên), nằm nghiêng, nằm đầu cao 30 độ, ôm bụng cúi người, được dìu bởi một cánh tay, ngồi xe lăn, đứng chống gậy.
Tệp "benhnhan_<tên>_di.png": 8 ô chu kỳ đi chậm, và 4 ô chu kỳ đi khập khiễng.

GÓI 3: CẢNH VÀ ĐẠO CỤ (kiểu cắt rời để ghép lớp)
Vẽ các vật riêng lẻ, nền trong suốt, góc nhìn ngang (như ảnh cảnh giường b1 đến b10): giường bệnh (nhìn ngang, hai mức đầu giường), xe đẩy cấp cứu, màn hình monitor, giá treo dịch truyền, máy thở, máy sốc điện, bàn khám, ghế khám, bàn làm việc với máy tính, xe lăn, cáng, tủ thuốc, đèn khám, rèm ngăn, cửa phòng, cửa sổ ban ngày và ban đêm, đồng hồ treo tường. Mỗi vật một tệp riêng "vat_<tên>.png" và một tệp lưới tổng hợp "vat_tong_hop.png".

GÓI 4: KHUNG MINH HỌA CÂU CHUYỆN (6 tranh ngang, tỉ lệ 16:9, cùng phong cách ảnh cảnh giường hiện có)
Mỗi tranh có bác sĩ và bệnh nhân, dùng để mở đầu ca: 1 bệnh nhân vào phòng cấp cứu được dìu, 2 bác sĩ hỏi bệnh bên giường, 3 bác sĩ khám bụng, 4 bác sĩ xem phim và kết quả xét nghiệm trên màn hình, 5 cả nhóm cấp cứu quanh giường (hai điều dưỡng chỉ vẽ dáng, không cần gương mặt rõ), 6 bác sĩ bàn giao ca cho đồng nghiệp lúc sáng sớm.

ĐẶT TÊN VÀ GIAO NỘP
- Dùng đúng tên tệp ở trên (chữ thường, không dấu, gạch dưới).
- Với mỗi tệp sprite sheet, ghi ở đầu câu trả lời: số cột, số hàng, kích thước mỗi ô (px), thứ tự ô từ trái sang phải, trên xuống dưới.
- Trước khi vẽ mỗi gói, tóm tắt trong 3 dòng những đặc điểm nhân vật bạn sẽ giữ nguyên (màu tóc, màu áo, phụ kiện) để tôi xác nhận. Sau đó vẽ.
- Nếu một tư thế khó vẽ nhất quán, nói rõ và đề xuất cách đơn giản hơn thay vì vẽ sai nhân vật.
```

## Claude sẽ làm gì với các tệp bạn gửi lại
1. Cắt từng ô thành khung riêng, canh chân về cùng một đường nền, nén WebP nhẹ (mỗi nhân vật dưới khoảng 150 KB mỗi bộ).
2. Thêm vào Viện Thực Hành: bác sĩ đi vào phòng, đứng khám đúng tư thế theo thao tác người chơi (nghe tim phổi khi bấm khám tim, ép tim khi chọn hồi sinh, viết bệnh án khi mở bệnh án), bệnh nhân đổi nét mặt và tư thế theo độ ổn định (khó thở, vã mồ hôi, li bì), tranh minh họa đầu ca.
3. Chỉ dùng nhân vật do bạn tạo hoặc đã có sẵn trong game. Không dùng ảnh người thật.

## Lưu ý
- Hãy kiểm tra từng gói ChatGPT trả về: nếu gương mặt hay trang phục lệch so với bản gốc, nhắn "vẽ lại, giữ đúng thiết kế ảnh gốc" thay vì chấp nhận.
- ChatGPT thường lệch kích thước ô; Claude sẽ tự canh lại, bạn không cần chỉnh.
