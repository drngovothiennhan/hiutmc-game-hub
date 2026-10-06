import { bootstrapSession, getValidAccessToken } from '../../src/auth/session.js';
import { SUPABASE_URL, SUPABASE_PUBLISHABLE_KEY } from '../../src/config.js';

const root = document.querySelector('#app');
const messages = {
  khong_xac_thuc:'Vui lòng đăng nhập HIU TMC để mở Phòng CBC.',
  chua_mo:'Phòng CBC hiện chưa mở cho tài khoản của bạn.',
  level_khong_hop_le:'Mức độ bài học không hợp lệ.',
  qua_3_luot_mo:'Bạn đã đạt giới hạn 3 lượt đang mở.',
  qua_10_luot_ngay:'Bạn đã đạt giới hạn 10 lượt mới trong ngày.',
  chua_co_scenario:'Chưa có kịch bản CBC được duyệt ở mức này.',
  khong_tim_thay:'Không tìm thấy lượt học này.',
  answers_khong_hop_le:'Câu trả lời chưa hợp lệ. Hãy chọn đủ 13 chỉ số.',
  da_nop:'Lượt này đã được nộp.'
};
const generic='Có lỗi khi xử lý. Vui lòng thử lại sau.';

async function rpc(name, body={}) {
  const token=await getValidAccessToken();
  if(!token) throw Object.assign(new Error('khong_xac_thuc'),{code:'khong_xac_thuc'});
  const res=await fetch(SUPABASE_URL+'/rest/v1/rpc/'+name,{
    method:'POST',
    headers:{apikey:SUPABASE_PUBLISHABLE_KEY,Authorization:'Bearer '+token,'Content-Type':'application/json',Accept:'application/json'},
    body:JSON.stringify(body),cache:'no-store'
  });
  const data=await res.json().catch(()=>null);
  if(!res.ok) throw Object.assign(new Error(generic),{code:'unknown'});
  return data;
}
function codeMessage(code){return messages[code]||generic}
function showGate(text){root.innerHTML='<div class="notice">'+text+'</div>'}

const session=await bootstrapSession();
if(!session.member||!session.session){
  showGate(messages.khong_xac_thuc);
} else {
  try {
    const flag=await rpc('cls_flag_status_v1');
    if(!flag?.ok||!flag?.data?.enabled){showGate(messages.chua_mo)}
    else {
      // CBC code, including generator/conversion logic, is not imported until the feature is open.
      const { mountCBC }=await import('./cbc.js');
      await mountCBC(root,{rpc,codeMessage});
    }
  } catch(error) {
    showGate(codeMessage(error.code));
  }
}