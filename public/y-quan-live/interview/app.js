import { cases, questions } from './data.js';
import { createQuestionPlan, scoreAttempt, starsForScore } from './engine.js';
import { gameHubPath } from '../paths.js';

const root = document.querySelector('#yq-interview');
const scenes = [
  ['waiting', 'Không gian chờ'],
  ['pulse', 'Phòng vấn chẩn'],
  ['care', 'Phòng dưỡng trị'],
  ['pharmacy', 'Phòng chế dược']
];
const face = {neutral:'🙂', concerned:'😟', uneasy:'😣', tired:'😔', relieved:'😌', guarded:'😶'};
const esc = value => String(value ?? '').replace(/[&<>"']/g, ch => ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[ch]));
let scene = 'waiting';
let caseFile = null;
let plan = [];
let asked = [];
let transcript = [];
let captured = new Set();
let selectedB8C = [];
let selectedB8CCase = '';
let selectedPattern = '';
let selectedPrinciple = '';
let activeCategory = '';
let resultScore = null;
let doctorAvatar = 'male';
let scheduledCase = null;
let scheduledResult = null;
let reasoning = '';
const domainCode = {'Hàn nhiệt':'cold','Mồ hôi':'sweat','Đầu thân':'pain','Đại tiểu tiện':'bowel','Ẩm thực':'food','Hung sườn bụng':'chest','Tai nghe':'senses','Khát':'thirst','Bệnh sử và thuốc':'history','Nguyên nhân và diễn tiến':'course'};

function signedIn() {
  try { return Boolean(JSON.parse(localStorage.getItem('hiutmc-member-session-v1') || 'null')?.accessToken); }
  catch { return false; }
}
function newCase() {
  const index = Math.floor(Math.random() * cases.length);
  const selected = scheduledCase?.case_profile_id ? cases.find(item => item.id === scheduledCase.case_profile_id) : null;
  caseFile = selected ? {...selected, complaint:scheduledCase.case_prompt || selected.complaint} : cases[index];
  const seed = crypto.getRandomValues(new Uint32Array(1))[0];
  plan = createQuestionPlan(seed);
  asked = [];
  transcript = [{speaker:caseFile.patient, text:caseFile.complaint, expression:'concerned'}];
  captured = new Set();
  selectedB8C = [];
  selectedB8CCase = '';
  selectedPattern = '';
  selectedPrinciple = '';
  activeCategory = '';
  resultScore = null;
  scheduledResult = null;
  reasoning = '';
  scene = 'pulse';
  render();
}
function go(next) {
  if (!scenes.some(([id]) => id === next)) return;
  scene = next;
  render();
  const panel = root.querySelector('.room-panel');
  panel?.focus({preventScroll:true});
}
function nav() {
  return `<div class="scene-nav" aria-label="Phòng trong Y Quán">${scenes.map(([id,label],i)=>`<span class="scene-step ${scene===id?'current':''} ${scenes.findIndex(x=>x[0]===scene)>i?'done':''}">${i+1}. ${label}</span>`).join('')}</div>`;
}
function header() {
  return `<header class="iq-header"><a class="iq-back" href="${gameHubPath('y-quan-live/')}">← Về Y Quán</a><div><span class="iq-kicker">HIU TMC · KHU LUYỆN TẬP</span><h1>Luyện vấn chẩn Thập vấn</h1></div><span class="beta-tag">BẢN TRẢI NGHIỆM</span></header>${nav()}`;
}
function doctorCard() {
  const src=doctorAvatar==='female'?gameHubPath('assets/avatars/female_character_29944.jpg'):gameHubPath('assets/avatars/doctor_male_29945.jpg');
  return `<div class="character doctor"><img src="${src}" alt="Bác sĩ ${doctorAvatar==='female'?'nữ':'nam'} HIU Y Quán"><div><span class="role-label">BÁC SĨ</span><b>Bác sĩ trực</b><small>Đang lắng nghe</small></div></div>`;
}
function patientCard(expression='neutral') {
  return `<div class="character patient"><div class="expression">${face[expression] || face.neutral}</div><img src="${esc(gameHubPath(caseFile?.avatar || 'assets/avatars/female_character_29944.jpg'))}" alt="Người bệnh mô phỏng"><div><span class="role-label">NGƯỜI BỆNH · CA MÔ PHỎNG</span><b>${esc(caseFile?.patient || 'Người bệnh')}</b><small>${esc(caseFile?.title || '')}</small></div></div>`;
}
function waiting() {
  return `<section class="room-panel room-entry" tabindex="-1"><div class="room-backdrop waiting-bg"><div class="lantern">☯</div><div class="room-copy"><p class="iq-kicker">CA BỆNH GIÁO DỤC · KHÔNG LƯU DỮ LIỆU SỨC KHỎE</p><h2>Chuẩn bị đón người bệnh</h2><p>Mỗi lượt có đúng 10 câu, một câu được chọn ngẫu nhiên từ ngân hàng 220 câu, phân đều cho 10 nội dung Thập vấn.</p><div class="avatar-select"><span>Chọn bác sĩ:</span><button class="avatar-option ${doctorAvatar==='male'?'picked':''}" data-doctor-avatar="male"><img src="${gameHubPath('assets/avatars/doctor_male_29945.jpg')}" alt="">Nam</button><button class="avatar-option ${doctorAvatar==='female'?'picked':''}" data-doctor-avatar="female"><img src="${gameHubPath('assets/avatars/female_character_29944.jpg')}" alt="">Nữ</button></div><button class="iq-primary" data-action="start">Bắt đầu ca ngẫu nhiên <span>→</span></button></div></div><div class="three-notes"><div><b>01 · Hỏi đủ 10 mục</b><span>Mỗi nội dung Thập vấn có một câu hỏi ngẫu nhiên.</span></div><div><b>02 · Ghi nhận</b><span>Chọn dữ kiện phù hợp với lời kể của người bệnh.</span></div><div><b>03 · Biện chứng</b><span>Bot phản hồi độ chính xác chẩn đoán theo phần trăm.</span></div></div></section>`;
}
function categoryPanel() {
  const categories = [...new Set(plan.map(q=>q.category))];
  const grouped = categories.map(category => {
    const remaining = plan.filter(q=>q.category===category && !asked.some(a=>a.id===q.id));
    return `<div class="question-group"><button class="category-button ${activeCategory===category?'selected':''}" data-category="${esc(category)}" ${remaining.length?'':'disabled'}><span>${esc(category)}</span><small>${remaining.length ? remaining.length+' câu còn lại':'Đã hỏi'}</small></button>${activeCategory===category ? `<div class="question-options">${remaining.map(q=>`<button class="question-choice" data-question="${q.id}">${esc(q.text)}</button>`).join('') || '<span class="muted">Đã khai thác nội dung này.</span>'}</div>` : ''}</div>`;
  }).join('');
  return `<aside class="question-board"><div class="board-heading"><span class="iq-kicker">10 NỘI DUNG THẬP VẤN · 220 CÂU</span><b>${asked.length}/10 câu</b></div><div class="progress-track"><span style="width:${Math.round(asked.length/10*100)}%"></span></div><div class="question-groups">${grouped}</div><button class="iq-secondary finish-interview" data-action="finish-interview" ${asked.length<10?'disabled':''}>Hoàn tất hỏi bệnh</button></aside>`;
}
function pulse() {
  const last = transcript.at(-1);
  const current = asked.length;
  const questionMarkup = last ? `<div class="dialogue-card"><div class="dialogue-meta"><span>${last.speaker==='Bác sĩ'?'BÁC SĨ':`NGƯỜI BỆNH · ${esc(caseFile.patient)}`}</span><span>${last.speaker==='Bác sĩ'?'HỎI':'TRẢ LỜI'}</span></div><p>${esc(last.text)}</p></div>` : '';
  const findingMarkup = last?.findings?.length ? `<div class="finding-prompts"><span>Bạn muốn ghi nhận dữ kiện nào?</span>${last.findings.map(id=>`<button data-finding="${esc(id)}" class="finding-chip ${captured.has(id)?'on':''}">${captured.has(id)?'✓ ':''}${esc(id)}</button>`).join('')}</div>` : '';
  return `<section class="room-panel room-entry" tabindex="-1"><div class="scene-title"><div><span class="iq-kicker">PHÒNG BẮT MẠCH · VẤN CHẨN</span><h2>Hãy hỏi để hiểu bệnh cảnh</h2></div><span class="turn-counter">${current}/10</span></div><div class="consultation-layout"><div class="conversation"><div class="stage characters">${doctorCard()}${patientCard(last?.expression || 'neutral')}</div>${questionMarkup}${findingMarkup}<div class="transcript-list"><strong>Diễn tiến hội thoại</strong>${transcript.slice(-5).map(line=>`<p><b>${esc(line.speaker)}:</b> ${esc(line.text)}</p>`).join('')}</div></div>${categoryPanel()}</div></section>`;
}
function options(name, values, selected, action) {
  return `<div class="choice-list">${values.map(([id,label])=>`<button class="assessment-choice ${selected.includes(id)?'chosen':''}" data-${action}="${esc(id)}" aria-pressed="${selected.includes(id)}">${esc(label)}</button>`).join('')}</div>`;
}
function care() {
  const patterns = cases.map(c=>[c.id,c.pattern]);
  const principles = [...new Set(cases.flatMap(c=>c.principles))].map(x=>[x,x]);
  const b8cOptions = cases.map(c=>`<button class="assessment-choice ${selectedB8CCase===c.id?'chosen':''}" data-b8c-case="${c.id}" aria-pressed="${selectedB8CCase===c.id}">${esc(c.b8c.join(' · '))}</button>`).join('');
  return `<section class="room-panel room-entry" tabindex="-1"><div class="scene-title"><div><span class="iq-kicker">PHÒNG DƯỠNG TRỊ · NHẬN ĐỊNH</span><h2>Tóm tắt dữ kiện trước khi biện chứng</h2></div></div><div class="assessment-card"><p><b>Dữ kiện đã ghi nhận:</b> ${captured.size ? [...captured].map(esc).join(' · ') : 'Chưa chọn dữ kiện nào.'}</p><label class="assessment-label" for="clinical-reasoning">Biện luận ngắn · nêu dữ kiện dẫn tới nhận định</label><textarea id="clinical-reasoning" maxlength="1500" placeholder="Ví dụ: sợ lạnh, thích ấm, ăn kém, đại tiện lỏng…">${esc(reasoning)}</textarea><label class="assessment-label">Bát cương · chọn tổ hợp phù hợp nhất</label><div class="choice-list">${b8cOptions}</div><label class="assessment-label">Chọn chứng hậu phù hợp nhất</label>${options('pattern',patterns,selectedPattern?[selectedPattern]:[],'pattern')}<label class="assessment-label">Chọn nguyên tắc học thuật mô phỏng</label>${options('principle',principles,selectedPrinciple?[selectedPrinciple]:[],'principle')}<p class="safety-note">Bài tập không tạo toa thuốc/liều dùng. Trong thực tế cần tứ chẩn, đánh giá an toàn và hướng dẫn của người có chuyên môn.</p><button class="iq-primary" data-action="submit-assessment" ${!selectedPattern||!selectedPrinciple||!selectedB8CCase?'disabled':''}>Nộp nhận định <span>→</span></button></div></section>`;
}
function pharmacy() {
  const accuracy = resultScore ?? 0;
  const performance = accuracy>=85?'Vững':accuracy>=65?'Đang tiến bộ':'Cần hỏi và đối chiếu thêm';
  const expected = caseFile.keyFindings;
  const missed = expected.filter(id=>!captured.has(id));
  return `<section class="room-panel room-entry" tabindex="-1"><div class="scene-title"><div><span class="iq-kicker">PHÒNG CHẾ DƯỢC · TỔNG KẾT HỌC TẬP</span><h2>Phản hồi ca bệnh</h2></div><span class="score-seal">${accuracy}<small>/100</small></span></div><div class="result-grid"><div class="result-paper"><span class="iq-kicker">NHẬN ĐỊNH CA · BOT ${starsForScore(accuracy)} ★</span><h3>${esc(caseFile.pattern)}</h3><p>Đáp án của ca mô phỏng: ${esc(caseFile.b8c.join(' · '))}.</p><p><b>Gợi ý ghi nhận thêm:</b> ${missed.length?missed.map(esc).join(' · '):'Bạn đã chọn đủ dữ kiện trọng tâm của rubric mẫu.'}</p><p><b>Nguyên tắc:</b> ${esc(caseFile.principles[0])}. Đây là mục tiêu học tập, không phải hướng dẫn điều trị.</p></div><div class="result-feedback"><span class="iq-kicker">ĐỘ CHÍNH XÁC</span><h3>${performance} · ${accuracy}%</h3><p>${scheduledResult?.error ? 'Máy chủ chưa xác nhận kết quả: '+esc(scheduledResult.error)+'. Hãy kiểm tra trạng thái ở mục Y quán của tôi trước khi nộp lại.' : scheduledResult ? 'Máy chủ đã chấm: '+accuracy+'% · '+scheduledResult.bot_stars+' ★ · +'+scheduledResult.credits+' tín dụng.' : 'Ca tự do: điểm hiển thị để luyện tập, không tạo tín dụng. Với ca hôm nay, hãy vào Y quán của tôi để mở y quán và làm theo lịch máy chủ.'}</p><div class="result-actions"><button class="iq-primary" data-action="new-case">Luyện ca khác</button><a class="iq-secondary link-button" href="${gameHubPath('y-quan-live/')}">Về Y Quán</a></div></div></div><p class="disclaimer">Tình huống tổng hợp dùng cho đào tạo. Không dùng để tự chẩn đoán hoặc tự điều trị. Nội dung cần giảng viên YHCT thẩm định trước khi sử dụng làm học liệu chính thức.</p></section>`;
}
function render() {
  if (!signedIn()) {
    root.innerHTML = `<header class="iq-header"><a class="iq-back" href="${gameHubPath('y-quan-live/')}">← Về Y Quán</a><div><span class="iq-kicker">HIU TMC · KHU LUYỆN TẬP</span><h1>Luyện vấn chẩn Thập vấn</h1></div></header><section class="room-panel room-entry"><h2>Đăng nhập thành viên để tiếp tục</h2><p>Khu trải nghiệm dùng cùng phiên HIU TMC. Bài luyện này không lưu thông tin sức khỏe hoặc điểm vào hồ sơ người chơi.</p><a class="iq-primary link-button" href="https://hiutmc.com/?open=game-hub">Đăng nhập HIU TMC →</a></section>`;
    return;
  }
  const view = scene==='waiting' ? waiting() : scene==='pulse' ? pulse() : scene==='care' ? care() : pharmacy();
  root.innerHTML = `${header()}${view}<footer class="iq-footer">HIU Y Quán · Nội dung đào tạo mô phỏng · Không dùng để tự chẩn đoán hoặc điều trị</footer>`;
}
root.addEventListener('click', event => {
  const button = event.target.closest('button');
  if (!button || button.disabled) return;
  if (button.dataset.action==='start') return newCase();
  if (button.dataset.action==='new-case') {scene='waiting';caseFile=null;plan=[];asked=[];transcript=[];captured=new Set();selectedPattern='';selectedPrinciple='';selectedB8C=[];selectedB8CCase='';resultScore=null;return render()}
  if (button.dataset.doctorAvatar) {doctorAvatar=button.dataset.doctorAvatar;return render()}
  if (button.dataset.category) {activeCategory=button.dataset.category;return render()}
  if (button.dataset.question) {
    const question=plan.find(q=>q.id===button.dataset.question);
    if (!question || asked.some(q=>q.id===question.id)) return;
    asked.push(question);
    const answer=caseFile.answersByCategory[question.category];
    transcript.push({speaker:'Bác sĩ',text:question.text},{speaker:caseFile.patient,...answer});
    activeCategory=question.category;
    return render();
  }
  if (button.dataset.finding) {const id=button.dataset.finding;captured.has(id)?captured.delete(id):captured.add(id);return render()}
  if (button.dataset.action==='finish-interview') return go('care');
  if (button.dataset.b8cCase) {selectedB8CCase=button.dataset.b8cCase;selectedB8C=cases.find(c=>c.id===selectedB8CCase)?.b8c||[];return render()}
  if (button.dataset.pattern) {selectedPattern=button.dataset.pattern;return render()}
  if (button.dataset.principle) {selectedPrinciple=button.dataset.principle;return render()}
  if (button.dataset.action==='submit-assessment') {
    resultScore=scoreAttempt({asked,captured:[...captured],selectedB8C,selectedPattern,selectedPrinciple,caseFile});
    if (scheduledCase?.slot_no) {
      const selectedPatternFile=cases.find(item=>item.id===selectedPattern);
      window.parent.postMessage({type:'HIU_YQ_PRACTICE_SUBMIT',slot_no:scheduledCase.slot_no,answered_domains:[...new Set(asked.map(q=>domainCode[q.category]).filter(Boolean))],diagnosis:(selectedPatternFile?.pattern||selectedPattern)+' | Bát cương: '+selectedB8C.join(' · '),reasoning},location.origin);
    }
    return go('pharmacy');
  }
});
root.addEventListener('input', event => {if(event.target.id==='clinical-reasoning')reasoning=event.target.value});
window.addEventListener('message', event => {
  if (event.origin!==location.origin || event.source!==window.parent) return;
  if (event.data?.type==='HIU_YQ_PRACTICE_CONFIG') scheduledCase={slot_no:event.data.slot_no,case_profile_id:event.data.case_profile_id,case_prompt:event.data.case_prompt};
  if (event.data?.type==='HIU_YQ_PRACTICE_RESULT') {scheduledResult=event.data;resultScore=event.data.bot_score;render()}
  if (event.data?.type==='HIU_YQ_PRACTICE_ERROR') {scheduledResult={error:event.data.message};render()}
});
window.addEventListener('storage', event => {if(event.key==='hiutmc-member-session-v1')render()});
try {
  if (!root) throw new Error('Thap van root #yq-interview was not found');
  render();
  if (window.parent!==window) window.parent.postMessage({type:'HIU_YQ_PRACTICE_READY'},location.origin);
} catch (error) {
  console.error('[HIU Y Quán][Thập vấn] startup failed '+JSON.stringify({path:location.pathname,name:error?.name||'Error',message:error?.message||String(error),stack:error?.stack||''}));
  if (root) root.innerHTML='<section class="room-panel"><h1>Phòng luyện chưa khởi tạo được</h1><p>Đã ghi nhận lỗi khởi tạo. Hãy tải lại hoặc quay về Y Quán.</p><button onclick="location.reload()">Tải lại</button><a class="iq-secondary link-button" href="../">Về Y Quán</a></section>';
}
