import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';
import { claimOrGetGardenUnlockReceipt, isVerifiedGardenUnlockReceipt } from '../src/entitlements/garden-unlock.js';
import { canAccessGardenBeta } from '../src/auth/garden-beta-access.js';
import { renderWorldMap } from '../src/components/world-map.js';

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
  const result = await claimOrGetGardenUnlockReceipt({ accessToken: 'fixture-access-token' });
  const request = capture();

  assert.equal(result.eligible, true);
  assert.equal(request.init.method, 'POST');
  assert.match(request.url, /garden_hub_claim_or_get_receipt_v1$/);
  assert.equal(request.init.body, '{}');
  assert.equal(request.init.headers.authorization, 'Bearer fixture-access-token');
  assert.equal(Object.hasOwn(JSON.parse(request.init.body), 'member_id'), false);
  assert.equal(request.url.includes('?'), false);
});

test('unlinked identity results stay locked', async t => {
  installRpcMock(t, { payload: [{ eligible: false, receipt_id: null, granted_at: null, reason: 'identity_unlinked' }] });
  const result = await claimOrGetGardenUnlockReceipt({ accessToken: 'fixture-access-token' });
  assert.deepEqual(result, { eligible: false, reason: 'identity_unlinked' });
});

test('malformed receipt and unavailable RPC fail closed', async t => {
  installRpcMock(t, { payload: [{ eligible: true, receipt_id: 'forged', granted_at: 'not-a-date', reason: 'granted' }] });
  const malformed = await claimOrGetGardenUnlockReceipt({ accessToken: 'fixture-access-token' });
  assert.deepEqual(malformed, { eligible: false, reason: 'unavailable' });

  const restore = globalThis.fetch;
  globalThis.fetch = async () => ({ ok: false, status: 404 });
  t.after(() => { globalThis.fetch = restore; });
  const unavailable = await claimOrGetGardenUnlockReceipt({ accessToken: 'fixture-access-token' });
  assert.deepEqual(unavailable, { eligible: false, reason: 'unavailable' });
});

test('only a server receipt with eligible result can open the extended Garden runtime', () => {
  assert.equal(isVerifiedGardenUnlockReceipt({ eligible: true, receiptId: '123e4567-e89b-42d3-a456-426614174000', grantedAt: '2026-09-25T11:00:00Z' }), true);
  assert.equal(isVerifiedGardenUnlockReceipt({ eligible: true, receiptId: 'client-flag', grantedAt: '2026-09-25T11:00:00Z' }), false);
  assert.equal(isVerifiedGardenUnlockReceipt({ eligible: true }), false);
});

test('Garden beta is available to every linked HIU TMC member, regardless of role', () => {
  for (const role of ['admin', 'mod', 'super_mod', 'leader', 'member', 'guest', '']) {
    assert.equal(canAccessGardenBeta({ id: 'linked-member-id', role }), true);
  }
  assert.equal(canAccessGardenBeta({ id: '', role: 'member' }), false);
  assert.equal(canAccessGardenBeta({ role: 'admin' }), false);
  assert.equal(canAccessGardenBeta(null), false);
  assert.equal(renderWorldMap(null, null, false, false).includes('data-place-id="garden-continuation"'), false);
  assert.equal(renderWorldMap(null, null, true, true).includes('data-place-id="garden-continuation"'), true);
});


test('open beta migration verifies approved members and records redacted reports for Admin Center', () => {
  const migration = readFileSync(new URL('../supabase/migrations/20260926080000_garden_hub_open_beta_error_reporting_v1.sql', import.meta.url), 'utf8');
  assert.ok(migration.includes('auth.uid()'));
  assert.match(migration, /app_metadata/);
  assert.ok(migration.includes('m.auth_user_id = v_auth_user_id'));
  assert.ok(migration.includes("m.status::text = 'approved'"));
  assert.ok(migration.includes('m.login_enabled is true'));
  assert.doesNotMatch(migration, /role_restricted|v_member_role not in/);
  assert.ok(migration.includes('garden_hub_report_error_v1'));
  assert.ok(migration.includes('public.ecosystem_audit_log'));
  assert.ok(migration.includes("'game_hub_error'"));
  assert.ok(migration.includes('v_recent_count >= 30'));
});
