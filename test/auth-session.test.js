import test from 'node:test';
import assert from 'node:assert/strict';
import { bootstrapSession, SESSION_STORAGE_KEY } from '../src/auth/session.js';

function tokenWithExpiry(expirySeconds) {
  const payload = Buffer.from(JSON.stringify({ exp: expirySeconds })).toString('base64url');
  return `header.${payload}.signature`;
}

function installBrowserMocks(t, { hash, authUser, authStatus = 200, refreshBody = {}, refreshStatus = 200 }) {
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
    return {
      ok: isRefresh ? refreshStatus >= 200 && refreshStatus < 300 : authStatus >= 200 && authStatus < 300,
      status: isRefresh ? refreshStatus : authStatus,
      json: async () => isRefresh ? refreshBody : authUser
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
  const refreshedAccessToken = tokenWithExpiry(Math.floor(Date.now() / 1000) + 3600);
  const refreshedRefreshToken = 'rotated-short';
  const mocks = installBrowserMocks(t, {
    hash: `#ecosystem_sso=1&access_token=${accessToken}&refresh_token=${refreshToken}`,
    refreshBody: { access_token: refreshedAccessToken, refresh_token: refreshedRefreshToken },
    authUser: {
      id: 'auth-user-id',
      app_metadata: { member_id: 'trusted-member-id', role: 'member' },
      user_metadata: { member_id: 'untrusted-member-id' }
    }
  });

  const result = await bootstrapSession();

  assert.equal(result.error, null);
  assert.equal(result.member.id, 'trusted-member-id');
  assert.equal(result.session.accessToken, refreshedAccessToken);
  assert.equal(result.session.refreshToken, refreshedRefreshToken);
  assert.equal(mocks.getReplacedUrl(), '/?from=ecosystem');
  assert.equal(mocks.calls.length, 2);
  assert.match(mocks.calls[0].url, /\/auth\/v1\/token\?grant_type=refresh_token$/);
  assert.match(mocks.calls[1].url, /\/auth\/v1\/user$/);
  assert.equal(mocks.values.get(SESSION_STORAGE_KEY) !== undefined, true);
  assert.equal(mocks.values.get(SESSION_STORAGE_KEY).includes('untrusted-member-id'), false);
});

test('SSO bootstrap rejects a client-supplied member id without trusted app metadata', async t => {
  const accessToken = tokenWithExpiry(Math.floor(Date.now() / 1000) + 3600);
  const refreshedAccessToken = tokenWithExpiry(Math.floor(Date.now() / 1000) + 3600);
  const mocks = installBrowserMocks(t, {
    hash: `#ecosystem_sso=1&access_token=${accessToken}&refresh_token=${'s'.repeat(32)}`,
    refreshBody: { access_token: refreshedAccessToken, refresh_token: 'rotated-token' },
    authUser: { id: 'auth-user-id', user_metadata: { member_id: 'client-forged-id' } }
  });

  const result = await bootstrapSession();

  assert.equal(result.member, null);
  assert.match(result.error, /chưa liên kết hồ sơ HIU TMC/);
  assert.equal(mocks.calls.length, 2);
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

test('SSO bridge rejects a refresh token that Supabase does not redeem', async t => {
  const accessToken = tokenWithExpiry(Math.floor(Date.now() / 1000) + 3600);
  const mocks = installBrowserMocks(t, {
    hash: `#ecosystem_sso=1&access_token=${accessToken}&refresh_token=present`,
    refreshStatus: 400,
    refreshBody: { error: 'invalid_grant' },
    authUser: { id: 'auth-user-id', app_metadata: { member_id: 'trusted-member-id' } }
  });
  const result = await bootstrapSession();

  assert.equal(result.member, null);
  assert.match(result.error, /Không thể xác minh phiên đăng nhập/);
  assert.doesNotMatch(result.error, /present|invalid_grant/);
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
