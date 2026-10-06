# Đề xuất thiết kế Bước 2a-0 — Module Công thức máu (CBC)

- Trạng thái: **ĐỀ XUẤT — CHƯA ĐƯỢC DUYỆT**
- Ngày: 2026-10-06
- Phạm vi: thiết kế tài liệu; **không code, không SQL, không phát hành**
- Route dự kiến: `/can-lam-sang/`; module CBC lazy-load sau khi server xác nhận `clinical_lab_room_v1=true`.
- Mục đích: đào tạo sinh viên; **không dùng để chẩn đoán hay quyết định điều trị người bệnh thật**.
- Quy tắc nguồn: số liệu bệnh lý/reference range chỉ được đưa vào dữ liệu thực thi sau khi có `resource_id`, nguồn truy xuất được và trạng thái `ĐÃ DUYỆT` do người kiểm định chuyên môn xác nhận.

## D1. Phạm vi

### Đối tượng

Giai đoạn này chỉ **người lớn**. Không bao gồm trẻ em; không xây reference range nhi khoa trong Bước 2a.

Để tránh trộn quần thể, thiết kế cũng **không mặc định áp dụng cho thai kỳ**. Nếu sau này mở rộng thai kỳ phải có population/reference riêng và được duyệt riêng.

### Chỉ số

| Nhóm | Chỉ số | Đơn vị hiển thị đề xuất |
|---|---|---|
| Hồng cầu | RBC | ×10^12/L |
| Hồng cầu | Hb | g/dL |
| Hồng cầu | Hct | % |
| Chỉ số hồng cầu | MCV | fL |
| Chỉ số hồng cầu | MCH | pg |
| Chỉ số hồng cầu | MCHC | g/dL |
| Bạch cầu | WBC | ×10^9/L |
| Công thức BC | neut, lymph, mono, eos, baso | % + số lượng tuyệt đối |
| Tiểu cầu | PLT | ×10^9/L |

CBC/differential đo RBC, Hb, Hct, WBC, platelets và các loại bạch cầu; MCV/MCH/MCHC là các chỉ số hồng cầu. MedlinePlus và Merck mô tả cùng nhóm chỉ số này.  
Nguồn: MedlinePlus, *CBC blood test* (Review Date 10/14/2024), https://medlineplus.gov/ency/article/003642.htm ; Merck Manual, *Complete Blood Count (CBC)*, truy xuất 2026-10-06.

## D2. Thư viện mẫu bệnh cảnh (pattern)

### Schema đề xuất

Mỗi pattern:

```text
pattern_id
name
population
indices:
  RBC: {low, normal, high, unit, source_resource_id}
  Hb:  {low, normal, high, unit, source_resource_id}
  Hct: {low, normal, high, unit, source_resource_id}
  MCV: ...
  MCH: ...
  MCHC: ...
  WBC: ...
  neut: {percent_range, absolute_range, unit, source_resource_id}
  lymph: ...
  mono: ...
  eos: ...
  baso: ...
  PLT: ...
reference_notes
review_status
```

Mọi pattern mặc định `CHUA_DUYET`. Không coi pattern có nguồn là đã được duyệt.

### Nguồn R1–R6 và đối chiếu số liệu

| Mã | Nguồn | Nơi chứa số liệu | Ngày truy xuất |
|---|---|---|---|
| R1 | MedlinePlus, CBC blood test | “Normal Results” | 2026-10-06 |
| R2 | MedlinePlus, Blood differential test | “Normal Results” | 2026-10-06 |
| R3 | WHO 2024, Guideline on haemoglobin cutoffs | **CHƯA MỞ PDF**; chưa xác định trang/bảng | 2026-10-06 |
| R4 | MedlinePlus, RBC indices | **CHƯA MỞ** | 2026-10-06 |
| R5 | Merck Manual, Evaluation of anemia | **CHƯA MỞ** | 2026-10-06 |
| R6 | Merck Manual, Complete Blood Count (CBC) | **CHƯA MỞ** | 2026-10-06 |

### Nguồn đã truy xuất ngày 2026-10-06

