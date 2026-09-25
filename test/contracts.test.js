import test from 'node:test';
import assert from 'node:assert/strict';
import { readRoute, writeRoute } from '../src/game-engine/router.js';
import { isLaunchable, worldMap } from '../src/data/world-map.js';
import { escapeHtml } from '../src/profile/profile.js';
import { buildLegacySsoUrl, SESSION_STORAGE_KEY } from '../src/auth/session.js';

test('router defaults to world map and parses supported views', () => {
  assert.deepEqual(readRoute(''), ['world']);
  assert.deepEqual(readRoute('#/skills'), ['skills']);
  assert.deepEqual(readRoute('#/achievements'), ['achievements']);
});

test('only explicitly connected legacy games are launchable', () => {
  const active = worldMap.filter(isLaunchable).map(place => place.id);
  assert.deepEqual(active, ['garden', 'clinic']);
  assert.ok(worldMap.filter(place => place.state === 'planned').every(place => !isLaunchable(place)));
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
