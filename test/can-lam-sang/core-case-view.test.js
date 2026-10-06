import test from 'node:test';import assert from 'node:assert/strict';import fs from 'node:fs';
const ui=fs.readFileSync('src/can-lam-sang/core/case-ui.mjs','utf8');
test('review label is rendered whenever server returns a non-null label',()=>{assert.match(ui,/data-review-label/);assert.match(ui,/data\.review_label/);assert.match(ui,/textContent = label/);});
test('answer is not written to browser storage',()=>{assert.doesNotMatch(ui,/localStorage|sessionStorage/);});
test('core UI uses no dependency',()=>{assert.doesNotMatch(ui,/from ['"](?:react|vue|lit|@)/);});
