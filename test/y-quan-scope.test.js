import test from 'node:test';
import assert from 'node:assert/strict';
import { readFile } from 'node:fs/promises';
import { cases } from '../public/y-quan-live/interview/data.js';
import { SCOPE_NOTICE, RED_FLAG_FINDINGS, outOfScopeReason, inScopeCases } from '../public/y-quan-live/interview/scope.js';

test('every current Y Quan case is an outpatient YHCT case without red-flag findings', () => {
  assert.ok(cases.length > 0);
  for (const item of cases) {
    assert.equal(outOfScopeReason(item), '', `${item.id} must stay in scope`);
  }
  assert.equal(inScopeCases(cases).length, cases.length);
});

test('a case with an emergency finding is excluded from the practice pool', () => {
  const emergency = { id: 'x', keyFindings: ['fever', 'hematemesis'] };
  assert.equal(outOfScopeReason(emergency), 'red-flag');
  assert.deepEqual(inScopeCases([emergency, cases[0]]), [cases[0]]);
  for (const id of RED_FLAG_FINDINGS) {
    assert.equal(outOfScopeReason({ keyFindings: [id] }), 'red-flag');
  }
});

test('scope notice is shown on the waiting screen and in the hero', async () => {
  const app = await readFile(new URL('../public/y-quan-live/interview/app.js', import.meta.url), 'utf8');
  const game = await readFile(new URL('../public/y-quan-live/game.js', import.meta.url), 'utf8');
  assert.match(app, /SCOPE_NOTICE/);
  assert.match(game, /không tiếp nhận cấp cứu/);
  assert.equal(SCOPE_NOTICE.toLowerCase().includes('không tiếp nhận cấp cứu'), true);
});