**R1 — MedlinePlus, National Library of Medicine/NIH, “CBC blood test”.**  
- Ngày truy xuất: 2026-10-06.  
- Ngày cập nhật/review trên trang: **10/14/2024**.  
- Nơi chứa số liệu: mục **“Normal Results”**, các dòng RBC/WBC/Hematocrit/Hemoglobin/Red blood cell indices/Platelet count.  
- Ghi chú đơn vị PLT: trang gốc hiển thị `150,000 to 400,000/dL`; đây là lỗi đơn vị hiển thị của trang gốc. Module dùng **×10^9/L (150–400 ×10^9/L)**, KHÔNG chép `/dL`.  
https://medlineplus.gov/ency/article/003642.htm

Trang này công bố các khoảng tham khảo chung:
- RBC: nam 4.6–6.2 million cells/mcL; nữ 4.2–5.4 million cells/mcL.
- WBC: 4,500–11,000 cells/mcL.
- Hct: nam 40–55%; nữ 36–48%.
- Hb: nam 13–18 g/dL; nữ 12–16 g/dL.
- MCV 80–100 fL.
- MCH 27–32 pg/cell.
- MCHC 32–36 g/dL.
- PLT 150,000–400,000/dL.

MedlinePlus cảnh báo reference range có thể thay đổi giữa các labo. Vì vậy các khoảng trên chỉ là **nguồn tham khảo**, không tự biến thành khoảng chuẩn của module.

**R2 — MedlinePlus, “Blood differential test”.**  
- Ngày truy xuất: 2026-10-06.  
- Ngày review trên trang: **2/3/2025**.  
- Nơi chứa số liệu: mục **“Normal Results”** (Neutrophils, Lymphocytes, Monocytes, Eosinophils, Basophils).  
https://medlineplus.gov/ency/article/003657.htm

Khoảng tỷ lệ tham khảo được trang này nêu:
- neutrophils 40–60%
- lymphocytes 20–40%
- monocytes 2–8%
- eosinophils 1–4%
- basophils 0.5–1%

Trang này cũng nêu tổng WBC và differential phải được đọc cùng nhau; tỷ lệ một dòng tăng có thể làm tỷ lệ dòng khác giảm.

**R3 — WHO, “Guideline on haemoglobin cutoffs to define anaemia in individuals and populations”.**  
- Ngày truy xuất: 2026-10-06.  
- Nơi chứa số liệu: **CHƯA MỞ được PDF**; trang gốc chỉ hiển thị metadata và liên kết tải PDF. PDF trả lỗi 403 trong môi trường kiểm tra.  
- Vì vậy: **CHƯA XÁC MINH — cần đối chiếu PDF trang ? / bảng ? trước khi dùng bất kỳ ngưỡng Hb số nào.**  
https://www.who.int/publications/i/item/9789240088542

WHO 2024 là nguồn ưu tiên cho ngưỡng Hb xác định thiếu máu. **Không ghi ngưỡng số trong tài liệu/runtime ở bước này** vì PDF chưa đối chiếu được. Các quần thể đặc biệt cần reference riêng.

### Tối đa 8 pattern khởi đầu

| pattern_id | Mẫu | Số liệu đề xuất ở thời điểm này | Nguồn/ghi chú |
|---|---|---|---|
| CBC-P01 | Bình thường người lớn | **Có thể dựng bản nháp** từ R1/R2; mọi field số phải lưu resource_id | R1/R2; CHUA_DUYET |
| CBC-P02 | Thiếu máu thiếu sắt | **CHƯA CÓ NGUỒN cho toàn bộ vector CBC định lượng** → để trống số | R3 chỉ hỗ trợ Hb; không tự suy ra toàn bộ vector |
| CBC-P03 | Thiếu máu hồng cầu to | **CHƯA CÓ NGUỒN** cho vector CBC đầy đủ → để trống | Không tự điền MCV/Hb/RBC từ trí nhớ |
| CBC-P04 | Thiếu máu bệnh mạn tính | **CHƯA CÓ NGUỒN** cho vector CBC đầy đủ → để trống | Không tự suy diễn |
| CBC-P05 | Nhiễm khuẩn / neutrophilia | **CHƯA CÓ NGUỒN** cho ngưỡng pattern định lượng đã chọn → để trống | R2 mô tả tăng neutrophil trong nhiễm khuẩn nhưng không cung cấp một vector game chuẩn |
| CBC-P06 | Nhiễm virus / lymphocytosis | **CHƯA CÓ NGUỒN** cho vector định lượng → để trống | R2 mô tả liên quan nhưng không dùng làm ngưỡng |
| CBC-P07 | Giảm tiểu cầu | **CHƯA CÓ NGUỒN** cho ngưỡng pattern định lượng theo policy của module → để trống | R1 có khoảng tham khảo PLT, nhưng chưa đủ để tự định nghĩa severity/pattern |
| CBC-P08 | Leukopenia | **CHƯA CÓ NGUỒN** cho vector pattern định lượng hoàn chỉnh → để trống | R1/R2 có reference WBC; chưa tự tạo pattern bệnh lý |

