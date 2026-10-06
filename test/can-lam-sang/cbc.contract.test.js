import test from "node:test";
import assert from "node:assert/strict";
import fs from "node:fs";
import path from "node:path";
import { fileURLToPath } from "node:url";
import { generateScenario, convertValue, PROFILES } from "../../src/can-lam-sang/cbc/generator.mjs";
import { validateInvariants } from "../../src/can-lam-sang/cbc/validator.mjs";
import { classifyValue, classifyScenario } from "../../src/can-lam-sang/cbc/classify.mjs";
import { scoreAnswers } from "../../src/can-lam-sang/cbc/rubric.mjs";
import { assertFixtureNeverLearner } from "../../src/can-lam-sang/cbc/approval-gate.mjs";

const here=path.dirname(fileURLToPath(import.meta.url));
const fixture=JSON.parse(fs.readFileSync(path.join(here,"../../fixtures/can-lam-sang/cbc/normal-adult.fixture.json"),"utf8"));
const schemaDir=path.join(here,"../../../schemas/can-lam-sang");
const schemas=["cbc-reference.v1.schema.json","cbc-pattern.v1.schema.json","cbc-scenario.v1.schema.json"].map(f=>JSON.parse(fs.readFileSync(path.join(schemaDir,f),"utf8")));
const pattern=fixture;

function assertBasicSchema(s){
  assert.equal(s.type,"object"); assert.equal(s.additionalProperties,false);
  assert.ok(Array.isArray(s.required)); assert.ok(s.required.length>0);
  assert.ok(s.properties && typeof s.properties==="object");
}
function freshPattern(){
  return JSON.parse(JSON.stringify(pattern));
}

test("schema contracts are valid JSON objects",()=>schemas.forEach(assertBasicSchema));

test("1000 seeded vectors satisfy interval invariants",()=>{
  for(let i=0;i<1000;i++){
    const scenario=generateScenario({pattern,variant:i,scenario_id:"fixture-"+i,sex:"nam"});
    assert.doesNotThrow(()=>validateInvariants(scenario,"vn_lab"));
    assert.doesNotThrow(()=>validateInvariants(scenario,"conventional"));
    assert.equal(Math.round((scenario.values.neut+scenario.values.lymph+scenario.values.mono+scenario.values.eos+scenario.values.baso)*10),1000);
  }
});

test("same seed is golden; variant changes vector",()=>{
  const a=generateScenario({pattern,variant:17,scenario_id:"golden",sex:"nam"});
  const b=generateScenario({pattern,variant:17,scenario_id:"golden",sex:"nam"});
  const c=generateScenario({pattern,variant:18,scenario_id:"golden",sex:"nam"});
  assert.deepEqual(a,b); assert.notDeepEqual(a.values,c.values);
});

test("classification follows sex-specific reference",()=>{
  const r=pattern.indices.Hb.ranges.nam;
  assert.equal(classifyValue(r.low-1,r,"nam"),"thap");
  assert.equal(classifyValue(r.high+1,r,"nam"),"cao");
  assert.equal(classifyValue(r.low,r,"nam"),"binh_thuong");
  const s=generateScenario({pattern,variant:3,sex:"nam"});
  const classified=classifyScenario(s,pattern,"nam");
  assert.equal(typeof classified.Hb,"string");
});

test("rubric scores fixture answers deterministically",()=>{
  const s=generateScenario({pattern,variant:2,sex:"nam"});
  const result=scoreAnswers(pattern,s,{classifications:pattern.expected_classifications,interpretation:"CBC bình thường người lớn"});
  assert.equal(result.score,1);
  const wrong=scoreAnswers(pattern,s,{classifications:{...pattern.expected_classifications,Hb:"cao"},interpretation:"sai"});
  assert.ok(wrong.score<1);
});

test("approval gate rejects fixture-only and unapproved content",()=>{
  assert.throws(()=>assertFixtureNeverLearner(fixture),/fixture_only|pattern_chua_duyet/);
  assert.throws(()=>assertFixtureNeverLearner({...freshPattern(),review_status:"CHUA_DUYET"}),/pattern_chua_duyet/);
});

test("fixture is unreachable from src/public",()=>{
  const roots=[path.join(here,"../../../src"),path.join(here,"../../../public")];
  for(const root of roots){
    if(!fs.existsSync(root)) continue;
    const stack=[root];
    while(stack.length){
      const dir=stack.pop();
      for(const ent of fs.readdirSync(dir,{withFileTypes:true})){
        const p=path.join(dir,ent.name);
        if(ent.isDirectory()) stack.push(p);
        else {
          const text=fs.readFileSync(p,"utf8");
          assert.ok(!text.includes("test/fixtures/can-lam-sang/cbc/"),"fixture path leaked in "+p);
          assert.ok(!text.includes("FIXTURE-CBC-P01"),"fixture id leaked in "+p);
        }
      }
    }
  }
});

test("unit conversion is reversible for every displayed index in both profiles",()=>{
  const values={Hb:145,RBC:5.1,Hct:0.44,MCV:90,MCH:28.4,MCHC:330,WBC:7.2,PLT:250,neut:55,lymph:30,mono:7,eos:2,baso:1};
  for(const key of Object.keys(values)){
    for(const from of Object.keys(PROFILES)) for(const to of Object.keys(PROFILES)){
      const displayed=convertValue(key,values[key],from,to);
      const back=convertValue(key,displayed,to,from);
      assert.ok(Math.abs(back-values[key])<1e-9,key+" "+from+"->"+to);
    }
  }
});

test("missing sex is rejected",()=>{
  assert.throws(()=>generateScenario({pattern,variant:1,scenario_id:"missing-sex",sex:undefined}),/sex_thieu/);
});

test("no nondeterministic/random ordering primitives",()=>{
  const roots=[path.join(here,"../../../src"),path.join(here,"../../../schemas")];
  const stack=[...roots];
  while(stack.length){
    const dir=stack.pop(); if(!fs.existsSync(dir)) continue;
    for(const ent of fs.readdirSync(dir,{withFileTypes:true})){
      const p=path.join(dir,ent.name);
      if(ent.isDirectory()) stack.push(p);
      else if(/\.(mjs|json)$/.test(ent.name)){
        const text=fs.readFileSync(p,"utf8");
        assert.ok(!text.includes("Math.random"),"Math.random in "+p);
        assert.ok(!text.includes("ORDER BY random()"),"ORDER BY random() in "+p);
      }
    }
  }
});
