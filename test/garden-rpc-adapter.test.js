import test from 'node:test';
import assert from 'node:assert/strict';
import { gardenSupabase } from '../src/games/garden-supabase.js';
import { SESSION_STORAGE_KEY } from '../src/auth/session.js';
import { SUPABASE_URL } from '../src/config.js';

function installStorage(t, session) {
  const original = globalThis.localStorage;
  globalThis.localStorage = { getItem: key => key === SESSION_STORAGE_KEY ? JSON.stringify(session) : null };
  t.after(() => { globalThis.localStorage = original; });
}

test('Garden RPC adapter reuses the verified Hub session without placing it in URL or payload', async t => {
  installStorage(t, { accessToken: 'fixture-access-token' });
  const originalFetch = globalThis.fetch;
  let request;
  globalThis.fetch = async (url, init) => {
    request = { url: String(url), init };
    return { ok: true, json: async () => [{ slot_no: 1 }] };
  };
  t.after(() => { globalThis.fetch = originalFetch; });

  const result = await gardenSupabase.rpc('herb_garden_state_v3');
  assert.deepEqual(result, { data: [{ slot_no: 1 }], error: null });
  assert.equal(request.url, `${SUPABASE_URL}/rest/v1/rpc/herb_garden_state_v3`);
  assert.equal(request.init.headers.Authorization, 'Bearer fixture-access-token');
  assert.equal(request.init.body, '{}');
  assert.equal(request.url.includes('fixture-access-token'), false);
  assert.equal(request.init.body.includes('fixture-access-token'), false);
});

test('Garden RPC adapter fails closed when the verified Hub session is absent', async t => {
  installStorage(t, null);
  const originalFetch = globalThis.fetch;
  globalThis.fetch = async () => { throw new Error('unexpected network request'); };
  t.after(() => { globalThis.fetch = originalFetch; });

  const result = await gardenSupabase.rpc('herb_garden_state_v3');
  assert.equal(result.data, null);
  assert.ok(result.error instanceof Error);
  assert.match(result.error.message, /Phiên đăng nhập/);
});