**Quy tắc quan trọng:** không có nguồn định lượng trực tiếp thì trường số để `null`/chưa cấu hình, pattern không được dùng để sinh ca. Không được lấy con số từ trí nhớ hoặc ghép nhiều nguồn để tạo một khoảng mới mà chưa có người kiểm định.

### Lựa chọn kiến trúc thư viện pattern

**Phương án A — pattern là vector reference/range tĩnh.**
- Ưu: dễ audit, deterministic, dễ version.
- Nhược: khó biểu diễn các pattern chồng lấp.
- **Đề xuất:** chọn A cho Bước 2a.

**Phương án B — pattern là rule engine (quan hệ giữa chỉ số).**
- Ưu: biểu diễn tốt các pattern phức tạp.
- Nhược: tăng nguy cơ sinh số không hợp lý và khó audit nguồn.

**Phương án C — lưu nhiều “prototype” cho một pattern.**
- Ưu: tạo được nhiều ca khác nhau.
- Nhược: nhiều số phải được review; tăng khối lượng thẩm định.

Khuyến nghị: **A ở foundation**, sau khi có dữ liệu đã duyệt mới cân nhắc C.

## D3. Liên kết với ca bệnh

Không được suy từ `title/name/diagnosis` của ca cũ để tự gắn CBC.

### Bảng ánh xạ đề xuất

```text
case_cbc_mapping
- case_id
- pattern_id
- mapping_version
- resource_id / evidence_resource_id
- reviewer
- review_status
- reviewed_at
- review_note
```

Chỉ mapping có `review_status=DA_DUYET` mới được phép chạy trong chế độ **trong ca**.

### Bản nháp cho người kiểm định

Adapter/utility có thể xuất danh sách:

```text
case_id | gợi ý_pattern_id | lý do_gợi_ý | nguồn_gợi_ý | review_status=CHUA_DUYET
```

Danh sách này chỉ là **gợi ý để người kiểm định duyệt**, không tự áp vào runtime.

Nếu ca không có mapping đã duyệt:
> **“Ca này chưa có CBC.”**

Không sinh CBC giả cho ca thiếu mapping.

## D4. Sinh giá trị xác định

### Seed

Module sử dụng:

```text
seed = hash(case_id + "cbc" + schema_version)
```

Dùng `seeded-rng.mjs`; cấm `Math.random()`, cấm `ORDER BY random()`.

### Quan hệ nội tại bắt buộc

Các quan hệ này là **bất biến tính toán**, không phải reference range bệnh lý:

```text
MCH  ≈ Hb / RBC × 10
MCHC ≈ Hb / Hct × 100
Hct  ≈ RBC × MCV / 10
sum(neut, lymph, mono, eos, baso) = 100%
absolute_count = WBC × percentage / 100
```

Các chỉ số CBC và ý nghĩa của MCV/MCH/MCHC được mô tả bởi MedlinePlus/Merck; trong module, các công thức trên phải được coi là invariant kiểm thử và phải được người kiểm định chuyên môn duyệt trước khi thành contract runtime.  
Nguồn nền: MedlinePlus RBC indices, https://medlineplus.gov/ency/article/003648.htm ; Merck Manual, *Evaluation of anemia*, truy xuất 2026-10-06.

### Dung sai đề xuất

