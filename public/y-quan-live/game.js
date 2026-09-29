import { gameHubPath } from './paths.js';
import { createQuestionPlan } from './interview/engine.js';
const Y_QUAN_ROUTE_VERSION='20260929.1';
const SUPABASE_URL='https://gzmpnsrwqjpsbklyflqr.supabase.co',KEY='sb_publishable_Y4hMhXROZ-aVgWoaQ5fFKQ_ZAcXuIzG',STORE='hiutmc-member-session-v1',SESSION_LOCK='hiutmc-supabase-session-refresh-v1',ROOT=document.querySelector('#yq');
const AUTH_TIMEOUT_MS=12000,RPC_TIMEOUT_MS=15000;
const DOMAINS=[['cold','Hàn – nhiệt'],['sweat','Mồ hôi'],['pain','Đau nhức'],['bowel','Đại tiểu tiện'],['food','Ăn uống'],['chest','Ngực bụng'],['senses','Tai mắt'],['thirst','Khát, nước uống'],['history','Bệnh cũ, thuốc dùng'],['course','Nguyên nhân, diễn tiến']];
let session=null,data=null,clinics=[],doctorVisits=[],patientVisits=[],leaderboard=[],page='practice',busy=false,message='',stars={},activeChat=null,chatMessages=[],chatNotice='',activeChatRequest=null,activeCaseVisitId=null,selectedBotSlotNo=null,writeBusy=false,writeRecoveryRequired=readWriteRecoveryRequired(),loadSequence=0,chatRequestSequence=0;
const interviewDrafts=new Map();
const WRITE_RPCS=new Set(['y_quan_open_clinic_v1','y_quan_close_clinic_v1','y_quan_register_patient_v1','y_quan_submit_daily_case_v1','y_quan_submit_case_v1','y_quan_rate_doctor_v1','y_quan_send_message_v1']);
const WRITE_RECOVERY_KEY='hiutmc-y-quan-write-recovery-v1';
function readWriteRecoveryRequired(){try{return sessionStorage.getItem('hiutmc-y-quan-write-recovery-v1')==='1'}catch{return false}}
function setWriteRecoveryRequired(value){writeRecoveryRequired=value;try{if(value)sessionStorage.setItem(WRITE_RECOVERY_KEY,'1');else sessionStorage.removeItem(WRITE_RECOVERY_KEY)}catch{}}
const esc=x=>String(x??'').replace(/[&<>"']/g,c=>({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[c]));
const reportCooldown=new Map();
function reportError(code,route='unknown',status=null,rpcName=''){
  if(!['rpc_failed','dashboard_load_failed','session_refresh_failed','client_uncaught','client_unhandled_rejection'].includes(code))return;
  if(!['bootstrap','dashboard','clinic','patient','leaderboard','case','rating','background_refresh','unknown'].includes(route))route='unknown';
  const key=code+':'+route+':'+rpcName,now=Date.now();
  if(now-(reportCooldown.get(key)||0)<30000)return;
  reportCooldown.set(key,now);
  try{
    const current=getSession();
    if(!current?.accessToken)return;
    void fetch(SUPABASE_URL+'/rest/v1/rpc/garden_hub_report_error_v1',{
      method:'POST',
      headers:{apikey:KEY,Authorization:'Bearer '+current.accessToken,'Content-Type':'application/json'},
      body:JSON.stringify({p_code:code,p_message:'Y Quan client operation failed.',p_route:'/y-quan-live/',p_context:{area:'y-quan-live',operation:(route+(rpcName?':'+rpcName:'')).slice(0,100),status:status?String(status).slice(0,50):null,errorType:code}}),
      cache:'no-store',
      keepalive:true
    }).catch(()=>{});
  }catch{}
}
function routeForRpc(name){
  if(name.includes('case'))return'case';
  if(name.includes('rate'))return'rating';
  if(name.includes('clinic'))return'clinic';
  if(name.includes('patient'))return'patient';
  if(name.includes('leaderboard'))return'leaderboard';
  return'dashboard';
}

function getSession(){try{return JSON.parse(localStorage.getItem(STORE)||'null')}catch{return null}}
async function token(force=false,rejectedToken=''){
  const refresh=async()=>{
    session=getSession();
    if(!session?.accessToken)return'';
    const fresh=Number(session.expiresAt||0)-Date.now()>90000;
    if(!force&&fresh)return session.accessToken;
    // Another tab or the Eco shell may already have rotated the pair while this call waited for the lock.
    if(force&&fresh&&session.accessToken!==rejectedToken)return session.accessToken;
    try{
      const r=await fetch(SUPABASE_URL+'/auth/v1/token?grant_type=refresh_token',{method:'POST',headers:{apikey:KEY,'Content-Type':'application/json'},body:JSON.stringify({refresh_token:session.refreshToken}),cache:'no-store',signal:AbortSignal.timeout(AUTH_TIMEOUT_MS)});
      const b=await r.json().catch(()=>({}));
      if(!r.ok||!b.access_token)throw Error('refresh_failed');
      session={...session,accessToken:b.access_token,refreshToken:b.refresh_token,expiresAt:Number(b.expires_at)*1000};
      localStorage.setItem(STORE,JSON.stringify(session));
      return session.accessToken;
    }catch{
      reportError('session_refresh_failed','bootstrap');
      throw Error('Không thể làm mới phiên HIU TMC. Hãy thử lại khi kết nối ổn định.');
    }
  };
  const hostname=location.hostname||'',onEcoOrigin=hostname==='hiutmc.com'||hostname.endsWith('.hiutmc.com');
  if(onEcoOrigin&&navigator.locks?.request){let started=false;try{return await navigator.locks.request(SESSION_LOCK,()=>{started=true;return refresh()})}catch(error){if(started)throw error}}
  return refresh();
}
async function rpc(name,body={},routeOverride=''){
  const isWrite=WRITE_RPCS.has(name);
  if(isWrite&&writeRecoveryRequired)throw Object.assign(Error('Thao tác ghi trước chưa xác định kết quả. Hãy tải lại trạng thái máy chủ trước khi gửi thao tác tiếp.'),{code:'WRITE_RECOVERY_REQUIRED'});
  if(isWrite&&writeBusy)throw Object.assign(Error('Đang xử lý một thao tác ghi khác. Vui lòng đợi thao tác hiện tại hoàn tất.'),{code:'WRITE_IN_FLIGHT'});
  if(isWrite)writeBusy=true;
  let requestStarted=false,status=null,kind='';
  const requestName=isWrite?'y_quan_write_idempotent_v1':name;
  // The idempotency key is created once so a retry after HTTP 401 can never double-apply a write.
  const requestBody=isWrite?{p_idempotency_key:crypto.randomUUID(),p_operation:name,p_payload:body}:body;
  try{
    let t=await token();
    if(!t)throw Error('Hãy đăng nhập Game Hub bằng tài khoản HIU TMC để đồng bộ tiến trình.');
    for(let attempt=0;attempt<2;attempt++){
      requestStarted=true;status=null;kind='';
      try{
        const r=await fetch(SUPABASE_URL+'/rest/v1/rpc/'+requestName,{method:'POST',headers:{apikey:KEY,Authorization:'Bearer '+t,'Content-Type':'application/json'},body:JSON.stringify(requestBody),cache:'no-store',signal:AbortSignal.timeout(RPC_TIMEOUT_MS)});
        status=r.status;
        const x=await r.json().catch(()=>({}));
        if(r.ok)return x;
        if(r.status===401&&attempt===0){const next=await token(true,t);if(next){t=next;continue}}
        // Reads are safe to repeat once on a transient server error; writes are never repeated here.
        if(!isWrite&&r.status>=500&&attempt===0){await new Promise(resolve=>setTimeout(resolve,700));continue}
        throw Error(x.message||x.details||'Máy chủ chưa xử lý được thao tác.');
      }catch(e){
        if(e?.name==='TimeoutError'||e?.name==='AbortError')kind='timeout';
        else if(e instanceof TypeError)kind='network';
        if(!isWrite&&attempt===0&&status===null&&kind){await new Promise(resolve=>setTimeout(resolve,700));continue}
        throw e;
      }
    }
    throw Error('Máy chủ chưa xử lý được thao tác.');
  }catch(e){
    if(isWrite&&requestStarted&&(status>=500||status===null&&(e?.name==='TimeoutError'||e?.name==='AbortError'||e instanceof TypeError))){
      e.code='RPC_OUTCOME_UNKNOWN';
      e.rpcName=name;
      setWriteRecoveryRequired(true);
    }
    if(requestStarted)reportError('rpc_failed',routeOverride||routeForRpc(name),status||kind||'unknown',name);
    throw e;
  }finally{
    if(isWrite)writeBusy=false;
  }
}
async function load(){
  const request=++loadSequence;
  try{
    const names=['y_quan_dashboard_v1','y_quan_clinics_v1','y_quan_doctor_visits_v1','y_quan_patient_visits_v1','y_quan_leaderboard_v1'];
    const settled=await Promise.allSettled([rpc(names[0]),rpc(names[1]),rpc(names[2]),rpc(names[3]),rpc(names[4],{p_limit:20})]);
    if(request!==loadSequence)return false;
    const value=index=>settled[index].status==='fulfilled'?settled[index].value:null;
    const failed=settled.map((item,index)=>item.status==='rejected'?index:-1).filter(index=>index>=0);
    if(failed.length===settled.length){
      const first=settled[0].reason;
      message=first?.message||'Không tải được dữ liệu Y Quán. Hãy thử lại.';
      render();
      return false;
    }
    const dash=value(0);
    if(dash)data=dash&&typeof dash==='object'&&!Array.isArray(dash)?dash:{};else if(!data)data={};
    if(value(1))clinics=Array.isArray(value(1))?value(1):[];
    if(value(2))doctorVisits=Array.isArray(value(2))?value(2):[];
    if(value(3))patientVisits=Array.isArray(value(3))?value(3):[];
    if(value(4))leaderboard=Array.isArray(value(4))?value(4):[];
    const labels=['bảng điều khiển','danh sách y quán','lượt khám của bác sĩ','lượt khám của bạn','bảng uy tín'];
    message=failed.length?'Chưa tải được: '+failed.map(index=>labels[index]).join(', ')+'. Phần còn lại vẫn dùng được.':'';
    if(!failed.length)setWriteRecoveryRequired(false);
    render();
    return !failed.length;
  }catch(e){
    if(request!==loadSequence)return false;
    message=e.message;
    render();
    return false;
  }
}
async function reconcileWrite(){message='Đang tải lại trạng thái mới nhất từ máy chủ…';render();const ok=await load();message=ok?'Thao tác trước có thể đã được máy chủ xử lý. Đã tải trạng thái mới nhất; hãy kiểm tra kết quả trước khi thao tác tiếp.':'Chưa xác minh được trạng thái máy chủ. Không gửi lại thao tác; hãy thử tải lại khi kết nối ổn định.';render();return ok}
function botRating(score){const n=score>=90?5:score>=80?4:score>=65?3:score>=50?2:1;return n+' ★'}
function starsView(visit){return visit.status==='completed'&&!visit.stars?'<div class="stars" data-visit="'+visit.visit_id+'">'+[1,2,3,4,5].map(n=>'<button data-star="'+n+'" aria-label="'+n+' sao">★</button>').join('')+' <button data-action="rate" data-id="'+visit.visit_id+'">Gửi đánh giá</button></div>':visit.stars?'<span class="pill">Đã đánh giá '+visit.stars+'/5</span>':''}
const art=name=>gameHubPath('y-quan-live/art/'+name+'.webp');
function heroHTML(){
  const d=data||{},open=Boolean(d.doctor?.is_open);
  return '<header class="yq-hero"><div class="yq-hero-main"><a class="yq-back" href="'+gameHubPath('')+'">← Quay lại Game Hub</a><h1 class="yq-title"><img src="'+art('banner')+'" width="900" height="198" alt="HIU Y Quán · Chăm sóc bằng y đức, an lành từ thảo dược"></h1><p class="yq-motto">Nhỏ một thảo dược, lớn một niềm tin.</p><ul class="yq-stats" aria-label="Chỉ số bác sĩ"><li><b>'+Number(d.credits||0)+'</b><span>Tín dụng</span></li><li><b>'+Number(d.experience||0)+'</b><span>Kinh nghiệm</span></li><li><b>'+esc(d.average_stars??'—')+'</b><span>Điểm sao</span></li><li><b class="'+(open?'on':'off')+'">'+(open?'Đang trực':'Đang vắng')+'</b><span>Y quán</span></li></ul></div><img class="yq-shopfront" src="'+art('shopfront')+'" width="800" height="497" alt="Mặt tiền HIU Y Quán"></header>';
}
function navHTML(){
  const items=[['practice','脈','Luyện Thập vấn'],['doctor','藥','Y quán của tôi'],['patient','診','Đi khám y quán khác'],['rank','★','Uy tín bác sĩ']];
  return '<nav class="tabs yq-tabs" aria-label="Khu vực Y Quán">'+items.map(([id,glyph,label])=>'<button data-page="'+id+'" class="'+(page===id?'active':'')+'" aria-current="'+(page===id?'page':'false')+'"><i aria-hidden="true">'+glyph+'</i><span>'+label+'</span></button>').join('')+'</nav>';
}
function journeyHTML(){
  const visits=Array.isArray(doctorVisits)?doctorVisits:[];
  const current=activeCaseVisitId||page==='practice'?3:visits.some(v=>v.status!=='completed')?2:visits.some(v=>v.status==='completed'&&!v.stars)?4:1;
  const steps=[['Chờ khách','shopfront','Bác sĩ trực, kiểm tra các khu vực'],['Có khách','chan-mach','Tiếp đón và chẩn mạch'],['Nhận định','che-duoc','Tổng hợp dữ kiện, biện chứng'],['Chăm sóc','duong-tri','Theo dõi và nhận đánh giá']];
  return '<ol class="yq-journey" aria-label="Hành trình chăm sóc sức khỏe">'+steps.map(([title,image,caption],i)=>'<li class="'+(i+1===current?'now':i+1<current?'done':'')+'"><img src="'+art(image)+'" alt="" loading="lazy"><span class="step-no">'+(i+1)+'</span><b>'+title+'</b><small>'+caption+'</small></li>').join('')+'</ol>';
}
function roomsHTML(){
  const d=data||{};
  const rooms=[
    ['chan-mach','Chẩn mạch','Vọng · Văn · Vấn · Thiết','Luyện vấn chẩn Thập vấn với ca mô phỏng của hôm nay.','practice','Vào phòng Chẩn mạch'],
    ['duong-tri','Dưỡng trị','Nghỉ ngơi · Phục hồi · An yên','Lượt khám thật: nhắn tin, theo dõi và nhận đánh giá của bệnh nhân.','patient','Xem lượt khám'],
    ['che-duoc','Chế dược','Chọn lọc · Sắc nấu · Tinh hoa','Tín dụng '+Number(d.credits||0)+' · Kinh nghiệm '+Number(d.experience||0)+' · so tài cùng các bác sĩ khác.','rank','Xem bảng uy tín']
  ];
  return '<section class="yq-rooms" aria-label="Ba phòng của Y Quán">'+rooms.map(([image,title,sub,text,target,action])=>'<article class="room-card"><img src="'+art(image)+'" width="1200" height="900" alt="Phòng '+title+' của HIU Y Quán" loading="lazy"><div class="room-sign"><h3>'+title+'</h3><small>'+sub+'</small></div><p>'+text+'</p><button class="secondary" data-page="'+target+'">'+action+'</button></article>').join('')+'</section>';
}
function doctorPickerHTML(){
  const d=data||{},profile=d.doctor;
  const cards=[['male','Bác sĩ nam',['Thân thiện','Tận tâm','Giỏi chuyên môn','Luôn vì bệnh nhân'],'“Y đức là trái tim của người thầy thuốc”'],['female','Bác sĩ nữ',['Nhẹ nhàng','Chu đáo','Giỏi lắng nghe','Lan tỏa sức khỏe'],'“Sức khỏe tốt hơn bắt đầu từ sự thấu hiểu”']];
  return '<section class="panel yq-panel"><div class="bar"><div><h2>Chọn bác sĩ trực</h2><p>5 ca mô phỏng mỗi ngày · cách nhau tối thiểu 2 giờ · giờ máy chủ</p></div><span class="pill">'+(profile?.is_open?'Bác sĩ đang trực':'Đang vắng')+'</span></div><div class="doctor-cards">'+cards.map(([id,label,traits,quote])=>'<button class="doctor-card '+(profile?.doctor_avatar_id===id?'selected':'')+'" data-action="open" data-avatar="'+id+'" aria-pressed="'+(profile?.doctor_avatar_id===id)+'"><img src="'+art('doctor-'+id)+'" width="300" height="'+(id==='male'?'516':'603')+'" alt="'+label+'"><span><b>'+label+'</b><ul>'+traits.map(t=>'<li>'+t+'</li>').join('')+'</ul><em>'+quote+'</em></span></button>').join('')+'</div><div class="bar"><button data-action="close">Đóng y quán</button><p class="muted">Ngày '+esc(d.local_day||'—')+' · Tín dụng bác sĩ độc lập với Gia Viên Dược Thảo.</p></div></section>';
}
function practiceHTML(){const welcomeKey='hiu-yquan-practice-welcome-v1';let welcome='';const slot=(Array.isArray(data?.slots)?data.slots:[]).find(s=>s.status!=='completed'&&!s.visit_id&&Number(s.slot_no)===Number(selectedBotSlotNo))||(Array.isArray(data?.slots)?data.slots:[]).find(s=>s.status!=='completed'&&!s.visit_id);const interviewUrl=new URL(gameHubPath('y-quan-live/interview/'),location.origin);interviewUrl.searchParams.set('embed','1');interviewUrl.searchParams.set('v',Y_QUAN_ROUTE_VERSION);if(slot)interviewUrl.searchParams.set('slot',slot.slot_no);let src=interviewUrl.pathname+interviewUrl.search;try{if(!localStorage.getItem(welcomeKey)){welcome='<div class="practice-welcome" role="dialog" aria-modal="true"><section><h2>Chào mừng bác sĩ đến khu Luyện Thập vấn</h2><p>Mặc định, Y Quán mở phần luyện vấn chẩn: mỗi ca hỏi đúng 10 câu, chọn ngẫu nhiên từ ngân hàng 220 câu và phân đều 10 nội dung Thập vấn. Bot trả phản hồi độ chính xác (%) và sao theo kết quả nhận định.</p><p>Mỗi ngày có 5 ca mô phỏng theo lịch máy chủ, lấy từ 13 bệnh cảnh khác nhau, cách nhau tối thiểu 2 giờ. Bác sĩ có thể nhận tín dụng theo ca; bệnh nhân là người chơi thật có thể chấm sao sau lượt khám hoàn tất.</p><p class="muted">Nội dung phục vụ học tập, cần giảng viên YHCT thẩm định trước khi dùng trong đào tạo chính thức.</p><button data-action="ack-practice-welcome">Đã hiểu, bắt đầu luyện</button></section></div>';localStorage.setItem(welcomeKey,'1')}}catch{}return '<section class="practice-launch"><img class="launch-art" src="'+art('chan-mach')+'" width="1200" height="900" alt="Phòng Chẩn mạch của HIU Y Quán"><div class="launch-copy"><span class="pill">Phòng Chẩn mạch · Vọng · Văn · Vấn · Thiết</span><h1>Luyện vấn chẩn Thập vấn</h1><p>10 câu mỗi ca · 220 câu hỏi · 10 nội dung · 13 bệnh cảnh</p></div></section><iframe class="practice-frame" src="'+src+'" title="Luyện vấn chẩn Thập vấn"></iframe>'+welcome}
function render(){if(!session?.accessToken){ROOT.innerHTML='<section class="panel"><h1>HIU Y Quán</h1><p>Cần đăng nhập thành viên để lưu ca và tín dụng lên máy chủ.</p><a href="https://hiutmc.com/?open=game-hub">Đăng nhập HIU TMC →</a></section>';return}
ROOT.innerHTML=heroHTML()+navHTML()+(message?'<p class="error" role="alert">'+esc(message)+' <button class="secondary" data-action="reload">Tải lại</button></p>':'')+journeyHTML()+(page==='practice'?practiceHTML():page==='doctor'?doctorHTML():page==='patient'?patientHTML():rankHTML())+(activeChat?chatHTML():'');if(page==='practice'){const frame=ROOT.querySelector('.practice-frame');frame?.addEventListener('load',()=>{const slot=(Array.isArray(data?.slots)?data.slots:[]).find(s=>s.status!=='completed'&&!s.visit_id&&Number(s.slot_no)===Number(selectedBotSlotNo))||(Array.isArray(data?.slots)?data.slots:[]).find(s=>s.status!=='completed'&&!s.visit_id);frame.contentWindow?.postMessage({type:'HIU_YQ_PRACTICE_CONFIG',slot_no:slot?.slot_no||null,case_profile_id:slot?.case_profile_id||null,case_prompt:slot?.case_prompt||null},location.origin)})}
}
function doctorHTML(){
  const d=data||{},profile=d.doctor,activeVisit=doctorVisits.find(v=>v.visit_id===activeCaseVisitId);
  const slots=(d.slots||[]).map(s=>`<div class="slot"><div><b>Ca ${s.slot_no} · ${new Date(s.starts_at).toLocaleTimeString('vi-VN',{hour:'2-digit',minute:'2-digit',timeZone:'Asia/Ho_Chi_Minh'})}</b><small>${esc(s.status)} · bot ${s.bot_score}% · ${botRating(s.bot_score)} · +${s.experience} XP</small></div>${s.status==='completed'?'<span class="pill">Đã xong</span>':`<button data-action="case" data-slot="${s.slot_no}">Làm ca</button>`}</div>`).join('');
  const visits=doctorVisits.map(v=>`<div class="visit">${v.patient_avatar_url?`<img class="profile-avatar" src="${esc(v.patient_avatar_url)}" alt="Ảnh đại diện bệnh nhân">`:''}<div><b>${esc(v.patient_name)}</b><small>Ca ${v.slot_no} · ${esc(v.status)} · bot ${v.bot_score}/100</small></div><div class="visit-actions"><button data-action="chat" data-id="${v.visit_id}">Nhắn bệnh nhân</button>${v.status==='completed'?`<span class="pill">${v.stars?v.stars+' sao':'Chờ bệnh nhân chấm'}</span>`:`<button data-action="finish-visit" data-id="${v.visit_id}">Mở vấn chẩn</button>`}</div></div>`).join('');
  return `${roomsHTML()}${doctorPickerHTML()}<section class="panel"><h2>Ca mô phỏng hôm nay</h2><p class="warn">Mở “Làm ca” để vào phòng Thập vấn: bác sĩ hỏi đủ 10 nội dung, ghi nhận câu trả lời, chẩn đoán rồi nộp bot chấm.</p>${slots||'<p>Chọn bác sĩ để mở y quán và tạo lịch hôm nay.</p>'}</section><section class="panel"><h2>Bệnh nhân đã đăng ký</h2><p>Hỏi và nhận trả lời đủ 10 mục qua chat, xác nhận từng mục rồi mới gửi nhận định; bệnh nhân sẽ đánh giá lượt khám sau khi hoàn tất.</p>${visits||'<p>Chưa có bệnh nhân đăng ký. Khi có lượt khám, bác sĩ có thể mở chat ngay tại đây.</p>'}</section>${activeVisit&&activeVisit.status!=='completed'?caseForm(activeVisit.visit_id,activeVisit.slot_no):''}`;
}
function draftFor(visitId){let draft=interviewDrafts.get(visitId);if(!draft){try{draft=JSON.parse(sessionStorage.getItem('hiu-yquan-intake-'+visitId)||'null')}catch{}if(!draft||!Array.isArray(draft.plan)||!Array.isArray(draft.answered))draft={plan:createQuestionPlan(crypto.getRandomValues(new Uint32Array(1))[0]),answered:[]};interviewDrafts.set(visitId,draft)}return draft}
function saveDraft(visitId,draft){interviewDrafts.set(visitId,draft);try{sessionStorage.setItem('hiu-yquan-intake-'+visitId,JSON.stringify(draft))}catch{}}
function caseForm(visitId,slotNo){
  const draft=draftFor(visitId),codeByCategory={'Hàn nhiệt':'cold','Mồ hôi':'sweat','Đầu thân':'pain','Đại tiểu tiện':'bowel','Ẩm thực':'food','Hung sườn bụng':'chest','Tai nghe':'senses','Khát':'thirst','Bệnh sử và thuốc':'history','Nguyên nhân và diễn tiến':'course'};
  const promptByCode=new Map(draft.plan.map(q=>[codeByCategory[q.category],q.text]));
  return `<section class="panel consultation-steps"><h2>Vấn chẩn với bệnh nhân · Ca ${esc(slotNo)}</h2><p>Gửi từng câu hỏi qua chat. Sau khi bệnh nhân trả lời, bác sĩ xác nhận mục đó đã được khai thác. Tiến độ được giữ khi chuyển qua lại giữa chat và biểu mẫu.</p><h3>1 · Hỏi và nhận trả lời đủ 10 nội dung Thập vấn</h3><div class="domain-grid">${DOMAINS.map(([code,label])=>{const done=draft.answered.includes(code);return `<div class="domain-step"><b>${label}</b><p>${esc(promptByCode.get(code)||'')}</p><button type="button" data-action="ask-domain" data-visit="${esc(visitId)}" data-domain="${code}" data-question="${esc(promptByCode.get(code)||'')}">Gửi câu hỏi cho bệnh nhân</button><label><input type="checkbox" data-domain="${code}" data-visit="${esc(visitId)}" ${done?'checked':''}> Đã nhận câu trả lời</label></div>`}).join('')}</div><p class="muted">Đã xác nhận ${draft.answered.length}/10 mục.</p><h3>2 · Chẩn đoán và biện luận</h3><form data-form="case" data-id="${esc(visitId)}" data-slot="${esc(slotNo)}"><label>Nhận định thể bệnh<input name="diagnosis" required maxlength="300"></label><label>Biện luận<textarea name="reasoning" maxlength="1500"></textarea></label><p class="warn">Nộp nhận định sau khi hỏi đủ Thập vấn. Bệnh nhân sẽ được mời đánh giá lượt khám.</p><button ${draft.answered.length<10?'disabled':''}>Nộp nhận định để bệnh nhân đánh giá</button></form></section>`;
}
function patientHTML(){return '<section class="panel"><h1>Đăng ký khám tại y quán thành viên</h1><p>Ảnh bệnh nhân là hồ sơ của người chơi đóng vai bệnh nhân. Hai avatar bác sĩ chỉ dành cho chủ y quán chọn lúc khai trương.</p>'+clinics.map(c=>'<div class="clinic"><div><b>'+esc(c.display_name)+'</b><small>'+(c.is_open?'Đang trực':'Vừa hoạt động')+' · '+esc(c.doctor_avatar_id==='female'?'Bác sĩ nữ':'Bác sĩ nam')+' · '+c.total_credits+' tín dụng · '+(c.average_stars??'chưa có sao')+'</small></div><button '+(!c.is_open?'disabled':'')+' data-action="register" data-id="'+c.doctor_id+'">Đăng ký khám</button></div>').join('')+(clinics.length?'':'<p>Hiện chưa có y quán đang trực.</p>')+'</section><section class="panel"><h2>Lượt khám của tôi</h2><p>Trả lời từng câu hỏi của bác sĩ trong chat. Sau khi bác sĩ hoàn tất nhận định, bạn có thể đánh giá lượt khám.</p>'+patientVisits.map(v=>'<div class="visit"><div><b>'+esc(v.doctor_name)+'</b><small>Ca '+v.slot_no+' · '+esc(v.status)+' · bot '+v.bot_score+'/100</small></div><div class="visit-actions"><button data-action="chat" data-id="'+v.visit_id+'">Chat với bác sĩ</button>'+starsView(v)+'</div></div>').join('')+(patientVisits.length?'':'<p>Chưa có lịch khám. Đăng ký tại một y quán đang trực để mở chat với bác sĩ.</p>')+'</section>'}
function chatHTML(){return '<section class="panel chat-panel" id="chat-panel"><div class="bar"><div><h2>Chat với '+esc(activeChat.otherName)+'</h2><p class="muted">Trao đổi trong lượt khám này · tin nhắn cập nhật tự động</p></div><button class="secondary" data-action="close-chat">Đóng chat</button></div><div class="chat-messages" id="chat-messages" aria-live="polite">'+chatMessagesHTML()+'</div><p id="chat-status" class="chat-status" role="status">'+esc(chatNotice)+'</p><form data-form="chat" data-visit="'+esc(activeChat.visitId)+'"><label for="chat-input">Tin nhắn</label><div class="chat-compose"><textarea id="chat-input" name="body" maxlength="1000" rows="2" required placeholder="Nhập tin nhắn cho '+esc(activeChat.otherName)+'…"></textarea><button>Gửi</button></div></form></section>'}
function chatMessagesHTML(){return chatMessages.length?chatMessages.map(m=>'<article class="chat-message '+(m.is_mine?'mine':'')+'"><b>'+esc(m.sender_name)+'</b><p>'+esc(m.body)+'</p><time>'+new Date(m.created_at).toLocaleString('vi-VN',{timeZone:'Asia/Ho_Chi_Minh',hour:'2-digit',minute:'2-digit',day:'2-digit',month:'2-digit'})+'</time></article>').join(''):'<p class="chat-empty">Chưa có tin nhắn. Hãy gửi lời chào để bắt đầu trao đổi.</p>'}
async function refreshChat(quiet=false){const chat=activeChat;if(!chat||activeChatRequest===chat.visitId)return false;const request=++chatRequestSequence;activeChatRequest=chat.visitId;try{const messages=await rpc('y_quan_visit_messages_v1',{p_visit_id:chat.visitId},'patient');if(request!==chatRequestSequence||activeChat?.visitId!==chat.visitId)return false;chatMessages=messages;chatNotice='';const box=ROOT.querySelector('#chat-messages'),status=ROOT.querySelector('#chat-status');if(box){box.innerHTML=chatMessagesHTML();box.scrollTop=box.scrollHeight}if(status)status.textContent='';return true}catch(e){if(request===chatRequestSequence&&activeChat?.visitId===chat.visitId&&!quiet){chatNotice=e.message;const status=ROOT.querySelector('#chat-status');if(status)status.textContent=chatNotice}return false}finally{if(request===chatRequestSequence&&activeChatRequest===chat.visitId)activeChatRequest=null}}
async function openChat(visit){chatRequestSequence++;activeChat={visitId:visit.visit_id,otherName:page==='doctor'?visit.patient_name:visit.doctor_name};activeChatRequest=null;chatMessages=[];chatNotice='';await refreshChat();render();const box=ROOT.querySelector('#chat-messages');if(box)box.scrollTop=box.scrollHeight}
function rankHTML(){return '<section class="panel"><h1>Bảng uy tín bác sĩ</h1><p>Xếp theo tổng tín dụng Y Quán và kinh nghiệm. Bệnh nhân là người chơi trực tiếp đánh giá bác sĩ sau lượt khám.</p>'+leaderboard.map(r=>'<div class="row"><span><b>#'+r.rank_no+' '+esc(r.display_name)+'</b><small>'+esc(r.doctor_avatar_id==='female'?'Bác sĩ nữ':'Bác sĩ nam')+' · '+r.experience+' XP · '+(r.average_stars||'—')+' ★ ('+r.rating_count+')</small></span><b>'+r.credits+' tín dụng</b></div>').join('')+'</section>'}
let practiceSubmitBusy=false;window.addEventListener('message',async event=>{if(event.origin!==location.origin||event.source!==ROOT.querySelector('.practice-frame')?.contentWindow)return;const msg=event.data||{};if(msg.type!=='HIU_YQ_PRACTICE_SUBMIT'||practiceSubmitBusy)return;const slot=(Array.isArray(data?.slots)?data.slots:[]).find(s=>s.status!=='completed'&&!s.visit_id&&Number(s.slot_no)===Number(msg.slot_no));if(!slot)return;practiceSubmitBusy=true;try{const result=await rpc('y_quan_submit_daily_case_v1',{p_slot_no:Number(slot.slot_no),p_answered_domains:msg.answered_domains,p_diagnosis:String(msg.diagnosis||''),p_reasoning:String(msg.reasoning||'')});data=await rpc('y_quan_dashboard_v1');event.source.postMessage({type:'HIU_YQ_PRACTICE_RESULT',bot_score:result.bot_score,bot_stars:result.bot_stars,credits:result.credits,experience:result.experience,already_completed:result.already_completed},location.origin);const next=(Array.isArray(data?.slots)?data.slots:[]).find(s=>s.status!=='completed'&&!s.visit_id);selectedBotSlotNo=next?.slot_no||null;event.source.postMessage({type:'HIU_YQ_PRACTICE_CONFIG',slot_no:next?.slot_no||null,case_profile_id:next?.case_profile_id||null,case_prompt:next?.case_prompt||null},location.origin)}catch(error){event.source.postMessage({type:'HIU_YQ_PRACTICE_ERROR',message:error.message||'Không gửi được ca lên máy chủ.'},location.origin)}finally{practiceSubmitBusy=false}});
ROOT.addEventListener('click',async e=>{const b=e.target.closest('button');if(!b)return;try{if(b.dataset.action==='reload'){message='';await load();return}if(b.dataset.action==='ack-practice-welcome'){document.querySelector('.practice-welcome')?.remove();return}if(b.dataset.page){page=b.dataset.page;activeChat=null;render();return}if(b.dataset.star){stars[b.closest('.stars').dataset.visit]=Number(b.dataset.star);b.closest('.stars').querySelectorAll('[data-star]').forEach(x=>x.style.opacity=Number(x.dataset.star)<=stars[b.closest('.stars').dataset.visit]?'1':'.35');return}if(b.dataset.action==='chat'){const visit=(page==='doctor'?doctorVisits:patientVisits).find(v=>v.visit_id===b.dataset.id);if(visit)await openChat(visit);return}if(b.dataset.action==='close-chat'){activeChat=null;chatMessages=[];render();return}if(b.dataset.action==='ask-domain'){const visit=doctorVisits.find(v=>v.visit_id===b.dataset.visit);if(!visit)throw Error('Không tìm thấy lượt khám.');await rpc('y_quan_send_message_v1',{p_visit_id:visit.visit_id,p_body:b.dataset.question},'patient');message='Đã gửi câu hỏi trong lượt khám. Chờ bệnh nhân trả lời rồi xác nhận mục này.';await openChat(visit);return}if(b.dataset.action==='open')await rpc('y_quan_open_clinic_v1',{p_doctor_avatar_id:b.dataset.avatar});if(b.dataset.action==='close')await rpc('y_quan_close_clinic_v1');if(b.dataset.action==='register'){const x=await rpc('y_quan_register_patient_v1',{p_doctor_id:b.dataset.id});message='Đã gửi đăng ký khám cho '+new Date(x.scheduled_at).toLocaleTimeString('vi-VN',{hour:'2-digit',minute:'2-digit',timeZone:'Asia/Ho_Chi_Minh'})+'.'}if(b.dataset.action==='case'){selectedBotSlotNo=Number(b.dataset.slot);page='practice';activeChat=null;render();return}if(b.dataset.action==='finish-visit'){activeCaseVisitId=b.dataset.id;render();return}if(b.dataset.action==='rate'){const n=stars[b.dataset.id];if(!n)throw Error('Chọn số sao trước khi gửi.');await rpc('y_quan_rate_doctor_v1',{p_visit_id:b.dataset.id,p_stars:n});message='Đã gửi đánh giá và cộng tín dụng cho bác sĩ.'}await load()}catch(err){if(err.code==='RPC_OUTCOME_UNKNOWN')await reconcileWrite();else{message=err.message;render()}}});
ROOT.addEventListener('submit',async e=>{const f=e.target.closest('form[data-form="case"]');if(!f)return;e.preventDefault();const fd=new FormData(f),domains=f.dataset.id?draftFor(f.dataset.id).answered:fd.getAll('domain').map(String),diagnosis=String(fd.get('diagnosis')||''),reasoning=String(fd.get('reasoning')||'');try{if(f.dataset.id)await rpc('y_quan_submit_case_v1',{p_visit_id:f.dataset.id,p_answered_domains:domains,p_diagnosis:diagnosis,p_reasoning:reasoning});else await rpc('y_quan_submit_daily_case_v1',{p_slot_no:Number(f.dataset.slot),p_answered_domains:domains,p_diagnosis:diagnosis,p_reasoning:reasoning});message=f.dataset.id?'Đã nộp nhận định. Bệnh nhân có thể đánh giá lượt khám.':'Ca đã được máy chủ chấm và lưu.';await load()}catch(err){if(err.code==='RPC_OUTCOME_UNKNOWN')await reconcileWrite();else{message=err.message;render()}}});
ROOT.addEventListener('submit',async e=>{const f=e.target.closest('form[data-form="chat"]');if(!f)return;e.preventDefault();const input=f.elements.body,body=String(input.value||'').trim();if(!body)return;const submit=f.querySelector('button[type="submit"],button:not([type])');if(submit)submit.disabled=true;try{await rpc('y_quan_send_message_v1',{p_visit_id:f.dataset.visit,p_body:body},'patient');input.value='';await refreshChat();const box=ROOT.querySelector('#chat-messages');if(box)box.scrollTop=box.scrollHeight}catch(err){if(err.code==='RPC_OUTCOME_UNKNOWN'){const refreshed=await refreshChat(true);if(refreshed){setWriteRecoveryRequired(false);const posted=chatMessages.some(m=>m.is_mine&&m.body===body);chatNotice=posted?'Máy chủ đã nhận tin nhắn. Danh sách chat đã được đồng bộ.':'Đã tải lại chat nhưng chưa thấy tin nhắn; không gửi lại ngay, hãy kiểm tra trạng thái trước.'}else chatNotice='Kết quả gửi chưa xác định và chưa tải lại được chat. Không gửi lại; thử đồng bộ khi kết nối ổn định.'}else chatNotice=err.message;const status=ROOT.querySelector('#chat-status');if(status)status.textContent=chatNotice}finally{if(submit)submit.disabled=false}});
window.addEventListener('error',()=>reportError('client_uncaught','unknown'));
window.addEventListener('unhandledrejection',()=>reportError('client_unhandled_rejection','unknown'));
try{session=getSession();if(session?.accessToken)await load();else render()}catch(e){reportError('dashboard_load_failed','bootstrap');message=e.message;render()}setInterval(()=>{if(writeBusy)return;if(writeRecoveryRequired){if(activeChat)refreshChat(true).then(ok=>{if(ok)setWriteRecoveryRequired(false)});else void load();return}if(activeChat)refreshChat(true)},5000);

ROOT.addEventListener('change',e=>{const input=e.target.closest('input[type=checkbox][data-domain]');if(!input)return;const id=input.dataset.visit,draft=draftFor(id),domain=input.dataset.domain;draft.answered=input.checked?[...new Set([...draft.answered,domain])]:draft.answered.filter(value=>value!==domain);saveDraft(id,draft);const form=ROOT.querySelector('form[data-form=case][data-id="'+CSS.escape(id)+'"]');const button=form?.querySelector('button[type=submit],button:not([type])');if(button)button.disabled=draft.answered.length<10;const progress=ROOT.querySelector('.consultation-steps .muted');if(progress)progress.textContent='Đã xác nhận '+draft.answered.length+'/10 mục. Cần hỏi và nhận câu trả lời trước khi chuyển sang chẩn đoán.'});
