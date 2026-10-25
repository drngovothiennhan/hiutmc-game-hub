import test from 'node:test';
import assert from 'node:assert/strict';
import { readFile } from 'node:fs/promises';

const text = await readFile(new URL('../public/_headers', import.meta.url), 'utf8');
const rules = text.split(/\r?\n/).filter(line => line && !line.startsWith('#'));

test('_headers only caches the preview media folder', () => {
  const paths = rules.filter(line => line.startsWith('/'));
  assert.deepEqual(paths, ['/gia-vien-duoc-thao-preview/assets/*']);
});

test('preview media cache is finite and not immutable', () => {
  const value = rules.find(line => /Cache-Control/i.test(line)) || '';
  assert.match(value, /max-age=604800/);
  assert.doesNotMatch(value, /immutable/);
});

test('app shell and service worker keep their default caching', () => {
  assert.doesNotMatch(text, /service-worker|index\.html|manifest|\/assets\/app/);
});
