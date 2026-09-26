import test from 'node:test';
import assert from 'node:assert/strict';
import { execFileSync } from 'node:child_process';
import { questions, cases } from '../public/y-quan-live/interview/data.js';
import { createQuestionPlan, scoreAttempt, starsForScore } from '../public/y-quan-live/interview/engine.js';

test('the Thap van question bank has 220 unique prompts evenly spread over ten domains', () => {
  assert.equal(questions.length, 220);
  assert.equal(new Set(questions.map(q => q.id)).size, 220);
  const categories = [...new Set(questions.map(q => q.category))];
  assert.equal(categories.length, 10);
  for (const category of categories) {
    assert.equal(questions.filter(q => q.category === category).length, 22, category);
  }
});

test('every seeded case selects exactly ten different prompts, one per domain', () => {
  const first = createQuestionPlan(731204);
  const again = createQuestionPlan(731204);
  assert.deepEqual(first.map(q => q.id), again.map(q => q.id));
  assert.equal(first.length, 10);
  assert.equal(new Set(first.map(q => q.id)).size, 10);
  assert.equal(new Set(first.map(q => q.category)).size, 10);
  assert.ok(createQuestionPlan(731205).some((q, i) => q.id !== first[i].id));
});

test('each case gives a coherent patient response for every selected domain', () => {
  const categories = [...new Set(questions.map(q => q.category))];
  for (const caseFile of cases) {
    assert.equal(Object.keys(caseFile.answersByCategory).length, 10, caseFile.id);
    for (const category of categories) {
      assert.ok(caseFile.answersByCategory[category]?.text, caseFile.id + ' missing ' + category);
      assert.ok(caseFile.answersByCategory[category]?.expression, caseFile.id + ' missing expression ' + category);
    }
  }
});

test('score is a bounded percentage and bot stars follow the score thresholds', () => {
  const caseFile = cases[0];
  const asked = createQuestionPlan(8);
  const good = scoreAttempt({
    asked, captured: caseFile.keyFindings, selectedB8C: caseFile.b8c,
    selectedPattern: caseFile.id, selectedPrinciple: caseFile.principles[0], caseFile
  });
  const weak = scoreAttempt({
    asked, captured: [], selectedB8C: ['Biểu','Hàn'],
    selectedPattern: cases[1].id, selectedPrinciple: cases[1].principles[0], caseFile
  });
  assert.equal(good, 100);
  assert.equal(starsForScore(good), 5);
  assert.ok(weak >= 0 && weak <= 100);
  assert.ok(good > weak);
  assert.equal(starsForScore(89), 4);
  assert.equal(starsForScore(64), 2);
  assert.equal(starsForScore(20), 1);
});

test('Y Quan defaults to the Thap van practice module with a one-time doctor introduction', async () => {
  const { readFile } = await import('node:fs/promises');
  const client = await readFile(new URL('../public/y-quan-live/game.js', import.meta.url), 'utf8');
  const page = await readFile(new URL('../public/y-quan-live/interview/index.html', import.meta.url), 'utf8');
  const build = await readFile(new URL('../scripts/build.mjs', import.meta.url), 'utf8');
  assert.match(client, /page='practice'/);
  assert.match(client, /hiu-yquan-practice-welcome-v1/);
  assert.match(client, /220 câu/);
  assert.match(client, /tối thiểu 90 phút/);
  assert.ok(client.includes("gameHubPath('y-quan-live/interview/')"));
  assert.ok(client.includes("interviewUrl.searchParams.set('v',Y_QUAN_ROUTE_VERSION)"));
  assert.ok(client.includes("const Y_QUAN_ROUTE_VERSION='20260926.2'"));
  assert.ok(page.includes('app.js?v=20260926.2'));
  assert.ok(page.includes('y-quan-live/?v=20260926.2'));
  assert.ok(page.includes("import(base+'y-quan-live/interview/app.js?v="));
  assert.match(build, /cp\('public', 'dist', \{ recursive: true \}\)/);
});

test('Thap van browser module parses as an ES module', async () => {
  const { readFile } = await import('node:fs/promises');
  const app = await readFile(new URL('../public/y-quan-live/interview/app.js', import.meta.url), 'utf8');
  assert.doesNotThrow(() => execFileSync(process.execPath, ['--input-type=module', '--check'], { input: app }));
});
