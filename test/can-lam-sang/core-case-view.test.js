import test from 'node:test';import assert from 'node:assert/strict';import fs from 'node:fs';
const ui=fs.readFileSync('src/can-lam-sang/core/case-ui.mjs','utf8');
test('review label is rendered whenever server returns a non-null label',()=>{assert.match(ui,/data-review-label/);assert.match(ui,/review_label/);assert.match(ui,/textContent = label/);});
test('answer is not written to browser storage',()=>{assert.doesNotMatch(ui,/localStorage|sessionStorage/);});
test('core UI uses no dependency',()=>{assert.doesNotMatch(ui,/from ['"](?:react|vue|lit|@)/);});

test('core page points to the bundled lazy entry and uses the real submit signature',()=>{const page=fs.readFileSync('public/can-lam-sang/core/index.html','utf8');const js=fs.readFileSync('public/can-lam-sang/core/core.js','utf8');const build=fs.readFileSync('scripts/build.mjs','utf8');assert.match(page,/\/assets\/can-lam-sang\/core\/core\.js/);assert.match(build,/splitting:\s*true/);assert.match(build,/outdir:\s*['"]dist\/assets['"]/);assert.match(js,/p_module:'core'/);assert.match(js,/p_answers:value/);});

test('review label stays server-owned and cannot be hidden by UI helpers',()=>{assert.match(ui,/if \(label == null\) return/);assert.match(ui,/textContent = label/);assert.doesNotMatch(ui,/hide|dismiss|close.*review/i);});
