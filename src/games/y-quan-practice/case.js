// Synthetic preview fixture. It is deliberately isolated from Study OS and
// Supabase game state. A lecturer must review its academic content before use.
export const Y_QUAN_CASE = Object.freeze({
  caseId: 'admin-preview-cold-low-back-001',
  version: 1,
  status: 'PUBLISHED', // Published only inside this admin-gated preview.
  title: 'Mỏi lưng gối khi trời lạnh',
  difficulty: 'CƠ BẢN',
  patientProfile: Object.freeze({
    fictional: true,
    displayName: 'Cô An · nhân vật mô phỏng',
    ageBand: 'Người trưởng thành',
    context: 'Nhân vật hư cấu. Không lưu hoặc dùng thông tin người bệnh thật.'
  }),
  opening: 'Dạo gần đây tôi thấy người hơi lạnh, lưng gối mỏi nặng. Em có thể hỏi thêm để tìm hiểu tình trạng của tôi không?',
  interviewDomains: Object.freeze([
    ['cold', 'Hàn – nhiệt', 'Cơ thể thường thấy nóng hay lạnh?', 'Hay sợ lạnh, thích ấm.', 'KEY', 'cold_pattern', 3],
    ['sweat', 'Mồ hôi', 'Có ra mồ hôi bất thường không?', 'Ít ra mồ hôi, không tự hãn.', 'SUPPORTING', 'surface', 2],
    ['pain', 'Đầu, thân thể đau nhức', 'Cảm giác đau ở đâu và thế nào?', 'Mỏi nặng vùng thắt lưng và gối, tăng khi lạnh.', 'KEY', 'pain_low_back', 3],
    ['bowel', 'Đại tiểu tiện', 'Đại tiểu tiện có gì thay đổi?', 'Tiểu trong, lượng nhiều hơn thường ngày; đại tiện bình thường.', 'KEY', 'urine_clear', 3],
    ['food', 'Ăn uống, khẩu vị', 'Ăn uống và khẩu vị gần đây ra sao?', 'Ăn uống bình thường, không buồn nôn.', 'DISTRACTOR', 'appetite_ok', 1],
    ['chest', 'Ngực bụng', 'Vùng ngực bụng có cảm giác gì không?', 'Không tức ngực, bụng không đau.', 'SUPPORTING', 'chest_clear', 2],
    ['senses', 'Tai mắt, thính giác', 'Tai và mắt có điều gì thay đổi?', 'Tai nghe kém thoáng qua khi mệt.', 'SUPPORTING', 'hearing_tired', 2],
    ['thirst', 'Khát, uống nước', 'Có khát nhiều không, thích uống gì?', 'Không khát nhiều, thích nước ấm.', 'KEY', 'warm_drink', 3],
    ['history', 'Bệnh cũ, thuốc dùng', 'Trước đây có tình trạng tương tự hoặc đang dùng thuốc gì?', 'Chưa ghi nhận bệnh nền trong ca mô phỏng; không nêu thuốc đang dùng.', 'SUPPORTING', 'history_none', 2],
    ['course', 'Nguyên nhân, diễn tiến', 'Tình trạng bắt đầu khi nào và diễn tiến ra sao?', 'Mỏi tăng sau thời tiết lạnh vài ngày, giảm nhẹ khi nghỉ và giữ ấm.', 'KEY', 'cold_course', 3]
  ].map(([id, title, question, answer, tag, evidenceId, weight], index) => Object.freeze({
    domainId: id,
    order: index + 1,
    title,
    questions: Object.freeze([Object.freeze({
      questionId: `q-${id}-01`,
      text: question,
      responses: Object.freeze([Object.freeze({
        responseId: `r-${id}-01`, text: answer, tags: Object.freeze([tag]), weight,
        evidenceIds: Object.freeze([evidenceId])
      })])
    })])
  }))),
  diagnosis: Object.freeze({
    primaryPattern: 'Thận dương hư · đáp án mục tiêu của ca mô phỏng',
    rubric: Object.freeze([{ acceptedTerms: Object.freeze(['thận dương hư', 'thận dương bất túc']), points: 35 }]),
    reasoningRubric: Object.freeze([
      { keywords: Object.freeze(['sợ lạnh', 'thích ấm', 'hàn']), points: 7 },
      { keywords: Object.freeze(['lưng', 'gối', 'thắt lưng']), points: 7 },
      { keywords: Object.freeze(['tiểu trong', 'nước tiểu', 'lượng nhiều']), points: 6 }
    ])
  }),
  learningPlan: Object.freeze([
    { key: 'review-kidney-yang', label: 'Ôn dấu hiệu và cơ chế bệnh sinh của Thận dương hư.', points: 5 },
    { key: 'compare-patterns', label: 'So sánh với các chứng hư khác dựa trên dữ kiện đã hỏi.', points: 5 }
  ]),
  feedback: Object.freeze({
    strengths: Object.freeze(['Hỏi theo trình tự Thập vấn.', 'Ghi nhận chứng cứ trước khi biện luận.']),
    reviewPoints: Object.freeze(['Hỏi đủ các lĩnh vực để tránh bỏ sót dữ kiện.', 'Nêu rõ mối liên hệ giữa triệu chứng và nhận định.']),
    learningNote: 'Bản xem trước dành cho quản trị viên kiểm tra cách chơi. Nội dung học thuật cần giảng viên YHCT rà soát trước khi mở cho sinh viên.'
  }),
  provenance: Object.freeze({ sourceType: 'EDUCATIONAL_SYNTHETIC', reviewedBy: 'Chưa có giảng viên duyệt', reviewedAt: '2026-09-25' })
});
