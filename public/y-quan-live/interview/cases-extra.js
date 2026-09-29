// Mười bệnh cảnh mở rộng cho khu Luyện Thập vấn (Ca D – Ca M).
// Nội dung là ca mô phỏng phục vụ học tập, cần giảng viên YHCT thẩm định.
// Không có toa thuốc, liều dùng hay hướng dẫn điều trị.
const ans = (text, expression = 'neutral', findings = []) => ({ text, expression, findings });
const domains = (...values) => Object.fromEntries(values);

const FEMALE = '/assets/avatars/female_character_29944.jpg';
const MALE = '/assets/avatars/doctor_male_29945.jpg';

export const findingLabels = {
  insomnia: 'Khó ngủ, hay tỉnh giấc',
  forgetful: 'Hay quên, kém tập trung',
  palpitation: 'Hồi hộp, tim đập nhanh',
  fatigue: 'Mệt mỏi, kém sức',
  'pale-face': 'Sắc mặt nhợt nhạt',
  chills: 'Sợ lạnh, ớn lạnh',
  'no-sweat': 'Không ra mồ hôi',
  'clear-nasal': 'Nghẹt mũi, nước mũi trong',
  headache: 'Đau đầu, đau gáy',
  'white-sputum': 'Ho, đờm trắng loãng',
  fever: 'Sốt, nóng nhiều hơn lạnh',
  'sore-throat': 'Đau rát họng',
  'yellow-sputum': 'Ho, đờm vàng đặc',
  'thirst-drink': 'Khát, thích uống mát',
  'slight-sweat': 'Ra ít mồ hôi mà sốt chưa hạ',
  'dry-cough': 'Ho khan kéo dài',
  hoarse: 'Giọng khàn nhẹ',
  dysuria: 'Tiểu buốt, tiểu rát',
  'dark-urine': 'Nước tiểu vàng sẫm',
  'frequent-urine': 'Tiểu nhiều lần, mỗi lần ít',
  'lower-abdomen': 'Tức nặng bụng dưới',
  'heavy-head': 'Đầu nặng như bị bịt',
  'heavy-body': 'Người và chân tay nặng nề',
  nausea: 'Buồn nôn, ăn không ngon',
  phlegm: 'Nhiều đờm',
  'chest-full': 'Ngực bụng đầy tức',
  'fixed-pain': 'Đau cố định một chỗ',
  'stabbing-pain': 'Đau nhói như kim châm',
  'night-worse': 'Đau tăng về đêm',
  'pressure-pain': 'Ấn vào đau tăng',
  'dark-lips': 'Môi tím tối, sắc mặt sạm',
  injury: 'Có tiền sử va đập',
  'headache-distending': 'Đau căng đầu hai bên thái dương',
  dizziness: 'Chóng mặt, hoa mắt',
  irritable: 'Dễ cáu, nóng nảy',
  'red-face': 'Mặt đỏ, bốc nóng',
  'lumbar-cold': 'Lưng gối lạnh và mỏi',
  nocturia: 'Tiểu đêm nhiều lần, nước tiểu trong',
  'morning-loose-stool': 'Phân lỏng buổi sáng sớm',
  'short-breath': 'Hụt hơi khi gắng sức'
};

