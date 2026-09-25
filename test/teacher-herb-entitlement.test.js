import test from 'node:test';
import assert from 'node:assert/strict';
import { claimOrGetTeacherHerbEntitlement, isVerifiedTeacherHerbEntitlement } from '../src/entitlements/teacher-herb.js';

function installRpcMock(t, { status = 200, payload = [] } = {}) {
  const originalFetch = globalThis.fetch;
  let captured = null;
  globalThis.fetch = async (url, init) => {
    captured = { url: String(url), init };
    return { ok: status >= 200 && status < 300, status, json: async () => payload };
  };
  t.after(() => { globalThis.fetch = originalFetch; });
  return () => captured;
}

test('entitlement request uses the authenticated RPC without sending member identity', async t => {
  const capture = installRpcMock(t, {
    payload: [{ eligible: true, receipt_id: '123e4567-e89b-42d3-a456-426614174000', granted_at: '2026-09-25T11:00:00Z', reason: 'granted' }]
  });
  const result = await claimOrGetTeacherHerbEntitlement({ accessToken: 'fixture-access-token' });
  const request = capture();

  assert.equal(result.eligible, true);
  assert.equal(request.init.method, 'POST');
  assert.match(request.url, /teacher_herb_claim_or_get_entitlement_v1$/);
  assert.equal(request.init.body, '{}');
  assert.equal(request.init.headers.authorization, 'Bearer fixture-access-token');
  assert.equal(Object.hasOwn(JSON.parse(request.init.body), 'member_id'), false);
  assert.equal(request.url.includes('?'), false);
});

test('locked prerequisite and untrusted identity results stay locked', async t => {
  installRpcMock(t, { payload: [{ eligible: false, receipt_id: null, granted_at: null, reason: 'prerequisite_incomplete' }] });
  const result = await claimOrGetTeacherHerbEntitlement({ accessToken: 'fixture-access-token' });
  assert.deepEqual(result, { eligible: false, reason: 'prerequisite_incomplete' });
});

test('malformed receipt and unavailable RPC fail closed', async t => {
  installRpcMock(t, { payload: [{ eligible: true, receipt_id: 'forged', granted_at: 'not-a-date', reason: 'granted' }] });
  const malformed = await claimOrGetTeacherHerbEntitlement({ accessToken: 'fixture-access-token' });
  assert.deepEqual(malformed, { eligible: false, reason: 'unavailable' });

  const restore = globalThis.fetch;
  globalThis.fetch = async () => ({ ok: false, status: 404 });
  t.after(() => { globalThis.fetch = restore; });
  const unavailable = await claimOrGetTeacherHerbEntitlement({ accessToken: 'fixture-access-token' });
  assert.deepEqual(unavailable, { eligible: false, reason: 'unavailable' });
});

test('only a server receipt with eligible result can open the sequel view', () => {
  assert.equal(isVerifiedTeacherHerbEntitlement({ eligible: true, receiptId: '123e4567-e89b-42d3-a456-426614174000', grantedAt: '2026-09-25T11:00:00Z' }), true);
  assert.equal(isVerifiedTeacherHerbEntitlement({ eligible: true, receiptId: 'client-flag', grantedAt: '2026-09-25T11:00:00Z' }), false);
  assert.equal(isVerifiedTeacherHerbEntitlement({ eligible: true }), false);
});
