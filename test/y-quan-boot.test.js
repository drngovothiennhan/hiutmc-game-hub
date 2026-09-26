import test from 'node:test';
import assert from 'node:assert/strict';
import { readFile } from 'node:fs/promises';
import { runInNewContext } from 'node:vm';

const source = await readFile(new URL('../service-worker.js', import.meta.url), 'utf8');

function worker(fetchResponse, scope='https://game.example/') {
  const handlers = new Map();
  const stored = [];
  const precached = [];
  const deleted = [];
  const cache = {
    match: async request => String(request) === '/' ? new Response('<html>Home</html>', { headers: { 'content-type': 'text/html' } }) : undefined,
    put: async (request, response) => stored.push([request, response]),
    addAll: async paths => precached.push(...paths)
  };
  runInNewContext(source, {
    self: { location: { origin: 'https://game.example' }, registration: { scope }, addEventListener: (name, fn) => handlers.set(name, fn), skipWaiting: async () => {}, clients: { claim: async () => {} } },
    caches: { open: async () => cache, match: cache.match, keys: async () => ['hiutmc-offline-v1','hiutmc-game-hub-shell-v3'], delete: async key => deleted.push(key) },
    fetch: async () => fetchResponse(), URL, Response, encodeURIComponent
  });
  return { handlers, stored, precached, deleted };
}

async function request(workerInstance, path, destination='script') {
  let result;
  workerInstance.handlers.get('fetch')({
    request: { url: 'https://game.example' + path, method: 'GET', destination, mode: destination === 'document' ? 'navigate' : 'cors' },
    respondWith: promise => { result = promise; }
  });
  return result;
}

test('a missing Y Quan module never receives the cached home document', async () => {
  const app = worker(() => { throw new Error('offline'); });
  const response = await request(app, '/y-quan-live/game.js');
  assert.equal(response.type, 'error');
});

test('a static host HTML fallback is rejected for a Y Quan module', async () => {
  const app = worker(() => new Response('<html>Home</html>', { headers: { 'content-type': 'text/html' } }));
  const response = await request(app, '/y-quan-live/game.js');
  assert.equal(response.type, 'error');
  assert.equal(app.stored.length, 0);
});

test('mounted Game Hub precaches only mounted build paths and leaves Eco cache intact', async () => {
  const app = worker(() => new Response('ok'), 'https://game.example/apps/game-hub/');
  let install;
  app.handlers.get('install')({ waitUntil: promise => { install = promise; } });
  await install;
  assert.ok(app.precached.includes('/apps/game-hub/y-quan-live/game.js'));
  assert.ok(app.precached.every(path => path.startsWith('/apps/game-hub/')));
  assert.ok(app.precached.every(path => !path.includes('/src/auth/session.js')));
  let activate;
  app.handlers.get('activate')({ waitUntil: promise => { activate = promise; } });
  await activate;
  assert.deepEqual(app.deleted, []);
});
