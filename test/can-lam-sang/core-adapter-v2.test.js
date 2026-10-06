import test from 'node:test';
import assert from 'node:assert/strict';
import { readFile } from 'node:fs/promises';
import { adaptLegacyCase } from '../../src/can-lam-sang/adapters/legacy-case-adapter.mjs';

async function bank() {
  const html=await readFile(new URL('../../public/tu-chan/index.html',import.meta.url),'utf8');
  const match=html.match(/id="bank-data">([\s\S]*?)<\/script>/);
  assert.ok(match,'legacy bank-data missing');
  return JSON.parse(match[1]);
}
function flattenStrings(value,out=[]) {
  if(typeof value==='string') out.push(value);
  else if(Array.isArray(value)) value.forEach(v=>flattenStrings(v,out));
  else if(value&&typeof value==='object') Object.values(value).forEach(v=>flattenStrings(v,out));
  return out;
}
function publicStrings(bundle) { return flattenStrings(bundle).filter(v=>v.length>5); }
function allowedChoiceStrings(bundle) {
  return new Set([
    ...Object.values(bundle.choices?.diagnosis||{}).flat(),
    ...(bundle.choices?.actions||[])
  ]);
}
function acceptedBySubmitContract(answerKey,answers) {
  const groups=Object.keys(answerKey.diagnosis_options||{});
  if(Object.keys(answers).length!==groups.length+1 || !Object.hasOwn(answers,'actions')) return false;
  for(const group of groups){
    const value=answers[group];
    const values=Array.isArray(value)?value:[value];
    if(!values.length) return false;
    if(values.some(v=>!(answerKey.diagnosis_options[group]||[]).some(opt=>opt.text===v))) return false;
  }
  if(!Array.isArray(answers.actions)||!answers.actions.length) return false;
  return answers.actions.every(v=>(answerKey.action_options||[]).some(opt=>opt.text===v));
}

test('v2 creates text-only shuffled choices for every one of 156 cases',async()=>{
  const cases=await bank();
  assert.equal(cases.length,156);
  for(const legacy of cases){
    const {public_bundle,answer_key}=adaptLegacyCase(legacy);
    assert.ok(public_bundle.choices);
    for(const [group,options] of Object.entries(answer_key.diagnosis_options||{})){
      assert.deepEqual([...public_bundle.choices.diagnosis[group]].sort(),options.map(x=>x.text).filter(Boolean).filter((v,i,a)=>a.indexOf(v)===i).sort(),legacy.id+': '+group);
      assert.ok(public_bundle.choices.diagnosis[group].every(x=>typeof x==='string'));
    }
    assert.deepEqual([...public_bundle.choices.actions].sort(),answer_key.action_options.map(x=>x.text).filter(Boolean).filter((v,i,a)=>a.indexOf(v)===i).sort(),legacy.id+': actions');
    assert.ok(!Object.hasOwn(public_bundle,'answer_key'));
    assert.ok(!Object.hasOwn(public_bundle,'diagnosis_options'));
    assert.ok(!Object.hasOwn(public_bundle,'action_options'));
    assert.ok(!Object.hasOwn(public_bundle,'teaching_explanation'));
  }
});

test('v2 shuffle is deterministic for the same case and changes ordering for at least one nontrivial case',async()=>{
  const cases=await bank();
  let changed=false;
  for(const legacy of cases){
    const a=adaptLegacyCase(legacy).public_bundle;
    const b=adaptLegacyCase(legacy).public_bundle;
    assert.deepEqual(a.choices,b.choices,legacy.id);
    for(const [group,values] of Object.entries(a.choices.diagnosis||{})){
      const source=(legacy.opt?.[group]||[]).map(x=>String(x).replace(/^[+~]/,''));
      if(values.length>2 && JSON.stringify(values)!==JSON.stringify(source)) changed=true;
    }
    if(a.choices.actions.length>2){
      const source=(legacy.actions||[]).map(x=>String(x).replace(/^\+\+/,'').replace(/^[+\-!]/,'').split('|')[0]);
      if(JSON.stringify(a.choices.actions)!==JSON.stringify(source)) changed=true;
    }
  }
  assert.equal(changed,true,'expected seeded order to differ from source order for at least one nontrivial choice set');
});

test('every case yields a submission-contract-valid answer set and rejects an unknown value',async()=>{
  const cases=await bank();
  for(const legacy of cases){
    const {public_bundle,answer_key}=adaptLegacyCase(legacy);
    const answers={};
    for(const [group,options] of Object.entries(answer_key.diagnosis_options||{})){
      const full=options.filter(x=>x.credit==='full');
      const source=(full.length?full:options).map(x=>x.text).filter(Boolean);
      assert.ok(source.length,legacy.id+': '+group+' has no selectable answer');
      answers[group]=[source[0]];
    }
    const actions=(answer_key.action_options||[]).map(x=>x.text).filter(Boolean);
    assert.ok(actions.length,legacy.id+': no actions');
    answers.actions=[actions[0]];
    assert.equal(acceptedBySubmitContract(answer_key,answers),true,legacy.id);
    const bad=structuredClone(answers);
    bad[Object.keys(answer_key.diagnosis_options||{})[0]]=['__UNEXPECTED_CHOICE__'];
    assert.equal(acceptedBySubmitContract(answer_key,bad),false,legacy.id);
    assert.ok(public_bundle.choices.diagnosis);
  }
});

test('public bundle contains no secret answer/explanation strings outside the allowed choice text',async()=>{
  const cases=await bank();
  for(const legacy of cases){
    const {public_bundle,answer_key}=adaptLegacyCase(legacy);
    const publicText=JSON.stringify(public_bundle);
    const allowed=allowedChoiceStrings(public_bundle);
    const secret=[];
    for(const value of [
      answer_key.title_reveal,
      answer_key.teaching_explanation,
      ...(answer_key.after_submission_notes||[]).flatMap(x=>[x.text,x.reason]),
      ...(answer_key.resources_after_submission||[]).flatMap(x=>[x.source,x.title,x.citation,x.organization,x.year_version,x.license]),
      ...(answer_key.action_options||[]).flatMap(x=>[x.rationale,x.grade,String(x.time_minutes)])
    ].filter(v=>typeof v==='string'&&v.length>5)){
      if(!allowed.has(value)) secret.push(value);
    }
    for(const value of secret) assert.equal(publicText.includes(value),false,legacy.id+': leaked answer string '+value);
  }
});
