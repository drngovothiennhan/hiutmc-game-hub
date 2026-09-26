import test from 'node:test';
import assert from 'node:assert/strict';
import {
  DISPLAY_MODE_KEY,
  applyDisplayMode,
  readDisplayModePreference,
  resolveDisplayMode,
  saveDisplayModePreference
} from '../src/ui/display-mode.js';

test('automatic display mode follows viewport width and explicit choice overrides it', () => {
  assert.equal(resolveDisplayMode('auto', 390), 'mobile');
  assert.equal(resolveDisplayMode('auto', 1024), 'pc');
  assert.equal(resolveDisplayMode('mobile', 1280), 'mobile');
  assert.equal(resolveDisplayMode('pc', 390), 'pc');
});

test('display preference persists and invalid values safely return to automatic mode', () => {
  const values = new Map();
  const storage = {
    getItem: key => values.get(key) ?? null,
    setItem: (key, value) => values.set(key, value)
  };
  assert.equal(readDisplayModePreference(storage), 'auto');
  assert.equal(saveDisplayModePreference('mobile', storage), 'mobile');
  assert.equal(values.get(DISPLAY_MODE_KEY), 'mobile');
  assert.equal(readDisplayModePreference(storage), 'mobile');
  assert.equal(saveDisplayModePreference('invalid', storage), 'auto');
});

test('display preference storage errors do not prevent the app from opening', () => {
  const brokenStorage = {
    getItem() { throw new Error('storage disabled'); },
    setItem() { throw new Error('storage disabled'); }
  };
  assert.equal(readDisplayModePreference(brokenStorage), 'auto');
  assert.equal(saveDisplayModePreference('pc', brokenStorage), 'pc');
});

test('resolved preference is applied to the application root', () => {
  let applied = '';
  const root = { setAttribute: (name, value) => { if (name === 'data-ui-mode') applied = value; } };
  assert.equal(applyDisplayMode(root, 'mobile'), 'mobile');
  assert.equal(applied, 'mobile');
});
