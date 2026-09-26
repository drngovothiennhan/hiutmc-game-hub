const URL='https://gzmpnsrwqjpsbklyflqr.supabase.co',KEY='sb_publishable_Y4hMhXROZ-aVgWoaQ5fFKQ_ZAcXuIzG',STORE='hiutmc-game-hub-session-v1',ROOT=document.querySelector('#yq');
const DOMAINS=[['cold','Hàn – nhiệt'],['sweat','Mồ hôi'],['pain','Đau nhức'],['bowel','Đại tiểu tiện'],['food','Ăn uống'],['chest','Ngực bụng'],['senses','Tai mắt'],['thirst','Khát, nước uống'],['history','Bệnh cũ, thuốc dùng'],['course','Nguyên nhân, diễn tiến']];
let session=null,data=null,clinics=[],doctorVisits=[],patientVisits=[],leaderboard=[],page='doctor',busy=false,message='',stars={};
const esc=x=>String(x??'').replace(/[&<>"']/g,c=>({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[c]));
const reportCooldown=new Map();
function reportError(code,route='unknown'){
  if(!['rpc_failed','dashboard_load_failed','session_refresh_failed','client_uncaught','client_unhandled_rejection'].includes(code))return;
  if(!['bootstrap','dashboard','clinic','patient','leaderboard','case','rating','background_refresh','unknown'].includes(route))route='unknown';
  const key=code+':'+route,now=Date.now();
  if(now-(reportCooldown.get(key)||0)<30000)return;
  reportCooldown.set(key,now);
  try{
    const current=getSession();
    if(!current?.accessToken)return;
    void fetch(URL+'/rest/v1/rpc/game_hub_record_error_v1',{
      method:'POST',
      headers:{apikey:KEY,Authorization:'Bearer '+current.accessToken,'Content-Type':'application/json'},
      body:JSON.stringify({p_error_code:code,p_route_key:route}),
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
async function token(){
  session=getSession();
  if(!session?.accessToken)return'';
  if(Number(session.expiresAt||0)-Date.now()>90000)return session.accessToken;
  try{
    const r=await fetch(URL+'/auth/v1/token?grant_type=refresh_token',{method:'POST',headers:{apikey:KEY,'Content-Type':'application/json'},body:JSON.stringify({refresh_token:session.refreshToken})});
    const b=await r.json().catch(()=>({}));
    if(!r.ok||!b.access_token)throw Error('refresh_failed');
    session={...session,accessToken:b.access_token,refreshToken:b.refresh_token,expiresAt:Number(b.expires_at)*1000};
    localStorage.setItem(STORE,JSON.stringify(session));
    return session.accessToken;
  }catch{
    reportError('session_refresh_failed','bootstrap');
    throw Error('Phiên đăng nhập hết hạn. Hãy mở Game Hub lại từ HIU TMC.');
  }
}
async function rpc(name,body={},routeOverride=''){
  let requestStarted=false;
  try{
    const t=await token();
    if(!t)throw Error('Hãy đăng nhập Game Hub bằng tài khoản HIU TMC để đồng bộ tiến trình.');
    requestStarted=true;
    const r=await fetch(URL+'/rest/v1/rpc/'+name,{method:'POST',headers:{apikey:KEY,Authorization:'Bearer '+t,'Content-Type':'application/json'},body:JSON.stringify(body),cache:'no-store'});
    const x=await r.json().catch(()=>({}));
    if(!r.ok)throw Error(x.message||x.details||'Máy chủ chưa xử lý được thao tác.');
    return x;
  }catch(e){
    if(requestStarted)reportError('rpc_failed',routeOverride||routeForRpc(name));
    throw e;
  }
}
async function load(){try{[data,clinics,doctorVisits,patientVisits,leaderboard]=await Promise.all([rpc('y_quan_dashboard_v1'),rpc('y_quan_clinics_v1'),rpc('y_quan_doctor_visits_v1'),rpc('y_quan_patient_visits_v1'),rpc('y_quan_leaderboard_v1',{p_limit:20})]);message=''}catch(e){message=e.message}render()}
function starsView(visit){return visit.status==='completed'&&!visit.stars?'<div class="stars" data-visit="'+visit.visit_id+'">'+[1,2,3,4,5].map(n=>'<button data-star="'+n+'" aria-label="'+n+' sao">★</button>').join('')+' <button data-action="rate" data-id="'+visit.visit_id+'">Gửi đánh giá</button></div>':visit.stars?'<span class="pill">Đã đánh giá '+visit.stars+'/5</span>':''}
function render(){if(!session?.accessToken){ROOT.innerHTML='<section class="panel"><h1>HIU Y Quán</h1><p>Cần đăng nhập thành viên để lưu ca và tín dụng lên máy chủ.</p><a href="https://hiutmc.com/?open=game-hub">Đăng nhập HIU TMC →</a></section>';return}
ROOT.innerHTML='<header class="head"><div><b>☯ HIU Y QUÁN</b><small class="muted"> Ca, kinh nghiệm và tín dụng được lưu trên máy chủ</small></div><a href="/">Quay lại Game Hub</a></header><nav class="tabs"><button data-page="doctor" class="'+(page==='doctor'?'active':'')+'">Y quán của tôi</button><button data-page="patient" class="'+(page==='patient'?'active':'')+'">Đi khám y quán khác</button><button data-page="rank" class="'+(page==='rank'?'active':'')+'">Uy tín bác sĩ</button></nav>'+(message?'<p class="error">'+esc(message)+'</p>':'')+(page==='doctor'?doctorHTML():page==='patient'?patientHTML():rankHTML());
}
function doctorHTML(){const d=data||{},profile=d.doctor;return '<section class="panel"><div class="bar"><div><h1>Y quán của tôi</h1><p>5 ca mô phỏng mỗi ngày · 08:00–18:00 · giờ ngẫu nhiên theo máy chủ</p></div><span class="pill">'+(profile?.is_open?'Bác sĩ đang trực':'Đang vắng')+'</span></div><div class="avatars"><button data-action="open" data-avatar="male" class="avatar-choice"><img class="avatar '+(profile?.doctor_avatar_id==='male'?'selected':'')+'" src="/assets/avatars/doctor_male_29945.jpg" alt="Bác sĩ nam">Nam</button><button data-action="open" data-avatar="female" class="avatar-choice"><img class="avatar '+(profile?.doctor_avatar_id==='female'?'selected':'')+'" src="/assets/avatars/female_character_29944.jpg" alt="Bác sĩ nữ">Nữ</button><button data-action="close">Đóng y quán</button></div><div class="grid"><div><b>Tín dụng:</b> '+Number(d.credits||0)+'<br><b>Kinh nghiệm:</b> '+Number(d.experience||0)+'<br><b>Điểm sao:</b> '+(d.average_stars??'Chưa có')+'</div><div><b>Ngày:</b> '+esc(d.local_day||'—')+'<p>Tín dụng bác sĩ độc lập với Gia Viên Dược Thảo.</p></div></div></section><section class="panel"><h2>Ca mô phỏng hôm nay</h2><p class="warn">Ca mô phỏng mẫu: người bệnh thấy lạnh, mỏi lưng gối. Bot đối chiếu câu trả lời với đáp án của tình huống; đủ yêu cầu nhận trọn 100 kinh nghiệm. Tình huống chỉ dùng trong trò chơi học tập.</p>'+((d.slots||[]).map(s=>'<div class="slot"><div><b>Ca '+s.slot_no+' · '+new Date(s.starts_at).toLocaleTimeString('vi-VN',{hour:'2-digit',minute:'2-digit',timeZone:'Asia/Ho_Chi_Minh'})+'</b><small>'+esc(s.status)+' · bot '+s.bot_score+'/100 · +'+s.experience+' XP</small></div>'+(s.status==='completed'?'<span class="pill">Đã xong</span>':'<button data-action="case" data-slot="'+s.slot_no+'">Làm ca</button>')+'</div>').join('')||'<p>Chọn bác sĩ để mở y quán và tạo lịch hôm nay.</p>')+'</section><section class="panel"><h2>Bệnh nhân đã đăng ký</h2>'+doctorVisits.map(v=>'<div class="visit">'+(v.patient_avatar_url?'<img class="profile-avatar" src="'+esc(v.patient_avatar_url)+'" alt="Ảnh đại diện bệnh nhân">':'')+'<div><b>'+esc(v.patient_name)+'</b><small>Ca '+v.slot_no+' · '+esc(v.status)+' · bot '+v.bot_score+'/100</small></div>'+(v.status==='completed'?'<span class="pill">'+(v.stars?v.stars+' sao':'Chờ bệnh nhân chấm')+'</span>':'<button data-action="finish-visit" data-id="'+v.visit_id+'">Hoàn tất vấn chẩn</button>')+'</div>').join('')+(doctorVisits.length?'':'<p>Chưa có bệnh nhân đăng ký.</p>')+'</section>'}
function caseForm(id,slot){return '<section class="panel"><h2>Ca mô phỏng '+slot+'</h2><p>Người bệnh: “Dạo gần đây tôi thấy người hơi lạnh, lưng gối mỏi nặng.”</p><form data-form="case" data-id="'+esc(id||'')+'" data-slot="'+esc(slot||'')+'"><div class="domain-grid">'+DOMAINS.map(([k,n])=>'<label><input type="checkbox" name="domain" value="'+k+'"> '+n+'</label>').join('')+'</div><label>Nhận định thể bệnh<input name="diagnosis" required maxlength="300"></label><label>Biện luận<textarea name="reasoning" maxlength="1500"></textarea></label><button>Nộp ca để bot chấm</button></form></section>'}
function patientHTML(){return '<section class="panel"><h1>Đăng ký khám tại y quán thành viên</h1><p>Ảnh bệnh nhân là hồ sơ của người chơi đóng vai bệnh nhân. Hai avatar bác sĩ chỉ dành cho chủ y quán chọn lúc khai trương.</p>'+clinics.map(c=>'<div class="clinic"><div><b>'+esc(c.display_name)+'</b><small>'+(c.is_open?'Đang trực':'Vừa hoạt động')+' · '+esc(c.doctor_avatar_id==='female'?'Bác sĩ nữ':'Bác sĩ nam')+' · '+c.total_credits+' tín dụng · '+(c.average_stars??'chưa có sao')+'</small></div><button '+(!c.is_open?'disabled':'')+' data-action="register" data-id="'+c.doctor_id+'">Đăng ký khám</button></div>').join('')+(clinics.length?'':'<p>Hiện chưa có y quán đang trực.</p>')+'</section><section class="panel"><h2>Lượt khám của tôi</h2>'+patientVisits.map(v=>'<div class="visit"><div><b>'+esc(v.doctor_name)+'</b><small>Ca '+v.slot_no+' · '+esc(v.status)+' · bot '+v.bot_score+'/100</small></div>'+starsView(v)+'</div>').join('')+(patientVisits.length?'':'<p>Chưa có lịch khám.</p>')+'</section>'}
function rankHTML(){return '<section class="panel"><h1>Bảng uy tín bác sĩ</h1><p>Xếp theo tổng tín dụng Y Quán và kinh nghiệm. Bệnh nhân là người chơi trực tiếp đánh giá bác sĩ sau lượt khám.</p>'+leaderboard.map(r=>'<div class="row"><span><b>#'+r.rank_no+' '+esc(r.display_name)+'</b><small>'+esc(r.doctor_avatar_id==='female'?'Bác sĩ nữ':'Bác sĩ nam')+' · '+r.experience+' XP · '+(r.average_stars||'—')+' ★ ('+r.rating_count+')</small></span><b>'+r.credits+' tín dụng</b></div>').join('')+'</section>'}
ROOT.addEventListener('click',async e=>{const b=e.target.closest('button');if(!b)return;try{if(b.dataset.page){page=b.dataset.page;render();return}if(b.dataset.star){stars[b.closest('.stars').dataset.visit]=Number(b.dataset.star);b.closest('.stars').querySelectorAll('[data-star]').forEach(x=>x.style.opacity=Number(x.dataset.star)<=stars[b.closest('.stars').dataset.visit]?'1':'.35');return}if(b.dataset.action==='open')await rpc('y_quan_open_clinic_v1',{p_doctor_avatar_id:b.dataset.avatar});if(b.dataset.action==='close')await rpc('y_quan_close_clinic_v1');if(b.dataset.action==='register'){const x=await rpc('y_quan_register_patient_v1',{p_doctor_id:b.dataset.id});message='Đã gửi đăng ký khám cho '+new Date(x.scheduled_at).toLocaleTimeString('vi-VN',{hour:'2-digit',minute:'2-digit',timeZone:'Asia/Ho_Chi_Minh'})+'.'}if(b.dataset.action==='case'){ROOT.querySelector('#case-slot')?.remove();b.closest('.panel').insertAdjacentHTML('beforeend','<div id="case-slot">'+caseForm('',b.dataset.slot)+'</div>');return}if(b.dataset.action==='finish-visit'){ROOT.querySelector('#case-slot')?.remove();b.closest('.panel').insertAdjacentHTML('beforeend','<div id="case-slot">'+caseForm(b.dataset.id,'bệnh nhân')+'</div>');return}if(b.dataset.action==='rate'){const n=stars[b.dataset.id];if(!n)throw Error('Chọn số sao trước khi gửi.');await rpc('y_quan_rate_doctor_v1',{p_visit_id:b.dataset.id,p_stars:n});message='Đã gửi đánh giá và cộng tín dụng cho bác sĩ.'}await load()}catch(err){message=err.message;render()}});
ROOT.addEventListener('submit',async e=>{const f=e.target.closest('form[data-form="case"]');if(!f)return;e.preventDefault();const fd=new FormData(f),domains=fd.getAll('domain').map(String),diagnosis=String(fd.get('diagnosis')||''),reasoning=String(fd.get('reasoning')||'');try{if(f.dataset.id)await rpc('y_quan_submit_case_v1',{p_visit_id:f.dataset.id,p_answered_domains:domains,p_diagnosis:diagnosis,p_reasoning:reasoning});else await rpc('y_quan_submit_daily_case_v1',{p_slot_no:Number(f.dataset.slot),p_answered_domains:domains,p_diagnosis:diagnosis,p_reasoning:reasoning});message='Ca đã được máy chủ chấm và lưu.';await load()}catch(err){message=err.message;render()}});
window.addEventListener('error',()=>reportError('client_uncaught','unknown'));
window.addEventListener('unhandledrejection',()=>reportError('client_unhandled_rejection','unknown'));
try{session=getSession();if(session?.accessToken)await load();else render()}catch(e){reportError('dashboard_load_failed','bootstrap');message=e.message;render()}setInterval(()=>{if(session?.accessToken&&data?.doctor?.is_open)rpc('y_quan_open_clinic_v1',{p_doctor_avatar_id:data.doctor.doctor_avatar_id},'background_refresh').then(load).catch(()=>{})},60000);