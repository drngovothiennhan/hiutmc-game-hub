import test from 'node:test';
import assert from 'node:assert/strict';
import { readRoute, writeRoute } from '../src/game-engine/router.js';
import { isLaunchable, worldMap } from '../src/data/world-map.js';
import { escapeHtml } from '../src/profile/profile.js';
import { buildLegacySsoUrl, SESSION_STORAGE_KEY } from '../src/auth/session.js';
import { renderWorldMap } from '../src/components/world-map.js';
import { canAccessGameHub } from '../src/auth/garden-beta-access.js';
import { renderAccessGate } from '../src/components/shell.js';

test('router defaults to world map and parses supported views', () => {
  assert.deepEqual(readRoute(''), ['world']);
  assert.deepEqual(readRoute('#/skills'), ['skills']);
  assert.deepEqual(readRoute('#/achievements'), ['achievements']);
});

test('only explicitly connected legacy games are launchable', () => {
  const active = worldMap.filter(isLaunchable).map(place => place.id);
  assert.deepEqual(active, ['garden', 'clinic']);
  assert.ok(worldMap.filter(place => place.state !== 'available-legacy').every(place => !isLaunchable(place)));
  const continuation = worldMap.find(place => place.id === 'garden-continuation');
  assert.equal(continuation.state, 'locked-continuation');
  assert.equal(continuation.href, '/garden-continuation');
});

test('Garden continuation opens after server receipt proof without a 9/9 prerequisite', () => {
  const waiting = renderWorldMap(null, null, true, true);
  assert.match(waiting, /Sẵn sàng sau xác minh SSO/);
  assert.doesNotMatch(waiting, /href="#\/garden-continuation"/);
  const unlocked = renderWorldMap(null, {
    eligible: true,
    receiptId: '123e4567-e89b-42d3-a456-426614174000',
    grantedAt: '2026-09-25T11:00:00Z'
  }, true, true);
  assert.match(unlocked, /Đã mở · thành viên HIU TMC/);
  assert.match(unlocked, /href="#\/garden-continuation"/);
});

test('profile display escapes untrusted identity fields', () => {
  assert.equal(escapeHtml('<img src=x onerror=alert(1)>'), '&lt;img src=x onerror=alert(1)&gt;');
});

test('Hub stores its session under an app-specific key', () => {
  assert.equal(SESSION_STORAGE_KEY, 'hiutmc-game-hub-session-v1');
});

test('route writes preserve a module path', () => {
  assert.equal(writeRoute(['skills']), '#/skills');
});

test('legacy game launch carries the existing ecosystem session in a fragment', () => {
  const url = new URL(buildLegacySsoUrl('https://example.invalid/garden', { accessToken: 'access', refreshToken: 'refresh' }));
  assert.equal(url.search, '');
  const bridge = new URLSearchParams(url.hash.slice(1));
  assert.equal(bridge.get('ecosystem_sso'), '1');
  assert.equal(bridge.get('access_token'), 'access');
  assert.equal(bridge.get('refresh_token'), 'refresh');
});

test('Game Hub accepts every linked HIU TMC member regardless of role', () => {
  for (const role of ['admin', 'mod', 'super_mod', 'leader', 'member']) {
    assert.equal(canAccessGameHub({ id: 'linked-member-id', role }), true);
  }
  assert.equal(canAccessGameHub({ role: 'admin' }), false);
  assert.equal(canAccessGameHub(null), false);
  const anonymousGate = renderAccessGate({ member: null });
  assert.match(anonymousGate, /Tiếp tục vào Game Hub/);
  assert.match(anonymousGate, /\?open=game-hub/);
  assert.doesNotMatch(anonymousGate, /Bản đồ|Thành tựu|Gia Viên|Năng lực/);
  const memberGate = renderAccessGate({ member: { role: 'member' } });
  assert.match(memberGate, /chưa liên kết hoặc tài khoản chưa được duyệt/);
  assert.doesNotMatch(memberGate, /topnav|Bản đồ|Gia Viên|Năng lực/);
});
