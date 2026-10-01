import test from 'node:test';
import assert from 'node:assert/strict';
import { readFile } from 'node:fs/promises';

const read = path => readFile(new URL(path, import.meta.url), 'utf8');

test('Tu Chan Cac is launched from the world map as its own self-contained game', async () => {
  const map = await read('../src/data/world-map.js');
  const entry = map.match(/\{ id: 'four-diagnosis',[^\n]+/);
  assert.ok(entry);
  assert.match(entry[0], /state: 'available-live'/);
  assert.match(entry[0], /href: '\/tu-chan\/'/);
});

test('Tu Chan page embeds the case bank and does not need a network or secret', async () => {
  const html = await read('../public/tu-chan/index.html');
  assert.match(html, /<title>Trực Tứ Chẩn<\/title>/);
  const m = html.match(/<script type="application\/json" id="bank-data">([\s\S]*?)<\/script>/);
  assert.ok(m, 'bank-data missing');
  const packs = JSON.parse(m[1]);
  const cases = (Array.isArray(packs) ? packs : Object.values(packs)).flatMap(p => p.cases || p);
  assert.ok(cases.length >= 19, 'expected at least 19 cases, got ' + cases.length);
  assert.doesNotMatch(html, /service[_-]?role|secret|password/i);
});
