import { convertToInternal, convertFromInternal, PROFILES } from "./generator.mjs";
function interval(x,precision){const h=0.5*10**(-precision);return [x-h,x+h]}
function divInterval(a,b){const vals=[a[0]/b[0],a[0]/b[1],a[1]/b[0],a[1]/b[1]];return [Math.min(...vals),Math.max(...vals)]}
function overlaps(a,b){return a[0]<=b[1]+1e-12&&b[0]<=a[1]+1e-12}
export function validateInvariants(scenario,profile="vn_lab"){
  const d=scenario.display_profiles?.[profile];if(!d)throw new Error("profile_missing");
  const p=PROFILES[profile];const get=(k)=>interval(d[k].value,p[k][1]);
  const hb=divInterval([get("Hb")[0]*(profile==="conventional"?10:1),get("Hb")[1]*(profile==="conventional"?10:1)],[get("RBC")[0],get("RBC")[1]]);
  if(!overlaps(get("MCH"),hb))throw new Error("MCH_interval_failed");
  const hctBase=[get("RBC")[0]*get("MCV")[0]/1000,get("RBC")[1]*get("MCV")[1]/1000];
  if(!overlaps(get("Hct"),hctBase.map(x=>x*100)))throw new Error("Hct_interval_failed");
  const mchcBase=divInterval([get("Hb")[0]*(profile==="conventional"?10:1),get("Hb")[1]*(profile==="conventional"?10:1)],hctBase);
  const mchcDisplay=mchcBase.map(x=>profile==="conventional"?x/10:x);
  if(!overlaps(get("MCHC"),mchcDisplay))throw new Error("MCHC_interval_failed");
  const sum=["neut","lymph","mono","eos","baso"].reduce((s,k)=>s+d[k].value,0);
  if(Math.abs(sum-100)>10**(-p.neut[1])/2)throw new Error("differential_sum_failed");
  const wbc=d.WBC.value;
  for(const k of ["neut","lymph","mono","eos","baso"]){
    const actual=interval(d["abs_"+k].value,p.abs[1]);
    const expected=[wbc*d[k].value/100,wbc*d[k].value/100];
    if(!overlaps(actual,expected))throw new Error("absolute_differential_failed:"+k);
  }
  return true;
}
export function roundTripUnit(key,value,fromProfile,toProfile){
  const internal=convertToInternal(key,value,fromProfile);
  const displayed=convertFromInternal(key,internal,toProfile);
  return convertToInternal(key,displayed,toProfile);
}
