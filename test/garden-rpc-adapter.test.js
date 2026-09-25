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
  installStorage(t, { accessToken: 'fixture-access-token', refreshToken: 'fixture-refresh-token', expiresAt: Date.now() + 3600000 });
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


test('parallel Garden RPCs share one safe token refresh and store the rotated session', async t => {
  let stored = { accessToken: 'expired-access-token', refreshToken: 'old-refresh-token', expiresAt: Date.now() - 1, member: { id: 'fixture-member' } };
  const originalStorage = globalThis.localStorage;
  globalThis.localStorage = {
    getItem: key => key === SESSION_STORAGE_KEY ? JSON.stringify(stored) : null,
    setItem: (key, value) => { if (key === SESSION_STORAGE_KEY) stored = JSON.parse(value); }
  };
  t.after(() => { globalThis.localStorage = originalStorage; });
  const originalFetch = globalThis.fetch;
  let refreshes = 0;
  const rpcTokens = [];
  globalThis.fetch = async (url, init) => {
    if (String(url).includes('/auth/v1/token?grant_type=refresh_token')) {
      refreshes += 1;
      return { ok: true, json: async () => ({ access_token: 'rotated-access-token', refresh_token: 'rotated-refresh-token', expires_at: Math.floor((Date.now() + 3600000) / 1000) }) };
    }
    rpcTokens.push(init.headers.Authorization);
    return { ok: true, json: async () => [] };
  };
  t.after(() => { globalThis.fetch = originalFetch; });

  await Promise.all([gardenSupabase.rpc('herb_garden_state_v3'), gardenSupabase.rpc('herb_garden_inventory_v3')]);
  assert.equal(refreshes, 1);
  assert.deepEqual(rpcTokens, ['Bearer rotated-access-token', 'Bearer rotated-access-token']);
  assert.equal(stored.refreshToken, 'rotated-refresh-token');
  assert.deepEqual(stored.member, { id: 'fixture-member' });
});