- Lưu giá trị nội bộ ở một hệ đơn vị cố định; chuyển đổi khi hiển thị theo cấu hình reference.
- Không dùng dung sai `0.5%` cố định.
- Dung sai của từng quan hệ được tính bằng **interval arithmetic**, từ tổng sai số làm tròn tối đa của các đại lượng tham gia ở độ chính xác hiển thị.
- UI đề xuất:
  - RBC: 2 chữ số thập phân
  - Hb: 1 chữ số thập phân
  - Hct: 1 chữ số thập phân
  - MCV/MCH/MCHC: 1 chữ số thập phân
  - WBC/PLT và absolute differential: 2 chữ số thập phân hoặc theo đơn vị được người kiểm định chọn.
- Cách làm tròn cuối cùng phải được reviewer duyệt cùng reference/labo mục tiêu.

## D5. Người học trả lời và chấm

### Luồng trả lời

Người học:
1. xem CBC;
2. đánh dấu từng chỉ số: **thấp / bình thường / cao**;
3. chọn nhận định mẫu bệnh cảnh;
4. có thể nhập ghi chú tự do;
5. submit.

Ghi chú tự do **không chấm bằng AI** ở Bước 2a.

### Rubric

Rubric thuộc từng pattern:

```text
pattern_id
required_classifications[]
accepted_interpretations[]
score_rules[]
explanation
```

Không gửi rubric/answer key xuống browser trước submit.

### Tách reveal CBC khỏi core

**Không dùng reveal cấp ca của `core`.**

Đề xuất RPC:

```text
cls_cbc_flag_status_v1()
cls_cbc_get_case_v1(p_case_id)
cls_cbc_start_practice_v1(p_level)
cls_cbc_submit_v1(p_attempt_id, p_answers)
```

Tất cả dùng khung:

```json
{"ok":true,"code":null,"data":{}}
```

hoặc lỗi nghiệp vụ tương ứng.

### Hai hướng lưu attempt

**Phương án A — bảng CBC attempts riêng.**
- Ưu: tách biệt module, audit dễ.
- Nhược: thêm bảng.
- **Đề xuất:** A.

**Phương án B — dùng chung submissions với module='cbc'.**
- Ưu: ít bảng.
- Nhược: dễ trộn contract core/CBC; khó enforce rubric riêng.
- Không khuyến nghị ở Bước 2a.

**Phương án C — không lưu attempt, chấm stateless.**
- Ưu: đơn giản.
- Nhược: mất history/audit.
- Không phù hợp yêu cầu học tập có truy vết.

## D6. Chế độ

### (a) Luyện riêng

- Người học **không chọn pattern** vì chọn pattern sẽ lộ đáp án.
- Người học chỉ chọn `level` (`co_ban,...`).
- Server tự giao pattern đã `DA_DUYET` và variant; giữ kín pattern đến khi nộp.
- Danh sách lựa chọn “nhận định” là danh sách cố định cho cả level, không mã hóa pattern trong lựa chọn.
- Không phụ thuộc ca cũ; không AI.

### Attempt và giới hạn

- Trạng thái: `started → submitted`.
- Attempt thuộc `auth.uid()`; mọi đọc/submit phải kiểm tra quyền sở hữu.
- Nộp lặp lại cùng attempt phải **idempotent**, trả lại cùng kết quả.
- **Đề xuất để kiến trúc sư duyệt:** tối đa **3 attempt `started` đồng thời / user** và tối đa **10 attempt mới / user / UTC day**. Chưa được coi là đã duyệt. Khi đạt giới hạn, server trả mã nghiệp vụ và không tạo attempt mới.
- `variant` được server xác định từ user + số lần luyện, không nhận tùy ý từ client.

### (b) Trong ca

- Nhận `case_id`.
- Server tìm mapping `case_id → pattern_id`.
- Chỉ mapping `DA_DUYET` mới chạy.
- Không có mapping → “Ca này chưa có CBC.”

### Dùng chung code

Cả hai đi qua một generator:

```text
resolveCbcScenario({
  mode: "practice" | "case",
  pattern_id?,
  case_id?
})
        ↓
validated pattern
        ↓
seed(case_id|practice-id + "cbc" + schema_version)
        ↓
deterministic CBC vector
        ↓
contract validation
```

