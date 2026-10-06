import { hash32 } from "../lib/seeded-rng.mjs";
const INDICES=["Hb","RBC","Hct","MCV","MCH","MCHC","WBC","PLT","neut","lymph","mono","eos","baso"];
const PROFILES={
  vn_lab:{Hb:["g/L",1],RBC:["T/L",2],Hct:["%",1],MCV:["fL",1],MCH:["pg",1],MCHC:["g/L",1],WBC:["G/L",2],PLT:["G/L",2],neut:["%",1],lymph:["%",1],mono:["%",1],eos:["%",1],baso:["%",1],abs:["G/L",2]},
  conventional:{Hb:["g/dL",1],RBC:["×10^12/L",2],Hct:["%",1],MCV:["fL",1],MCH:["pg",1],MCHC:["g/dL",2],WBC:["×10^9/L",2],PLT:["×10^9/L",2],neut:["%",1],lymph:["%",1],mono:["%",1],eos:["%",1],baso:["%",1],abs:["×10^9/L",2]}
};
const INTERNAL={Hb:"g/L",RBC:"T/L",Hct:"fraction",MCV:"fL",MCH:"pg",MCHC:"g/L",WBC:"G/L",PLT:"G/L",neut:"%",lymph:"%",mono:"%",eos:"%",baso:"%"};
function round(v,p){const m=10**p;return Math.round((v+Number.EPSILON)*m)/m}
function rng(seed){let s=hash32(seed)||0x6d2b79f5;return()=>{s=(s+0x6d2b79f5)>>>0;let t=s;t=Math.imul(t^(t>>>15),t|1);t^=t+Math.imul(t^(t>>>7),t|61);return((t^(t>>>14))>>>0)/4294967296}}
function pick(r,a,b){return a+(b-a)*r()}
function requireSex(sex){if(sex!=="nam"&&sex!=="nữ")throw new Error("sex_thieu_hoac_khong_hop_le")}
function requireRanges(pattern,sex){requireSex(sex);for(const k of INDICES){if(!pattern.indices?.[k]?.ranges?.[sex])throw new Error("reference_thieu_gioi:"+k)}}
function largestRemainder(r, ranges, precision=1){const scale=10**precision;const raw=ranges.map(x=>x*scale);const floors=raw.map(Math.floor);let left=Math.round(scale*100-floors.reduce((a,b)=>a+b,0));const order=raw.map((x,i)=>({i,frac:x-Math.floor(x)})).sort((a,b)=>b.frac-a.frac||a.i-b.i);for(let j=0;j<left;j++)floors[order[j%order.length].i]++;return floors.map(x=>x/scale)}
function convertFromInternal(key,v,profile){if(key==="Hct"&&profile==="vn_lab")return v*100;if(key==="Hct"&&profile==="conventional")return v*100;if(key==="Hb"&&profile==="conventional")return v/10;if(key==="MCHC"&&profile==="conventional")return v/10;return v}
function convertToInternal(key,v,profile){if(key==="Hct")return v/100;if(key==="Hb"&&profile==="conventional")return v*10;if(key==="MCHC"&&profile==="conventional")return v*10;return v}
export function convertValue(key,v,fromProfile,toProfile){const internal=convertToInternal(key,v,fromProfile);return convertFromInternal(key,internal,toProfile)}
export function generateScenario({pattern,variant=0,scenario_id="fixture",sex,profile="vn_lab"}){requireSex(sex);requireRanges(pattern,sex);if(!Number.isInteger(variant)||variant<0)throw new Error("variant_invalid");
  const seed=hash32(pattern.pattern_id+"cbc"+pattern.schema_version+String(variant));const r=rng(String(seed));const root=pattern.indices;
  const hb=round(pick(r,root.Hb.ranges[sex].low,root.Hb.ranges[sex].high),root.Hb.precision??1);
  const rbc=round(pick(r,root.RBC.ranges[sex].low,root.RBC.ranges[sex].high),root.RBC.precision??2);
  const mcv=round(pick(r,root.MCV.ranges[sex].low,root.MCV.ranges[sex].high),root.MCV.precision??1);
  const hct=round(rbc*mcv/1000,root.Hct.precision??1);
  const mch=round(hb/rbc,root.MCH.precision??1);
  const mchc=round(hb/hct,root.MCHC.precision??1);
  const wbc=round(pick(r,root.WBC.ranges[sex].low,root.WBC.ranges[sex].high),root.WBC.precision??2);
  const pl=round(pick(r,root.PLT.ranges[sex].low,root.PLT.ranges[sex].high),root.PLT.precision??2);
  const delta=(r()-0.5)*4; const raw=[55+delta,33-delta,7,4,1];
  const pct=largestRemainder(r,raw,1);
  const [neut,lymph,mono,eos,baso]=pct;
  const values={Hb:hb,RBC:rbc,Hct:hct,MCV:mcv,MCH:mch,MCHC:mchc,WBC:wbc,PLT:pl,neut,lymph,mono,eos,baso};
  const abs_neut=round(wbc*neut/100,2),abs_lymph=round(wbc*lymph/100,2),abs_mono=round(wbc*mono/100,2),abs_eos=round(wbc*eos/100,2),abs_baso=round(wbc*baso/100,2);
  const display_profiles={};for(const p of Object.keys(PROFILES)){display_profiles[p]={};for(const k of INDICES)display_profiles[p][k]={value:round(convertFromInternal(k,values[k],p),PROFILES[p][k][1]),unit:PROFILES[p][k][0]};for(const [k,v] of Object.entries({abs_neut,abs_lymph,abs_mono,abs_eos,abs_baso}))display_profiles[p][k]={value:v,unit:PROFILES[p].abs[0]}}
  return {schema_version:pattern.schema_version,scenario_id,pattern_id:pattern.pattern_id,sex,values:{...values,abs_neut,abs_lymph,abs_mono,abs_eos,abs_baso},display_profiles,internal_units:INTERNAL};
}
export {PROFILES,INDICES,INTERNAL,convertFromInternal,convertToInternal};
