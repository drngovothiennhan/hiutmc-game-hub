import test from 'node:test';
import assert from 'node:assert/strict';
import { createDisplayModeController, DISPLAY_MODE_STORAGE_KEY } from '../src/ui/display-mode.js';
import { renderAccessGate, renderDisplayModeToggle, renderShell } from '../src/components/shell.js';

function makeMedia(matches = false) {
  const listeners = new Set();
  return {
    get matches() { return matches; },
    addEventListener(type, listener) { if (type === 'change') listeners.add(listener); },
    setMatches(value) {
      matches = value;
      for (const listener of listeners) listener({ matches });
    }
  };
}

test('auto mode follows viewport changes and updates the document display mode', () => {
  const media = makeMedia(false);
  const root = { dataset: {} };
  const controller = createDisplayModeController({ storage: null, matchMedia: () => media, root });

  assert.deepEqual(controller.init(), { preference: 'auto', effective: 'mobile' });
  assert.equal(root.dataset.displayMode, 'mobile');
  media.setMatches(true);
  assert.equal(root.dataset.displayMode, 'pc');
  assert.equal(root.dataset.displayModePreference, 'auto');
});

test('manual mode persists and cycle returns to automatic detection', () => {
  const values = new Map();
  const storage = {
    getItem: key => values.get(key) ?? null,
    setItem: (key, value) => values.set(key, value)
  };
  const media = makeMedia(true);
  const first = createDisplayModeController({ storage, matchMedia: () => media, root: { dataset: {} } });
  first.init();
  first.set('mobile');

  assert.equal(values.get(DISPLAY_MODE_STORAGE_KEY), 'mobile');
  const second = createDisplayModeController({ storage, matchMedia: () => media, root: { dataset: {} } });
  assert.deepEqual(second.init(), { preference: 'mobile', effective: 'mobile' });
  assert.deepEqual(second.cycle(), { preference: 'pc', effective: 'pc' });
  assert.deepEqual(second.cycle(), { preference: 'auto', effective: 'pc' });
});

test('blocked localStorage does not prevent choosing a mode for the current page', () => {
  const storage = {
    getItem() { throw new Error('storage blocked'); },
    setItem() { throw new Error('storage blocked'); }
  };
  const controller = createDisplayModeController({ storage, matchMedia: () => makeMedia(false), root: { dataset: {} } });

  assert.doesNotThrow(() => controller.init());
  assert.deepEqual(controller.set('pc'), { preference: 'pc', effective: 'pc' });
});

test('mode control tells the user both the active mode and next choice', () => {
  const markup = renderDisplayModeToggle({ preference: 'auto', effective: 'pc' });
  assert.match(markup, /Tự động · PC/);
  assert.match(markup, /chuyển sang Mobile/);
  assert.match(markup, /aria-label="Chế độ hiển thị: Tự động · PC/);
  assert.match(markup, /data-display-mode-toggle/);
});

test('mode control stays available in both the app shell and sign-in gate', () => {
  assert.match(renderShell({ member: null }), /data-display-mode-toggle/);
  assert.match(renderAccessGate({ member: null }), /data-display-mode-toggle/);
});
