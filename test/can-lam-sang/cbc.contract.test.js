import test from "node:test";
import assert from "node:assert/strict";
import fs from "node:fs";
import path from "node:path";
import { fileURLToPath } from "node:url";
import { generateScenario, convertValue, PROFILES } from "../../src/can-lam-sang/cbc/generator.mjs";
import { validateInvariants } from "../../src/can-lam-sang/cbc/validator.mjs";
import { classifyValue } from "../../src/can-lam-sang/cbc/classify.mjs";
import { scoreAnswers } from "../../src/can-lam-sang/cbc/rubric.mjs";
import { assertFixtureNeverLearner } from "../../src/can-lam-sang/cbc/approval-gate.mjs";

const here=path.dirname(fileURLToPath(import.meta.url));
const repoRoot=path.resolve(here,"../..");
const fixturePath=path.join(repoRoot,"test/fixtures/can-lam-sang/cbc/normal-adult.fixture.json");
const schemaRoot=path.join(repoRoot,"schemas/can-lam-sang");
const fixture=JSON.parse(fs.readFileSync(fixturePath,"utf8"));
const schemas=["cbc-reference.v1.schema.json","cbc-pattern.v1.schema.json","cbc-scenario.v1.schema.json"].map(name=>JSON.parse(fs.readFileSync(path.join(schemaRoot,name),"utf8")));

function basicSchemaCheck(s){
  assert.equal(s.type,"object");
  assert.equal(s.additionalProperties,false);
  assert.ok(Array.isArray(s.required) && s.required.length>0);
  assert.ok(s.properties && typeof s.properties==="object");
}
function allTextFiles(root){
  const out=[]; const stack=[root];
  while(stack.length){const dir=stack.pop(); for(const ent of fs.readdirSync(dir,{withFileTypes:true})){const p=path.join(dir,ent.name); if(ent.isDirectory())stack.push(p); else out.push(p)}}
  return out;
}

test("CBC schemas are structurally valid",()=>schemas.forEach(basicSchemaCheck));

test("1000 seeded vectors satisfy interval invariants and differential sum",()=>{
  for(let i=0;i<1000;i++){
    const s=generateScenario({pattern:fixture,variant:i,scenario_id:"fixture-"+i,sex:"nam"});
    validateInvariants(s,"vn_lab");
    validateInvariants(s,"conventional");
    assert.equal(Math.round((s.values.neut+s.values.lymph+s.values.mono+s.values.eos+s.values.baso)*10),1000);
  }
});

test("same seed is identical and variant changes output",()=>{
  const a=generateScenario({pattern:fixture,variant:17,scenario_id:"golden",sex:"nam"});
  const b=generateScenario({pattern:fixture,variant:17,scenario_id:"golden",sex:"nam"});
  const c=generateScenario({pattern:fixture,variant:18,scenario_id:"golden",sex:"nam"});
  assert.deepEqual(a,b);
  assert.notDeepEqual(a.values,c.values);
});

test("classification uses sex-specific ranges",()=>{
  const r=fixture.indices.Hb.ranges.nam;
  assert.equal(classifyValue(r.low-1,r,"nam"),"thap");
  assert.equal(classifyValue(r.high+1,r,"nam"),"cao");
  assert.equal(classifyValue(r.low,r,"nam"),"binh_thuong");
});

test("rubric scores correct and incorrect fixture answers",()=>{
  const s=generateScenario({pattern:fixture,variant:2,sex:"nam"});
  assert.equal(scoreAnswers(fixture,s,{classifications:fixture.expected_classifications,interpretation:"CBC bình thường người lớn"}).score,1);
  assert.ok(scoreAnswers(fixture,s,{classifications:{...fixture.expected_classifications,Hb:"cao"},interpretation:"sai"}).score<1);
});

test("approval gate rejects FIXTURE_ONLY and CHUA_DUYET",()=>{
  assert.throws(()=>assertFixtureNeverLearner(fixture),/fixture_only/);
  const unapproved={...fixture,pattern_id:"CBC-P01-UNAPPROVED",review_status:"CHUA_DUYET"};
  assert.throws(()=>assertFixtureNeverLearner(unapproved),/pattern_chua_duyet/);
});

test("fixture data is not referenced by src or public",()=>{
  for(const root of [path.join(repoRoot,"src"),path.join(repoRoot,"public")]){
    for(const file of allTextFiles(root)){
      const text=fs.readFileSync(file,"utf8");
      assert.ok(!text.includes("test/fixtures/can-lam-sang/cbc/"),"fixture path leaked: "+file);
      assert.ok(!text.includes("FIXTURE-CBC-P01"),"fixture id leaked: "+file);
    }
  }
});

test("both unit profiles round-trip every index and missing sex is rejected",()=>{
  const values={Hb:145,RBC:5.1,Hct:.44,MCV:90,MCH:28.4,MCHC:330,WBC:7.2,PLT:250,neut:55,lymph:30,mono:7,eos:2,baso:1};
  for(const key of Object.keys(values)) for(const from of Object.keys(PROFILES)) for(const to of Object.keys(PROFILES)){
    const shown=convertValue(key,values[key],from,to);
    const back=convertValue(key,shown,to,from);
    assert.ok(Math.abs(back-values[key])<1e-9,key+" "+from+"->"+to);
  }
  assert.throws(()=>generateScenario({pattern:fixture,variant:1,scenario_id:"missing-sex",sex:undefined}),/sex_thieu/);
});

test("CBC engine contains no unseeded random or SQL random ordering",()=>{
  for(const root of [path.join(repoRoot,"src/can-lam-sang/cbc"),schemaRoot]){
    for(const file of allTextFiles(root)){
      if(!/\.(mjs|json)$/.test(file))continue;
      const text=fs.readFileSync(file,"utf8");
      assert.doesNotMatch(text,/Math\.random/);
      assert.doesNotMatch(text,/ORDER\s+BY\s+random\s*\(/i);
    }
  }
});
