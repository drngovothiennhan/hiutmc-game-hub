import test from 'node:test';
import assert from 'node:assert/strict';
import { CBC_CODES, messageForCode, convertProfileValue, profileUnit, profilePrecision } from '../../src/can-lam-sang/cbc/ui-helpers.mjs';

test('2a-3 maps every locked RPC code and hides unknown detail',()=>{
  for(const code of CBC_CODES) assert.ok(messageForCode(code).length>0,code);
  assert.equal(messageForCode('unexpected_internal_code'),'Có lỗi khi xử lý. Vui lòng thử lại sau.');
});

test('2a-3 uses generator profile conversion and target precision',()=>{
  assert.equal(convertProfileValue('Hb',150,'vn_lab','conventional'),15);
  assert.equal(convertProfileValue('MCHC',350,'vn_lab','conventional'),35);
  assert.equal(convertProfileValue('Hct',35.790000000000006,'vn_lab','conventional'),35.8);
  assert.equal(profilePrecision('MCHC','conventional'),2);
  assert.equal(profileUnit('Hb','conventional'),'g/dL');
});
