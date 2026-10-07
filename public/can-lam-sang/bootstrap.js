import { bootstrapSession, getValidAccessToken } from '../../src/auth/session.js';
import { SUPABASE_URL, SUPABASE_PUBLISHABLE_KEY } from '../../src/config.js';
import { messageForCode } from '../../src/can-lam-sang/cbc/ui-helpers.mjs';
import { messageForCoreCode } from '../../src/can-lam-sang/core/ui-helpers.mjs';

const root = document.querySelector('#app');

async function rpc(name, body={}) {
  const token=await getValidAccessToken();
  if(!token) throw Object.assign(new Error('khong_xac_thuc'),{code:'khong_xac_thuc'});
  const res=await fetch(SUPABASE_URL+'/rest/v1/rpc/'+name,{
    method:'POST',
    headers:{apikey:SUPABASE_PUBLISHABLE_KEY,Authorization:'Bearer '+token,'Content-Type':'application/json',Accept:'application/json'},
    body:JSON.stringify(body),cache:'no-store',signal:AbortSignal.timeout(12000)
  });
  const data=await res.json().catch(()=>null);
  if(!res.ok) throw Object.assign(new Error(data?.code||'unknown'),{code:data?.code||'unknown'});
  return data;
}
const esc=value=>String(value??'').replace(/[&<>"']/g,c=>({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[c]));
function gate(text,error=false){root.innerHTML='<div class="cls-notice '+(error?'cls-error':'')+'">'+esc(text)+'</div>';}

function home() {
  root.innerHTML='<div class="cls-home"><div class="cls-header"><div class="cls-muted">HIU TMC · Phòng Cận Lâm Sàng</div><h1>Phòng Cận Lâm Sàng</h1><p>Chọn khu thực hành học tập.</p></div>'+
    '<div class="cls-entry-grid">'+
      '<button type="button" class="cls-entry" id="open-cbc"><strong>Phòng CBC</strong><span>Phân loại 13 chỉ số công thức máu.</span></button>'+
      '<button type="button" class="cls-entry" id="open-core"><strong>Ca bệnh lõi</strong><span>Danh sách 156 ca mô phỏng, chọn đáp án và xem giải thích sau khi nộp.</span></button>'+
    '</div></div>';
  root.querySelector('#open-cbc').onclick=async()=>{const {mountCBC}=await import('./cbc.js');await mountCBC(root,{rpc,onHome:home});};
  root.querySelector('#open-core').onclick=async()=>{const {mountCore}=await import('./core.js');await mountCore(root,{rpc,onHome:home});};
}

const session=await bootstrapSession();
if(!session.member||!session.session) {
  gate(session.error||messageForCoreCode('khong_xac_thuc'),true);
} else {
  try {
    const flag=await rpc('cls_flag_status_v1');
    if(!flag?.ok||!flag?.data?.enabled) gate(messageForCoreCode('chua_mo'));
    else home();
  } catch(error) {
    gate(messageForCoreCode(error.code||'unknown'),true);
  }
}
