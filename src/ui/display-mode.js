export const DISPLAY_MODE_STORAGE_KEY = 'hiutmc-game-hub-display-mode-v1';
export const DISPLAY_MODES = Object.freeze(['auto', 'mobile', 'pc']);

function getDefaultStorage() {
  try {
    return globalThis.localStorage;
  } catch {
    return null;
  }
}

function isDisplayMode(value) {
  return DISPLAY_MODES.includes(value);
}

export function createDisplayModeController({
  storage = getDefaultStorage(),
  matchMedia = query => globalThis.matchMedia?.(query),
  root = globalThis.document?.documentElement
} = {}) {
  let preference = 'auto';
  let mediaQuery = null;

  try {
    const saved = storage?.getItem(DISPLAY_MODE_STORAGE_KEY);
    if (isDisplayMode(saved)) preference = saved;
  } catch {
    // Browser privacy settings can deny storage; the in-memory preference still works.
  }

  function detectedMode() {
    try {
      return matchMedia('(min-width: 760px) and (pointer: fine)')?.matches ? 'pc' : 'mobile';
    } catch {
      return 'mobile';
    }
  }

  function snapshot() {
    return {
      preference,
      effective: preference === 'auto' ? detectedMode() : preference
    };
  }

  function apply() {
    const state = snapshot();
    if (root) {
      root.dataset.displayMode = state.effective;
      root.dataset.displayModePreference = state.preference;
    }
    return state;
  }

  function set(next) {
    if (!isDisplayMode(next)) return apply();
    preference = next;
    try {
      storage?.setItem(DISPLAY_MODE_STORAGE_KEY, preference);
    } catch {
      // Keep the selected mode for this page even if persistent storage is blocked.
    }
    return apply();
  }

  function cycle() {
    const index = DISPLAY_MODES.indexOf(preference);
    return set(DISPLAY_MODES[(index + 1) % DISPLAY_MODES.length]);
  }

  function init() {
    apply();
    try {
      mediaQuery = matchMedia('(min-width: 760px) and (pointer: fine)');
      mediaQuery?.addEventListener?.('change', () => {
        if (preference === 'auto') apply();
      });
    } catch {
      // Older browsers may not expose matchMedia; the mobile layout is the safe fallback.
    }
    return snapshot();
  }

  return { cycle, init, set, snapshot };
}
