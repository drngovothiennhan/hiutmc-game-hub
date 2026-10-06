import { bootstrapSession, getValidAccessToken } from '../../../src/auth/session.js';
import { SUPABASE_URL } from '../../../src/config.js';
import { renderCase, renderResult } from '../../../src/can-lam-sang/core/case-ui.mjs';

const root=document.querySelector('#app');
const rpc=async(name,body)=>{
 const token=await getValidAccessToken();
 const res=await fetch(SUPABASE_URL+'/rest/v1/rpc/'+name,{method:'POST',headers:{'content-type':'application/json',authorization:'Bearer '+token,apikey:token},body:JSON.stringify(body)});
 return res.json();
};
await bootstrapSession();
const caseId=new URLSearchParams(location.search).get('case_id');
if(!caseId){root.textContent='Chưa chọn ca.';}else{
 const response=await rpc('cls_get_case_v1',{p_case_id:caseId});
 if(!response?.ok){root.textContent='Ca hiện chưa mở.';}else{
   renderCase(root,response.data,{onSubmit:async(value)=>{
     const submit=await rpc('cls_submit_v1',{p_case_id:caseId,p_answers:{decision:value}});
     if(submit?.ok) renderResult(root,submit.data);
   }});
 }
}