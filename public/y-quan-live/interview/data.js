import { questionBank } from './question-bank.js';

export const questions = questionBank;

const ans = (text, expression='neutral', findings=[]) => ({text, expression, findings});
const domains = (...values) => Object.fromEntries(values);

export const cases = [
  {
    id:'can-khi-uat-ket', title:'Ca A · Tức sườn khi áp lực', patient:'Minh Anh', avatar:'/assets/avatars/female_character_29944.jpg',
    complaint:'“Gần đây tôi hay thấy tức ở hai bên sườn, lúc có lúc không.”',
    pattern:'Can khí uất kết', b8c:['Lý','Khí trệ thiên thực','Hàn nhiệt không nổi bật'],
    principles:['Sơ Can lý khí (nguyên tắc học thuật)','Hỏi đủ tứ chẩn trước khi kết luận'],
    keyFindings:['stress','flank','sighing','variable'],
    answersByCategory:domains(
      ['Hàn nhiệt',ans('Không rét run hay sốt; khi bực bội tôi thấy bứt rứt hơn.','concerned',['variable'])],
      ['Mồ hôi',ans('Mồ hôi không có gì khác thường, cả ngày lẫn khi ngủ.','neutral')],
      ['Đầu thân',ans('Hai bên sườn đôi lúc tức; những hôm áp lực tôi cũng khó thư giãn.','uneasy',['flank','stress'])],
      ['Đại tiểu tiện',ans('Đại tiện và tiểu tiện chưa thấy khác thường.','neutral')],
      ['Ẩm thực',ans('Khẩu vị giảm nhẹ khi căng thẳng; không có sở thích nóng lạnh rõ.','concerned',['stress'])],
      ['Hung sườn bụng',ans('Ngực sườn đầy tức từng lúc; thở dài thì dễ chịu hơn.','uneasy',['flank','sighing','variable'])],
      ['Tai nghe',ans('Tai không ù, nghe vẫn bình thường.','neutral')],
      ['Khát',ans('Không khát nhiều, miệng không khô rõ.','neutral')],
      ['Bệnh sử và thuốc',ans('Trước đây chưa có bệnh đáng kể; hiện không dùng thuốc thường xuyên.','neutral')],
      ['Nguyên nhân và diễn tiến',ans('Triệu chứng rõ hơn trong giai đoạn áp lực; khi lo lắng cảm giác tức sườn tăng. Nếu hỏi chu kỳ, tôi xin trả lời riêng.','guarded',['stress','flank'])]
    )
  },
  {
    id:'ty-vi-hu-han', title:'Ca B · Đau bụng thích chườm ấm', patient:'Quốc Bảo', avatar:'/assets/avatars/doctor_male_29945.jpg',
    complaint:'“Bụng tôi đau âm ỉ, ăn lạnh vào thì khó chịu hơn.”',
    pattern:'Tỳ vị hư hàn', b8c:['Lý','Hàn','Hư'],
    principles:['Ôn trung kiện Tỳ (nguyên tắc học thuật)','Hỏi đủ mức ăn uống và dấu hiệu mất nước'],
    keyFindings:['cold','warmth','poor-appetite','loose-stool'],
    answersByCategory:domains(
      ['Hàn nhiệt',ans('Tôi khá sợ lạnh, nhất là vùng bụng và tay chân.','tired',['cold'])],
      ['Mồ hôi',ans('Không có mồ hôi trộm; vận động mới ra mồ hôi như thường.','neutral')],
      ['Đầu thân',ans('Người hơi mệt; bụng lạnh khó chịu, không đau đầu.','tired',['cold'])],
      ['Đại tiểu tiện',ans('Đại tiện thường lỏng; tiểu tiện không thay đổi rõ.','concerned',['loose-stool'])],
      ['Ẩm thực',ans('Ăn kém, thích đồ ấm; ăn lạnh dễ khó chịu bụng.','concerned',['poor-appetite','cold'])],
      ['Hung sườn bụng',ans('Đau âm ỉ vùng thượng vị; xoa hoặc chườm ấm thì dễ chịu.','relieved',['warmth'])],
      ['Tai nghe',ans('Tai không ù, nghe bình thường.','neutral')],
      ['Khát',ans('Không khát nhiều; nếu uống thì thường chọn nước ấm.','neutral')],
      ['Bệnh sử và thuốc',ans('Tình trạng lặp lại vài tháng; tôi không dùng thuốc đều đặn.','neutral')],
      ['Nguyên nhân và diễn tiến',ans('Bữa ăn thất thường và đồ lạnh thường làm bụng khó chịu hơn; căng thẳng không làm thay đổi nhiều.','concerned',['cold'])]
    )
  },
  {
    id:'am-hu-hoa-vuong', title:'Ca C · Nóng âm ỉ về chiều', patient:'Thu Hà', avatar:'/assets/avatars/female_character_29944.jpg',
    complaint:'“Chiều tối tôi hay thấy nóng âm ỉ, đêm ngủ không yên.”',
    pattern:'Âm hư hỏa vượng', b8c:['Lý','Nhiệt hư','Hư'],
    principles:['Tư âm thanh nhiệt (nguyên tắc học thuật)','Đánh giá nguyên nhân khác và hỏi đủ tứ chẩn'],
    keyFindings:['tidal-heat','night-sweat','dry-throat','tinnitus','lumbar-weakness'],
    answersByCategory:domains(
      ['Hàn nhiệt',ans('Chiều tối thường thấy nóng âm ỉ nhưng không rét run.','tired',['tidal-heat'])],
      ['Mồ hôi',ans('Thỉnh thoảng tôi ra mồ hôi lúc ngủ; ban ngày thì ít.','concerned',['night-sweat'])],
      ['Đầu thân',ans('Lưng gối hơi mỏi và sức lực giảm đã một thời gian.','tired',['lumbar-weakness'])],
      ['Đại tiểu tiện',ans('Đại tiểu tiện không đổi rõ; chưa táo bón đáng kể.','neutral')],
      ['Ẩm thực',ans('Ăn uống tương đối bình thường, đôi lúc khô miệng khó chịu.','neutral',['dry-throat'])],
      ['Hung sườn bụng',ans('Không đau ngực hay bụng; chỉ bứt rứt nhẹ vào chiều tối.','concerned',['tidal-heat'])],
      ['Tai nghe',ans('Thỉnh thoảng tôi ù tai nhẹ, không liên tục.','concerned',['tinnitus'])],
      ['Khát',ans('Họng khô hơn về đêm, tôi thường nhấp từng ngụm nước.','tired',['dry-throat'])],
      ['Bệnh sử và thuốc',ans('Tình trạng kéo dài vài tháng; tôi chưa dùng thuốc đều.','neutral')],
      ['Nguyên nhân và diễn tiến',ans('Gần đây ngủ muộn và làm việc kéo dài; nóng và khô họng rõ hơn về chiều tối.','concerned',['tidal-heat','dry-throat'])]
    )
  }
];
