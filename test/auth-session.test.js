import test from 'node:test';
import assert from 'node:assert/strict';
import { bootstrapSession, logout, SESSION_STORAGE_KEY } from '../src/auth/session.js';

function tokenWithExpiry(expirySeconds) {
  const payload = Buffer.from(JSON.stringify({ exp: expirySeconds })).toString('base64url');
  return `header.${payload}.signature`;
}

function installBrowserMocks(t, { hash, authUser, authStatus = 200, refreshBody = {}, refreshStatus = 200, roleRows = [{ role: 'member' }], roleStatus = 200 }) {
  const original = {
    window: globalThis.window,
    localStorage: globalThis.localStorage,
    fetch: globalThis.fetch
  };
  const values = new Map();
  const calls = [];
  let replacedUrl = null;
  globalThis.window = {
    location: { hash, pathname: '/', search: '?from=ecosystem' },
    history: { replaceState: (_state, _title, url) => { replacedUrl = url; } }
  };
  globalThis.localStorage = {
    getItem: key => values.get(key) ?? null,
    setItem: (key, value) => values.set(key, String(value)),
    removeItem: key => values.delete(key)
  };
  globalThis.fetch = async (url, init = {}) => {
    calls.push({ url: String(url), init });
    const isRefresh = String(url).includes('/auth/v1/token?grant_type=refresh_token');
    const isRole = String(url).includes('/rest/v1/rpc/garden_hub_current_member_role_v1');
    return {
      ok: isRefresh ? refreshStatus >= 200 && refreshStatus < 300 : isRole ? roleStatus >= 200 && roleStatus < 300 : authStatus >= 200 && authStatus < 300,
      status: isRefresh ? refreshStatus : isRole ? roleStatus : authStatus,
      json: async () => isRefresh ? refreshBody : isRole ? roleRows : authUser
    };
  };
  t.after(() => {
    for (const key of Object.keys(original)) {
      if (original[key] === undefined) delete globalThis[key];
      else globalThis[key] = original[key];
    }
  });
  return { values, calls, getReplacedUrl: () => replacedUrl };
}

test('SSO bridge strips credentials from the URL and uses the trusted member claim', async t => {
  const accessToken = tokenWithExpiry(Math.floor(Date.now() / 1000) + 3600);
  const refreshToken = 'short-token';
  const mocks = installBrowserMocks(t, {
    hash: `#ecosystem_sso=1&access_token=${accessToken}&refresh_token=${refreshToken}`,
    authUser: {
      id: 'auth-user-id',
      app_metadata: { member_id: 'trusted-member-id', role: 'member' },
      user_metadata: { member_id: 'untrusted-member-id' }
    }
  });

  const result = await bootstrapSession();

  assert.equal(result.error, null);
  assert.equal(result.member.id, 'trusted-member-id');
  assert.equal(result.session.accessToken, accessToken);
  assert.equal(result.session.refreshToken, refreshToken);
  assert.equal(mocks.getReplacedUrl(), '/?from=ecosystem');
  assert.equal(result.member.role, 'member');
  assert.equal(mocks.calls.length, 2);
  assert.match(mocks.calls[0].url, /\/auth\/v1\/user$/);
  assert.match(mocks.calls[1].url, /\/rest\/v1\/rpc\/garden_hub_current_member_role_v1$/);
  assert.equal(mocks.values.get(SESSION_STORAGE_KEY) !== undefined, true);
  assert.equal(mocks.values.get(SESSION_STORAGE_KEY).includes('untrusted-member-id'), false);
});

test('role comes from the current server-side member record rather than a stale JWT claim', async t => {
  const accessToken = tokenWithExpiry(Math.floor(Date.now() / 1000) + 3600);
  const mocks = installBrowserMocks(t, {
    hash: `#ecosystem_sso=1&access_token=${accessToken}&refresh_token=${'r'.repeat(32)}`,
    authUser: { id: 'auth-user-id', app_metadata: { member_id: 'trusted-member-id', role: 'member' } },
    roleRows: [{ role: 'admin' }]
  });

  const result = await bootstrapSession();

  assert.equal(result.error, null);
  assert.equal(result.member.role, 'admin');
  assert.equal(mocks.calls.length, 2);
});