Không copy riêng hai generator.

## D7. Giao diện

### Mobile-first

1. **Bootstrap**
   - chỉ tải HTML/CSS tối thiểu;
   - gọi `cls_flag_status_v1`;
   - nếu cờ tắt: hiển thị “Phòng Cận Lâm Sàng chưa mở”.
2. **Nếu cờ bật**
   - mới dynamic-import CBC module;
   - không tải ECG/X-quang/nghe tim-phổi.
3. **Chọn chế độ**
   - Luyện riêng / Trong ca.
4. **CBC viewer**
   - bảng chỉ số;
   - đơn vị;
   - trạng thái thấp/bình thường/cao do người học tự đánh dấu.
5. **Trả lời**
   - nhận định + ghi chú.
6. **Nộp**
   - POST/RPC server-side.
7. **Sau nộp**
   - server trả rubric, điểm, giải thích và nguồn được phép reveal.
8. **Debrief**
   - hiển thị trạng thái nguồn.

Mỗi learner screen phải có nhắc:

> **Chỉ dùng cho học tập, mô phỏng; không dùng để chẩn đoán hoặc quyết định điều trị người bệnh thật.**

### CHƯA DUYỆT

Pattern/resource chưa được chuyên môn duyệt phải có nhãn rõ:

> **CHƯA DUYỆT — dùng để review nội bộ, chưa dùng cho học viên.**

Pattern `DA_DUYET` chỉ được hiện cho learner.

## D8. Bảo vệ hệ thống cũ

### File dự kiến ở bước implementation

```text
public/can-lam-sang/modules/cbc.js
src/can-lam-sang/cbc/
  generator.mjs
  validator.mjs
  rubric.mjs
schemas/can-lam-sang/cbc-*.schema.json
test/can-lam-sang/cbc.contract.test.js
docs/can-lam-sang/design/2a-cbc-proposal.md
```

Có thể cần bảng/RPC riêng ở Bước 2, nhưng **chưa viết SQL** trong Bước 2a-0.

Cam kết:
- 0 file legacy bị sửa.
- Không sửa `app.js`.
- Không sửa `public/vien-thuc-hanh/index.html`.
- Không sửa `service-worker.js`.
- Không đưa module CBC vào bundle/runtime trước khi được bật.

### Test kế hoạch

1. Contract schema.
2. Pattern/resource approval gate.
3. Quan hệ MCH/MCHC/Hct.
4. Differential = 100%.
5. Absolute differential khớp WBC.
6. Golden test cùng seed → cùng vector.
7. Không có `Math.random`.
8. Không có `ORDER BY random()`.
9. Không mapping → “ca này chưa có CBC”.
10. Network test: trước submit không có answer/rubric/explanation.
11. Sau submit mới có CBC-specific reveal.
12. Feature flag OFF → không dynamic-import CBC.
13. AI disabled → CBC vẫn chạy.

## D9. Việc cần người kiểm định chuyên môn

Checklist bắt buộc:

- [ ] Xác nhận quần thể người lớn áp dụng.
- [ ] Xác nhận có/không tách nam/nữ cho từng reference.
- [ ] Xác nhận có loại trừ thai kỳ hay cần pattern riêng.
- [ ] Duyệt resource_id cho từng reference range.
- [ ] Duyệt đơn vị hiển thị và đơn vị nội bộ.
- [ ] Duyệt 8 pattern khởi đầu và tên pattern.
- [ ] Duyệt vector số liệu của từng pattern; số nào chưa có nguồn phải giữ trống.
- [ ] Duyệt quan hệ nội tại và cách làm tròn.
- [ ] Duyệt ngưỡng phân loại thấp/bình thường/cao.
- [ ] Duyệt mapping từng case_id → pattern_id.
- [ ] Duyệt rubric và đáp án CBC.
- [ ] Duyệt explanation sau submit.
- [ ] Duyệt resource/license/reviewer/check date.
- [ ] Xác nhận tất cả nội dung là synthetic/anonymized.
- [ ] Xác nhận nhãn CHUA_DUYET/DA_DUYET.
- [ ] Kiểm tra không có chẩn đoán được suy ngược từ CBC nếu chưa đủ bằng chứng.

