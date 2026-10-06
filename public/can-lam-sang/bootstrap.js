import { bootstrapSession, getValidAccessToken } from '../../src/auth/session.js';
import { SUPABASE_URL, SUPABASE_PUBLISHABLE_KEY } from '../../src/config.js';
import { messageForCode } from '../../src/can-lam-sang/cbc/ui-helpers.mjs';

const root = document.querySelector('#app');

async function rpc(name, body={}) {
  const token=await getValidAccessToken();
  if(!token) throw Object.assign(new Error('khong_xac_thuc'),{code:'khong_xac_thuc'});
  const res=await fetch(SUPABASE_URL+'/rest/v1/rpc/'+name,{
    method:'POST',
    headers:{apikey:SUPABASE_PUBLISHABLE_KEY,Authorization:'Bearer '+token,'Content-Type':'application/json',Accept:'application/json'},
    body:JSON.stringify(body),cache:'no-store'
  });
  const data=await res.json().catch(()=>null);
  if(!res.ok) throw Object.assign(new Error('rpc_failed'),{code:'unknown'});
  return data;
}
function showGate(text){root.innerHTML='<div class="notice">'+text+'</div>'}

const session=await bootstrapSession();
if(!session.member||!session.session){
  showGate(messageForCode('khong_xac_thuc'));
} else {
  try {
    const flag=await rpc('cls_flag_status_v1');
    if(!flag?.ok||!flag?.data?.enabled){showGate(messageForCode('chua_mo'))}
    else {
      const { mountCBC }=await import('./cbc.js');
      await mountCBC(root,{rpc,codeMessage:messageForCode});
    }
  } catch(error) {
    showGate(messageForCode(error.code||'unknown'));
  }
}
