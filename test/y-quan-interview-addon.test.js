import test from 'node:test';
import assert from 'node:assert/strict';
import { cases, questions } from '../public/y-quan-live/interview/data.js';
import { createQuestionPlan, scoreAttempt } from '../public/y-quan-live/interview/engine.js';

test('Thap van plan is a reproducible 15-question set covering all ten core domains', () => {
  const first = createQuestionPlan(731204);
  const again = createQuestionPlan(731204);
  assert.deepEqual(first.map(q => q.id), again.map(q => q.id));
  assert.equal(first.length, 15);
  assert.equal(new Set(first.map(q => q.id)).size, 15);
  assert.equal(new Set(first.map(q => q.category)).size, 10);
  assert.equal(first.filter(q => q.primary).length, 10);
  assert.equal(first.filter(q => !q.primary).length, 5);
  for (const category of new Set(questions.map(q => q.category))) {
    assert.ok(first.some(q => q.category === category), `missing ${category}`);
  }
});

test('every case returns a fixed answer for every question bank entry', () => {
  for (const caseFile of cases) {
    assert.equal(Object.keys(caseFile.answers).length, questions.length, caseFile.id);
    for (const question of questions) {
      assert.ok(caseFile.answers[question.id]?.text, `${caseFile.id} missing ${question.id}`);
      assert.ok(caseFile.answers[question.id]?.expression, `${caseFile.id} missing expression ${question.id}`);
    }
  }
});

test('rubric score is bounded and rewards case-consistent reasoning', () => {
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
  assert.ok(good <= 100 && good >= 0);
  assert.ok(weak >= 0 && weak <= 100);
  assert.ok(good > weak);
});

test('beta route is linked from authenticated Y Quan and is included in the static build', async () => {
  const { readFile, access } = await import('node:fs/promises');
  const client = await readFile(new URL('../public/y-quan-live/game.js', import.meta.url), 'utf8');
  const page = await readFile(new URL('../public/y-quan-live/interview/index.html', import.meta.url), 'utf8');
  assert.match(client, /Luyện Thập vấn · Beta/);
  assert.match(client, /\/y-quan-live\/interview\//);
  assert.match(page, /interview\/app\.js/);
  await access(new URL('../dist/y-quan-live/interview/index.html', import.meta.url));
  await access(new URL('../dist/y-quan-live/interview/app.js', import.meta.url));
});