### CHƯA BIẾT

- Reference range mục tiêu của labo Việt Nam nào sẽ được chọn làm chuẩn chính.
- Có cần tách reference theo giới/tuổi cao tuổi hay không.
- Bộ số liệu bệnh lý định lượng đủ để tạo 7 pattern bệnh lý còn lại.
- Reviewer chuyên môn cụ thể.
- License của từng nguồn sẽ được duyệt cho nội dung runtime.
- Có cần thêm RDW/MPV hay không; hiện **không thêm**, vì D1 đã chốt danh sách chỉ số.

## D10. Câu hỏi cần kiến trúc sư quyết định

### Q1 — Reference range chính

**A.** Một nguồn chuẩn chung do người kiểm định chọn.  
Ưu: deterministic, dễ audit. Nhược: có thể khác labo thực tế.  
**Đã quyết định: A.** Trước khi chọn nguồn chuẩn, R1/R2 chỉ là `dev-reference`, không đưa vào learner.

**B.** Reference theo từng labo.  
Ưu: sát thực tế. Nhược: nhiều version và mapping.

**C.** Nhiều nguồn, pattern ghi rõ nguồn.  
Ưu: linh hoạt. Nhược: khó thống nhất chấm.

### Q2 — Pattern bệnh lý chưa có vector nguồn

**A.** Chỉ đưa pattern vào đường người học khi `review_status=DA_DUYET`. Cộng thêm fixture riêng cho test, không thuộc enum learner.  
**Đã quyết định: A.**

**B.** Cho phép pattern CHUA_DUYET chạy nội bộ reviewer.  
Ưu: phát triển nhanh. Nhược: nguy cơ lọt learner nếu gate lỗi.

### Q3 — Mapping case → CBC

**A.** Chỉ mapping thủ công được người kiểm định duyệt. **Đã quyết định: A.**  
**B.** AI/gợi ý tự động rồi tự áp. Không đề xuất ở giai đoạn này.  
**C.** Tự suy từ diagnosis. **Cấm** theo yêu cầu.

### Q4 — Precision UI

**A.** Theo reference labo được chọn. **Đề xuất.**  
**B.** Precision cố định toàn module.  
**C.** Cho reviewer cấu hình từng chỉ số.

### Q5 — Practice seed

**A.** `seed = hash(pattern_id + "cbc" + schema_version + variant)`. `variant` do server chọn xác định theo `(user_id, số_lần_luyện)`.  
**Đã quyết định: A có variant.** Pattern không được lộ trước submit.

## Kết luận đề xuất

Bước 2a-0 chỉ chốt **contract và thiết kế**, chưa tạo số bệnh lý mới chưa có nguồn, chưa mapping tự động, chưa SQL và chưa runtime.

Nguồn nền đã truy xuất ngày 2026-10-06:
1. WHO — *Guideline on haemoglobin cutoffs to define anaemia in individuals and populations*, 2024. https://www.who.int/publications/i/item/9789240088542
2. MedlinePlus/NLM — *CBC blood test*. https://medlineplus.gov/ency/article/003642.htm
3. MedlinePlus/NLM — *Blood differential test*. https://medlineplus.gov/ency/article/003657.htm
4. MedlinePlus/NLM — *RBC indices*. https://www.medlineplus.gov/ency/article/003648.htm
5. Merck Manual — *Evaluation of anemia*. https://www.merckmanuals.com/en-ca/professional/hematology/approach-to-the-patient-with-anemia/evaluation-of-anemia
6. Merck Manual — *Complete Blood Count (CBC)*. https://www.merckmanuals.com/en-ca/home/multimedia/table/complete-blood-count-cbc

Tất cả pattern và dữ liệu số trong thiết kế này mặc định **CHUA_DUYET**; các số bệnh lý chưa có nguồn trực tiếp được để trống, không suy diễn.


## QUYẾT ĐỊNH KIẾN TRÚC SƯ 2a-0

Ngày quyết định: 2026-10-06.

