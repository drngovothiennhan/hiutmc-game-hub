import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';
import { cases } from '../public/y-quan-live/interview/data.js';
import { findingLabels } from '../public/y-quan-live/interview/cases-extra.js';

const sql = readFileSync(new URL('../supabase/migrations/20260929170000_y_quan_case_library_v1.sql', import.meta.url), 'utf8');
const list = text => [...text.matchAll(/'([^']*)'/g)].map(match => match[1]);

const rows = [...sql.matchAll(/\('([a-z-]+)','([^']*)','([^']*)',\s*array\[([^\]]*)\],array\[([^\]]*)\],\s*'(\[\[.*?\]\])'::jsonb\)/gs)].map(match => ({
  id: match[1], prompt: match[2], pattern: match[3], terms: list(match[4]), b8c: list(match[5]), groups: JSON.parse(match[6])
}));

test('the server case library and the browser cases describe the same 13 scenarios', () => {
  assert.equal(cases.length, 13);
  assert.equal(new Set(cases.map(item => item.id)).size, 13);
  assert.equal(rows.length, 13);
  assert.deepEqual(rows.map(row => row.id).sort(), cases.map(item => item.id).sort());
  for (const row of rows) {
    const item = cases.find(candidate => candidate.id === row.id);
    assert.equal(row.pattern, item.pattern, row.id);
    assert.deepEqual(row.b8c, item.b8c, row.id);
    assert.equal(item.complaint.replace(/^“|”$/g, ''), row.prompt, row.id);
  }
});

test('the diagnosis text the browser sends earns the server diagnosis and Bat cuong points', () => {
  for (const item of cases) {
    const row = rows.find(candidate => candidate.id === item.id);
    const diagnosis = (item.pattern + ' | Bát cương: ' + item.b8c.join(' · ')).toLowerCase();
    assert.ok(row.terms.some(term => diagnosis.includes(term)), item.id + ' diagnosis term');
    assert.ok(diagnosis.includes('bát cương: ' + row.b8c.join(' · ').toLowerCase()), item.id + ' Bat cuong phrase');
    // A different scenario's pattern must not earn this scenario's diagnosis points.
    for (const other of cases.filter(candidate => candidate.id !== item.id)) {
      const wrong = (other.pattern + ' | Bát cương: ' + other.b8c.join(' · ')).toLowerCase();
      assert.equal(row.terms.some(term => wrong.includes(term)), false, item.id + ' matched by ' + other.id);
    }
  }
});

test('every reasoning group can be earned from what the patient actually says', () => {
  for (const item of cases) {
    const row = rows.find(candidate => candidate.id === item.id);
    const spoken = Object.values(item.answersByCategory).map(answer => answer.text).join(' ').toLowerCase();
    assert.ok(row.groups.length >= 5, item.id);
    for (const group of row.groups) {
      assert.ok(group.some(term => spoken.includes(term)), item.id + ' unreachable group: ' + group[0]);
    }
  }
});

test('every key finding is revealed by an answer and has a readable label', () => {
  const app = readFileSync(new URL('../public/y-quan-live/interview/app.js', import.meta.url), 'utf8');
  const labelled = id => Boolean(findingLabels[id]) || new RegExp("[\\s{,]'?" + id + "'?:").test(app);
  for (const item of cases) {
    const revealed = new Set(Object.values(item.answersByCategory).flatMap(answer => answer.findings || []));
    for (const finding of item.keyFindings) assert.ok(revealed.has(finding), item.id + ' never reveals ' + finding);
  }
  for (const item of cases.slice(3)) {
    for (const finding of item.keyFindings) {
      assert.ok(labelled(finding), 'missing label for ' + finding);
    }
  }
});

test('the migration is additive and data-driven', () => {
  assert.match(sql, /create table if not exists y_quan_private\.case_library/);
  assert.match(sql, /revoke all on y_quan_private\.case_library from public, anon, authenticated/);
  assert.match(sql, /on conflict \(profile_id\) do update/);
  assert.match(sql, /join shuffled sh on sh\.rn = \(\(g\.n - 1\) % sh\.total\) \+ 1/);
  assert.match(sql, /if n <> 10 then\s+raise exception 'Complete all ten Thap van domains before submitting'/);
  assert.match(sql, /diagnosis_points\+b8c_points\+inquiry_points\+reasoning_points/);
  assert.doesNotMatch(sql, /\b(drop table|truncate|delete from)\b/i);
});