export const extraCases = [
  {
    id: 'tam-ty-luong-hu', title: 'Ca D · Khó ngủ, hay quên, hồi hộp', patient: 'Lan Chi', avatar: FEMALE,
    complaint: '“Dạo này tôi khó ngủ, hay quên và tim đập nhanh mỗi khi mệt.”',
    pattern: 'Tâm Tỳ lưỡng hư', b8c: ['Lý', 'Hư', 'Hàn nhiệt không nổi bật'],
    principles: ['Bổ Tâm kiện Tỳ, dưỡng huyết an thần (nguyên tắc học thuật)', 'Hỏi đủ giấc ngủ, ăn uống và dấu hiệu cần khám thêm'],
    keyFindings: ['insomnia', 'forgetful', 'palpitation', 'poor-appetite', 'fatigue'],
    answersByCategory: domains(
      ['Hàn nhiệt', ans('Không sốt hay rét run; đôi lúc tay chân hơi lạnh khi mệt.', 'neutral')],
      ['Mồ hôi', ans('Mồ hôi không có gì khác thường; gắng sức nhẹ thì ra ít mồ hôi.', 'neutral')],
      ['Đầu thân', ans('Người mệt, đầu óc kém tập trung, hay hoa mắt nhẹ khi làm việc lâu.', 'tired', ['fatigue', 'forgetful'])],
      ['Đại tiểu tiện', ans('Đại tiện hơi nhão vài hôm gần đây; tiểu tiện bình thường.', 'neutral')],
      ['Ẩm thực', ans('Ăn kém, ăn ít là thấy đầy bụng; bạn bè bảo sắc mặt hơi nhợt.', 'concerned', ['poor-appetite', 'pale-face'])],
      ['Hung sườn bụng', ans('Hay hồi hộp, tim đập nhanh khi mệt hoặc lo lắng; không đau ngực.', 'uneasy', ['palpitation'])],
      ['Tai nghe', ans('Tai nghe bình thường, thỉnh thoảng ù nhẹ khi rất mệt.', 'neutral')],
      ['Khát', ans('Không khát nhiều, miệng không khô rõ.', 'neutral')],
      ['Bệnh sử và thuốc', ans('Chưa có bệnh mạn tính đáng kể; hiện không dùng thuốc thường xuyên.', 'neutral')],
      ['Nguyên nhân và diễn tiến', ans('Rõ hơn sau thời gian làm việc và lo nghĩ kéo dài; khó vào giấc, hay tỉnh giữa đêm và mơ nhiều.', 'tired', ['insomnia', 'forgetful', 'fatigue'])]
    )
  },
  {
    id: 'phong-han-pham-phe', title: 'Ca E · Ớn lạnh, nghẹt mũi sau khi dầm mưa', patient: 'Văn Hải', avatar: MALE,
    complaint: '“Tôi bị ớn lạnh, nghẹt mũi và đau đầu từ sau hôm dầm mưa.”',
    pattern: 'Phong hàn phạm Phế', b8c: ['Biểu', 'Hàn', 'Thực'],
    principles: ['Tân ôn giải biểu (nguyên tắc học thuật)', 'Theo dõi dấu hiệu nặng lên và hỏi đủ tứ chẩn'],
    keyFindings: ['chills', 'no-sweat', 'clear-nasal', 'headache', 'white-sputum'],
    answersByCategory: domains(
      ['Hàn nhiệt', ans('Tôi sợ lạnh rõ, ớn lạnh, sốt nhẹ hoặc không sốt; mặc thêm áo vẫn thấy lạnh.', 'concerned', ['chills'])],
      ['Mồ hôi', ans('Tôi không ra mồ hôi dù đã đắp chăn ấm.', 'concerned', ['no-sweat'])],
      ['Đầu thân', ans('Đau đầu, nhất là vùng gáy; người mỏi nhức.', 'uneasy', ['headache'])],
      ['Đại tiểu tiện', ans('Đại tiện và tiểu tiện chưa thay đổi; nước tiểu trong.', 'neutral')],
      ['Ẩm thực', ans('Ăn uống tạm ổn, thích uống nước ấm.', 'neutral')],
      ['Hung sườn bụng', ans('Không đau ngực hay bụng; hơi ho, đờm trắng loãng.', 'concerned', ['white-sputum'])],
      ['Tai nghe', ans('Tai không ù; mũi nghẹt, chảy nước mũi trong.', 'concerned', ['clear-nasal'])],
      ['Khát', ans('Không khát, muốn uống nước ấm.', 'neutral')],
      ['Bệnh sử và thuốc', ans('Trước đây khỏe; chưa dùng thuốc gì đặc biệt.', 'neutral')],
      ['Nguyên nhân và diễn tiến', ans('Sau khi dầm mưa rồi ngồi trong phòng lạnh; triệu chứng khởi phát trong một, hai ngày.', 'concerned', ['chills', 'no-sweat'])]
    )
  },
  {
    id: 'phong-nhiet-pham-phe', title: 'Ca F · Sốt, đau họng, ho đờm vàng', patient: 'Ngọc Trinh', avatar: FEMALE,
    complaint: '“Tôi sốt, đau họng và ho có đờm vàng từ hai ngày nay.”',
    pattern: 'Phong nhiệt phạm Phế', b8c: ['Biểu', 'Nhiệt', 'Thực'],
    principles: ['Tân lương giải biểu, tuyên Phế (nguyên tắc học thuật)', 'Theo dõi dấu hiệu nặng lên và hỏi đủ tứ chẩn'],
    keyFindings: ['fever', 'sore-throat', 'yellow-sputum', 'thirst-drink', 'slight-sweat'],
    answersByCategory: domains(
      ['Hàn nhiệt', ans('Tôi sốt, hơi sợ gió nhưng nóng nhiều hơn lạnh.', 'concerned', ['fever'])],
      ['Mồ hôi', ans('Có ra chút mồ hôi nhưng sốt không hạ hẳn.', 'concerned', ['slight-sweat'])],
      ['Đầu thân', ans('Đau đầu nhẹ, người nóng và mỏi.', 'uneasy', ['fever'])],
      ['Đại tiểu tiện', ans('Đại tiện hơi khô; tiểu vàng, lượng ít.', 'concerned')],
      ['Ẩm thực', ans('Ăn kém, thích đồ mát.', 'tired')],
      ['Hung sườn bụng', ans('Ho, đờm vàng đặc; nuốt thấy đau rát họng.', 'uneasy', ['yellow-sputum', 'sore-throat'])],
      ['Tai nghe', ans('Tai không ù; họng sưng đau, đôi lúc lan lên tai.', 'uneasy', ['sore-throat'])],
      ['Khát', ans('Khát, thích uống nước mát.', 'concerned', ['thirst-drink'])],
      ['Bệnh sử và thuốc', ans('Trước đây khỏe; chưa dùng thuốc gì ngoài uống nhiều nước.', 'neutral')],
      ['Nguyên nhân và diễn tiến', ans('Bắt đầu sau khi tiếp xúc người bị cảm và trời thay đổi đột ngột; họng đau trước rồi mới sốt.', 'concerned', ['sore-throat', 'fever'])]
    )
  },
  {
    id: 'phe-am-hu', title: 'Ca G · Ho khan kéo dài, khô họng', patient: 'Bảo Ngọc', avatar: FEMALE,
    complaint: '“Tôi ho khan kéo dài, họng khô, chiều tối thấy nóng âm ỉ.”',
    pattern: 'Phế âm hư', b8c: ['Lý', 'Nhiệt hư', 'Hư'],
    principles: ['Tư âm nhuận Phế, chỉ khái (nguyên tắc học thuật)', 'Đánh giá nguyên nhân khác và hỏi đủ tứ chẩn'],
    keyFindings: ['dry-cough', 'dry-throat', 'tidal-heat', 'night-sweat', 'hoarse'],
    answersByCategory: domains(
      ['Hàn nhiệt', ans('Chiều tối tôi thấy nóng âm ỉ ở lòng bàn tay, không rét run.', 'tired', ['tidal-heat'])],
      ['Mồ hôi', ans('Có ra mồ hôi lúc ngủ, sáng dậy thấy áo ẩm.', 'concerned', ['night-sweat'])],
      ['Đầu thân', ans('Người gầy đi, mệt nhẹ; không đau đầu.', 'tired')],
      ['Đại tiểu tiện', ans('Đại tiện hơi khô; tiểu ít, màu sẫm.', 'neutral')],
      ['Ẩm thực', ans('Ăn uống tương đối bình thường; thích đồ mát, nhuận.', 'neutral')],
      ['Hung sườn bụng', ans('Ho khan từng cơn, ít đờm, đôi khi đờm dính; ngực hơi rát.', 'uneasy', ['dry-cough'])],
      ['Tai nghe', ans('Tai không ù; giọng hơi khàn khi nói nhiều.', 'tired', ['hoarse'])],
      ['Khát', ans('Họng khô, muốn uống nước nhưng mỗi lần uống ít.', 'tired', ['dry-throat'])],
      ['Bệnh sử và thuốc', ans('Trước đây có lần viêm đường hô hấp, ho kéo dài nhiều tuần; chưa dùng thuốc đều.', 'neutral')],
      ['Nguyên nhân và diễn tiến', ans('Ho kéo dài nhiều tuần, nặng hơn khi trời hanh khô và khi thức khuya.', 'concerned', ['dry-cough', 'tidal-heat'])]
    )
  },
  {
    id: 'bang-quang-thap-nhiet', title: 'Ca H · Tiểu buốt, nước tiểu vàng', patient: 'Hoàng Nam', avatar: MALE,
    complaint: '“Tôi đi tiểu buốt, nước tiểu vàng và đi nhiều lần trong ngày.”',
    pattern: 'Bàng quang thấp nhiệt', b8c: ['Lý', 'Nhiệt', 'Thực'],
    principles: ['Thanh nhiệt lợi thấp thông lâm (nguyên tắc học thuật)', 'Nhận biết dấu hiệu cần khám sớm như sốt cao, đau lưng, tiểu ra máu'],
    keyFindings: ['dysuria', 'dark-urine', 'frequent-urine', 'lower-abdomen', 'thirst-drink'],
    answersByCategory: domains(
      ['Hàn nhiệt', ans('Người hơi nóng, bứt rứt; chưa sốt cao.', 'concerned')],
      ['Mồ hôi', ans('Mồ hôi không thay đổi rõ.', 'neutral')],
      ['Đầu thân', ans('Bụng dưới tức nặng; lưng không đau nhiều.', 'uneasy', ['lower-abdomen'])],
      ['Đại tiểu tiện', ans('Tiểu buốt, tiểu rát, nước tiểu vàng sẫm, đi nhiều lần nhưng mỗi lần ít; đại tiện hơi khô.', 'uneasy', ['dysuria', 'dark-urine', 'frequent-urine'])],
      ['Ẩm thực', ans('Ăn uống được; gần đây hay ăn cay nóng và uống ít nước.', 'concerned')],
      ['Hung sườn bụng', ans('Ngực không đau; vùng bụng dưới căng tức.', 'uneasy', ['lower-abdomen'])],
      ['Tai nghe', ans('Tai nghe bình thường.', 'neutral')],
      ['Khát', ans('Khát, miệng đắng, thích uống nước mát.', 'concerned', ['thirst-drink'])],
      ['Bệnh sử và thuốc', ans('Trước đây từng có lần bị tương tự; chưa dùng thuốc đều đặn.', 'neutral')],
      ['Nguyên nhân và diễn tiến', ans('Xuất hiện sau nhiều ngày làm việc liên tục, nhịn tiểu và uống ít nước.', 'concerned', ['dysuria', 'dark-urine'])]
    )
  },
  {
    id: 'dam-thap-tro-tre', title: 'Ca I · Đầu nặng, người nặng nề, buồn nôn', patient: 'Thanh Tùng', avatar: MALE,
    complaint: '“Đầu tôi nặng, người nặng nề, hay buồn nôn và nhiều đờm.”',
    pattern: 'Đàm thấp trở trệ', b8c: ['Lý', 'Hàn nhiệt không nổi bật', 'Thực'],
    principles: ['Kiện Tỳ táo thấp, hóa đàm (nguyên tắc học thuật)', 'Hỏi đủ ăn uống, đại tiểu tiện và diễn tiến'],
    keyFindings: ['heavy-head', 'heavy-body', 'nausea', 'phlegm', 'chest-full'],
    answersByCategory: domains(
      ['Hàn nhiệt', ans('Không rét run hay sốt; người khó chịu, ẩm nặng khi trời nồm.', 'concerned')],
      ['Mồ hôi', ans('Mồ hôi dính, ra ít; sau bữa ăn dễ thấy người nặng nề.', 'neutral')],
      ['Đầu thân', ans('Đầu nặng như bị bịt; người và chân tay nặng nề.', 'concerned', ['heavy-head', 'heavy-body'])],
      ['Đại tiểu tiện', ans('Đại tiện dính, khó xả hết; tiểu tiện bình thường.', 'neutral')],
      ['Ẩm thực', ans('Ăn không thấy ngon, hay buồn nôn, lại thích đồ béo ngọt.', 'concerned', ['nausea'])],
      ['Hung sườn bụng', ans('Ngực và bụng đầy tức, hay khạc đờm.', 'uneasy', ['chest-full', 'phlegm'])],
      ['Tai nghe', ans('Thỉnh thoảng chóng mặt, tai nghe hơi nặng.', 'concerned')],
      ['Khát', ans('Không khát, miệng nhớt dính.', 'neutral')],
      ['Bệnh sử và thuốc', ans('Cân nặng tăng dần trong vài tháng; chưa dùng thuốc đều đặn.', 'neutral')],
      ['Nguyên nhân và diễn tiến', ans('Ăn nhiều đồ béo ngọt, ít vận động; trời ẩm thì nặng hơn.', 'concerned', ['heavy-body', 'phlegm'])]
    )
  },
  {
    id: 'huyet-u-tro-lac', title: 'Ca J · Đau cố định, đau nhói về đêm', patient: 'Kim Oanh', avatar: FEMALE,
    complaint: '“Tôi đau nhói một chỗ ở vai gáy, về đêm đau nhiều hơn.”',
    pattern: 'Huyết ứ trở lạc', b8c: ['Lý', 'Hàn nhiệt không nổi bật', 'Thực'],
    principles: ['Hoạt huyết hóa ứ, thông lạc chỉ thống (nguyên tắc học thuật)', 'Nhận biết dấu hiệu nặng và hỏi đủ tứ chẩn'],
    keyFindings: ['fixed-pain', 'stabbing-pain', 'night-worse', 'pressure-pain', 'dark-lips'],
    answersByCategory: domains(
      ['Hàn nhiệt', ans('Không sốt hay rét run; không thấy lạnh nóng đặc biệt.', 'neutral')],
      ['Mồ hôi', ans('Mồ hôi bình thường.', 'neutral')],
      ['Đầu thân', ans('Đau nhói cố định ở một điểm vai gáy, không chạy sang chỗ khác; đêm đau nhiều hơn.', 'uneasy', ['fixed-pain', 'stabbing-pain', 'night-worse'])],
      ['Đại tiểu tiện', ans('Đại tiện và tiểu tiện bình thường.', 'neutral')],
      ['Ẩm thực', ans('Ăn uống bình thường.', 'neutral')],
      ['Hung sườn bụng', ans('Ngực bụng không đau; ấn vào chỗ đau thì đau tăng, tôi không thích bị đè.', 'concerned', ['pressure-pain'])],
      ['Tai nghe', ans('Tai nghe bình thường.', 'neutral')],
      ['Khát', ans('Miệng khô nhưng chỉ muốn ngậm nước, ít khi uống nhiều.', 'concerned')],
      ['Bệnh sử và thuốc', ans('Cách đây vài tháng bị va đập vùng vai gáy khi vận động; chưa điều trị đều đặn.', 'concerned', ['injury'])],
      ['Nguyên nhân và diễn tiến', ans('Sau va đập cơn đau không hết hẳn, về đêm tăng; môi hơi tím tối, sắc mặt sạm.', 'concerned', ['night-worse', 'dark-lips'])]
    )
  },
  {
    id: 'can-duong-thuong-cang', title: 'Ca K · Đau căng đầu, chóng mặt, dễ cáu', patient: 'Quang Minh', avatar: MALE,
    complaint: '“Tôi hay đau căng đầu, chóng mặt, mặt đỏ và dễ cáu gắt.”',
    pattern: 'Can dương thượng cang', b8c: ['Lý', 'Nhiệt', 'Hư thực thác tạp'],
    principles: ['Bình Can tiềm dương (nguyên tắc học thuật)', 'Đánh giá an toàn như huyết áp và dấu hiệu nặng, rồi hỏi đủ tứ chẩn'],
    keyFindings: ['headache-distending', 'dizziness', 'irritable', 'red-face', 'tinnitus'],
    answersByCategory: domains(
      ['Hàn nhiệt', ans('Người bốc nóng, mặt đỏ nhất là lúc bực bội; không rét run.', 'concerned', ['red-face'])],
      ['Mồ hôi', ans('Mồ hôi ban ngày ra hơi nhiều khi nóng nảy.', 'neutral')],
      ['Đầu thân', ans('Đau căng đầu hai bên thái dương, chóng mặt, lưng gối mỏi.', 'uneasy', ['headache-distending', 'dizziness'])],
      ['Đại tiểu tiện', ans('Đại tiện khô; tiểu vàng.', 'neutral')],
      ['Ẩm thực', ans('Ăn uống được, thích uống trà đặc; ngủ ít vì công việc.', 'neutral')],
      ['Hung sườn bụng', ans('Ngực sườn hơi tức mỗi khi tức giận.', 'concerned')],
      ['Tai nghe', ans('Hay ù tai như tiếng ve, tăng khi bực bội.', 'uneasy', ['tinnitus'])],
      ['Khát', ans('Miệng đắng, họng khô, thích uống nước mát.', 'concerned')],
      ['Bệnh sử và thuốc', ans('Từng đo huyết áp hơi cao nhưng chưa theo dõi đều; tôi chưa dùng thuốc thường xuyên.', 'concerned')],
      ['Nguyên nhân và diễn tiến', ans('Công việc áp lực, thức khuya, hay tức giận thì đau đầu nặng hơn.', 'concerned', ['irritable', 'headache-distending'])]
    )
  },
  {
    id: 'than-duong-hu', title: 'Ca L · Lưng gối lạnh, tiểu đêm nhiều lần', patient: 'Đức Hòa', avatar: MALE,
    complaint: '“Lưng gối tôi lạnh và mỏi, đêm phải dậy tiểu nhiều lần.”',
    pattern: 'Thận dương hư', b8c: ['Lý', 'Hàn', 'Hư'],
    principles: ['Ôn bổ Thận dương (nguyên tắc học thuật)', 'Hỏi đủ tiểu đêm, phân lỏng buổi sáng và sức lực'],
    keyFindings: ['cold', 'lumbar-cold', 'nocturia', 'morning-loose-stool', 'fatigue'],
    answersByCategory: domains(
      ['Hàn nhiệt', ans('Tôi rất sợ lạnh, tay chân lạnh; mùa lạnh thì lưng gối lạnh hơn.', 'tired', ['cold'])],
      ['Mồ hôi', ans('Ít mồ hôi; đôi khi ra mồ hôi lạnh khi mệt.', 'neutral')],
      ['Đầu thân', ans('Lưng gối mỏi lạnh, sức lực giảm, hay mệt.', 'tired', ['lumbar-cold', 'fatigue'])],
      ['Đại tiểu tiện', ans('Đêm dậy tiểu hai, ba lần, nước tiểu trong, lượng nhiều; sáng sớm hay đi phân lỏng.', 'concerned', ['nocturia', 'morning-loose-stool'])],
      ['Ẩm thực', ans('Ăn uống bình thường, thích đồ ấm.', 'neutral')],
      ['Hung sườn bụng', ans('Bụng dưới lạnh nhưng không đau; xoa ấm thì dễ chịu.', 'relieved')],
      ['Tai nghe', ans('Tai hơi ù nhẹ, nghe vẫn bình thường.', 'neutral')],
      ['Khát', ans('Không khát nhiều; hay uống nước ấm.', 'neutral')],
      ['Bệnh sử và thuốc', ans('Tình trạng lặp lại nhiều tháng; tôi chưa dùng thuốc đều đặn.', 'neutral')],
      ['Nguyên nhân và diễn tiến', ans('Làm việc mệt kéo dài, gặp lạnh thì nặng hơn.', 'concerned', ['cold', 'fatigue'])]
    )
  },
  {
    id: 'khi-huyet-luong-hu', title: 'Ca M · Chóng mặt, mệt, sắc mặt nhợt', patient: 'Mỹ Linh', avatar: FEMALE,
    complaint: '“Tôi hay chóng mặt khi đứng dậy, người mệt và da xanh xao.”',
    pattern: 'Khí huyết lưỡng hư', b8c: ['Lý', 'Hư', 'Hàn nhiệt không nổi bật'],
    principles: ['Bổ khí dưỡng huyết (nguyên tắc học thuật)', 'Hỏi đủ ăn uống, kinh nguyệt và dấu hiệu cần khám thêm'],
    keyFindings: ['dizziness', 'fatigue', 'pale-face', 'palpitation', 'short-breath'],
    answersByCategory: domains(
      ['Hàn nhiệt', ans('Không sốt; tay chân hơi lạnh mỗi khi mệt.', 'neutral')],
      ['Mồ hôi', ans('Hay ra mồ hôi khi gắng sức nhẹ, sau đó thấy mệt hơn.', 'tired')],
      ['Đầu thân', ans('Chóng mặt, hoa mắt khi đứng dậy nhanh; người mệt, không có sức.', 'tired', ['dizziness', 'fatigue'])],
      ['Đại tiểu tiện', ans('Đại tiện và tiểu tiện bình thường.', 'neutral')],
      ['Ẩm thực', ans('Ăn ít, khó tiêu; sắc mặt nhợt nhạt.', 'concerned', ['pale-face'])],
      ['Hung sườn bụng', ans('Không đau; đôi lúc hồi hộp, hụt hơi khi gắng sức.', 'concerned', ['palpitation', 'short-breath'])],
      ['Tai nghe', ans('Thỉnh thoảng ù tai nhẹ khi đứng dậy nhanh.', 'neutral')],
      ['Khát', ans('Không khát nhiều.', 'neutral')],
      ['Bệnh sử và thuốc', ans('Sau một đợt ốm dài ngày, kinh nguyệt ít; tôi chưa dùng thuốc đều đặn.', 'concerned')],
      ['Nguyên nhân và diễn tiến', ans('Mệt tăng khi làm việc nhiều hoặc thiếu ngủ; nghỉ ngơi thì đỡ.', 'tired', ['fatigue', 'dizziness'])]
    )
  }
];