### D10 đã quyết định
- Q1 = **A**: một nguồn chuẩn chung do người kiểm định chọn. Trước khi chọn, R1/R2 chỉ dùng cho phát triển với nhãn `dev-reference`, không đưa vào nội dung người học.
- Q2 = **A**: đường người học chỉ dùng pattern `DA_DUYET`; fixture test tách riêng.
- Q3 = **A**: mapping `case_id → pattern_id` chỉ thủ công và do người kiểm định duyệt.
- Q4 = **C**: độ chính xác và đơn vị hiển thị cấu hình từng chỉ số trong reference; mặc định theo D4, reviewer có thể ghi đè.
- Q5 = **A có variant**: `seed = hash(pattern_id + "cbc" + schema_version + variant)`; variant do server xác định theo `user_id` và số lần luyện.

### Sửa đổi kiến trúc A1–A6
- **A1:** Luyện riêng nhận `p_level` thay vì `p_pattern_id`; server tự giao pattern + variant và giữ kín pattern đến submit. Danh sách “nhận định” cố định theo level.
- **A2:** Attempt `started → submitted`, thuộc `auth.uid()`, kiểm tra ownership, submit lặp idempotent. **Giới hạn đề xuất cần duyệt:** 3 attempt mở đồng thời/user và 10 attempt mới/user/UTC day.
- **A3:** Invariant dùng interval arithmetic. Dung sai từng quan hệ = tổng sai số làm tròn tối đa của các đại lượng tham gia. Sinh bằng Hb, RBC, MCV đã làm tròn làm gốc; suy Hct, MCH, MCHC từ gốc rồi làm tròn và kiểm lại. Differential dùng **largest remainder method** để tổng đúng 100.0% sau làm tròn; absolute count tính từ WBC × percentage / 100 rồi kiểm tra.
- **A4:** Generator nhận `sex` từ CaseBundle hoặc kịch bản luyện; thiếu sex thì từ chối, không đoán.
- **A5:** Fixture chỉ ở `test/fixtures/can-lam-sang/cbc/`, `pattern_id` bắt đầu `FIXTURE-`, `review_status=FIXTURE_ONLY`, có dòng **“KHÔNG PHẢI SỐ LIỆU LÂM SÀNG”**. Fixture không thuộc enum learner; test chứng minh src/public không tham chiếu fixtures và approval gate từ chối mọi status khác `DA_DUYET`.
- **A6:** Đơn vị hiển thị (g/dL, g/L, ×10^12/L, T/L, ×10^9/L, G/L) là cấu hình reference. Engine lưu một hệ đơn vị cố định và chuyển đổi khi hiển thị; test hai chiều.

### Sửa nguồn bắt buộc
- R3 WHO: trang gốc chỉ xác nhận metadata; PDF 79 trang có link nhưng lần mở PDF trả 403. **Không ghi ngưỡng Hb số; ghi `CHƯA XÁC MINH — cần đối chiếu PDF trang ? / bảng ?`.**
- R1 MedlinePlus CBC: Review Date **10/14/2024**. PLT trên trang gốc in `/dL`; module dùng **150–400 ×10^9/L**, không chép `/dL`.
- R1–R6 đều có “nơi chứa số liệu” và “ngày truy xuất”; nguồn chưa mở thật được ghi **CHƯA MỞ**.
- R1/R2 chỉ là `dev-reference` trước khi người kiểm định chọn nguồn chuẩn.

### Trạng thái
Đây là quyết định kiến trúc của Bước 2a-0. Các giới hạn attempt 3 mở / 10 mỗi UTC day là **đề xuất cụ thể để kiến trúc sư duyệt tiếp**, không được coi là đã được phê duyệt chỉ vì nằm trong tài liệu.


### Người kiểm định chính

**Ths. Ngô Võ Thiện Nhân (sinh viên Y khoa ngành YHCT)** là reviewer chính khi và chỉ khi kiến trúc sư cho phép đặt `DA_DUYET`. Khuyến nghị có giảng viên Huyết học/Nội khoa xác nhận lần hai trước khi mở cho học viên ngoài nhóm phát triển; đây là khuyến nghị, chưa phải blocker.