test('role lookup failures stay least-privileged and are reported instead of silently masking the failure', async t => {
  const accessToken = tokenWithExpiry(Math.floor(Date.now() / 1000) + 3600);
  const mocks = installBrowserMocks(t, {
    hash: `#ecosystem_sso=1&access_token=${accessToken}&refresh_token=${'r'.repeat(32)}`,
    authUser: { id: 'auth-user-id', app_metadata: { member_id: 'trusted-member-id' } },
    roleStatus: 404
  });

  const result = await bootstrapSession();

  assert.equal(result.error, null);
  assert.equal(result.member.role, 'member');
  assert.equal(mocks.calls.length, 3);
  assert.match(mocks.calls[2].url, /garden_hub_report_error_v1$/);
});

test('SSO bootstrap rejects a client-supplied member id without trusted app metadata', async t => {
  const accessToken = tokenWithExpiry(Math.floor(Date.now() / 1000) + 3600);
  const mocks = installBrowserMocks(t, {
    hash: `#ecosystem_sso=1&access_token=${accessToken}&refresh_token=${'s'.repeat(32)}`,
    authUser: { id: 'auth-user-id', user_metadata: { member_id: 'client-forged-id' } }
  });

  const result = await bootstrapSession();

  assert.equal(result.member, null);
  assert.match(result.error, /chưa liên kết hồ sơ HIU TMC/);
  assert.equal(mocks.calls.length, 1);
  assert.equal(mocks.values.has(SESSION_STORAGE_KEY), false);
});

test('SSO bridge rejects missing credentials, reports only field names, and clears the received fragment', async t => {
  const accessToken = tokenWithExpiry(Math.floor(Date.now() / 1000) + 3600);
  const mocks = installBrowserMocks(t, {
    hash: `#ecosystem_sso=1&access_token=${accessToken}`,
    authUser: { id: 'auth-user-id', app_metadata: { member_id: 'trusted-member-id' } }
  });

  const result = await bootstrapSession();

  assert.equal(result.member, null);
  assert.match(result.error, /refresh_token/);
  assert.doesNotMatch(result.error, /accessToken|refreshToken|[A-Za-z0-9_-]{40,}/);
  assert.equal(mocks.getReplacedUrl(), '/?from=ecosystem');
  assert.equal(mocks.calls.length, 0);
  assert.equal(mocks.values.has(SESSION_STORAGE_KEY), false);
});

test('SSO bridge rejects empty credentials and clears the fragment without logging values', async t => {
  const mocks = installBrowserMocks(t, {
    hash: '#ecosystem_sso=1&access_token=&refresh_token=',
    authUser: { id: 'auth-user-id', app_metadata: { member_id: 'trusted-member-id' } }
  });
  const invalidResult = await bootstrapSession();

  assert.equal(invalidResult.member, null);
  assert.match(invalidResult.error, /access_token, refresh_token/);
  assert.equal(mocks.getReplacedUrl(), '/?from=ecosystem');
  assert.equal(mocks.calls.length, 0);
});

test('SSO bridge rejects an access token Auth will not verify and clears it', async t => {
  const accessToken = tokenWithExpiry(Math.floor(Date.now() / 1000) + 3600);
  const mocks = installBrowserMocks(t, {
    hash: `#ecosystem_sso=1&access_token=${accessToken}&refresh_token=present`,
    authStatus: 401,
    authUser: { message: 'unauthorized' }
  });
  const result = await bootstrapSession();

  assert.equal(result.member, null);
  assert.match(result.error, /Không xác minh được phiên thành viên/);
  assert.doesNotMatch(result.error, /present|unauthorized/);
  assert.equal(mocks.getReplacedUrl(), '/?from=ecosystem');
  assert.equal(mocks.calls.length, 1);
  assert.equal(mocks.values.has(SESSION_STORAGE_KEY), false);
});

test('SSO bootstrap ignores an unrelated fragment without clearing it', async t => {
  const mocks = installBrowserMocks(t, {
    hash: '#tab=profile',
    authUser: { id: 'auth-user-id', app_metadata: { member_id: 'trusted-member-id' } }
  });
  const result = await bootstrapSession();

  assert.equal(result.error, null);
  assert.equal(result.member, null);
  assert.equal(mocks.getReplacedUrl(), null);
  assert.equal(mocks.calls.length, 0);
});

test('Game Hub logout clears its local session without revoking the shared HIU TMC session', async t => {
  const mocks = installBrowserMocks(t, {
    hash: '',
    authUser: { id: 'auth-user-id' }
  });
  mocks.values.set(SESSION_STORAGE_KEY, JSON.stringify({ accessToken: 'shared-access-token', refreshToken: 'shared-refresh-token' }));

  await logout();

  assert.equal(mocks.values.has(SESSION_STORAGE_KEY), false);
  assert.equal(mocks.calls.length, 0);
});
