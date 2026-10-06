import test from 'node:test';
import assert from 'node:assert/strict';
import { buildAnswers, diagnosisGroups, toggleSelected, messageForCoreCode } from '../../src/can-lam-sang/core/ui-helpers.mjs';

test('core helpers build checkbox answers using only public choices',()=>{
  const choices={diagnosis:{ydx:['A','B'],the:['C']},actions:['Do X','Do Y']};
  let selected={ydx:['A'],the:['C'],actions:['Do Y']};
  assert.deepEqual(diagnosisGroups(choices),[['ydx',['A','B']],['the',['C']]]);
  assert.deepEqual(buildAnswers(choices,selected),{ydx:['A'],the:['C'],actions:['Do Y']});
  assert.equal(buildAnswers(choices,{ydx:['A'],the:[],actions:['Do Y']}),null);
  selected=toggleSelected(selected,'ydx','B',true);
  assert.deepEqual(selected.ydx,['A','B']);
  selected=toggleSelected(selected,'ydx','A',false);
  assert.deepEqual(selected.ydx,['B']);
});

test('core helper messages cover required RPC errors',()=>{
  for(const code of ['chua_mo','khong_tim_thay','answers_khong_hop_le','da_nop','khong_xac_thuc']) assert.ok(messageForCoreCode(code));
});

import { readFile } from 'node:fs/promises';

test('core UI reopens submitted cases only through cls_get_submission_v1, never an empty submit',async()=>{
  const source=await readFile(new URL('../../public/can-lam-sang/core.js',import.meta.url),'utf8');
  assert.match(source,/rpc\('cls_get_submission_v1',\{p_case_id:caseId\}\)/);
  assert.doesNotMatch(source,/cls_submit_v1'\,\{p_case_id:caseId,p_module:'core',p_answers:\{\}\}/);
  assert.match(source,/answers_khong_hop_le/);
});
