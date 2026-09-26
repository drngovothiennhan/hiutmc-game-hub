export const DISPLAY_MODE_KEY = 'hiutmc-game-hub-display-mode-v1';
const ALLOWED_MODES = new Set(['auto', 'mobile', 'pc']);

export function normalizeDisplayMode(value) {
  return ALLOWED_MODES.has(value) ? value : 'auto';
}

export function resolveDisplayMode(preference, viewportWidth = globalThis.innerWidth || 0) {
  const mode = normalizeDisplayMode(preference);
  if (mode !== 'auto') return mode;
  return viewportWidth > 0 && viewportWidth <= 720 ? 'mobile' : 'pc';
}

export function readDisplayModePreference(storage = globalThis.localStorage) {
  try {
    return normalizeDisplayMode(storage?.getItem(DISPLAY_MODE_KEY));
  } catch {
    return 'auto';
  }
}

export function saveDisplayModePreference(value, storage = globalThis.localStorage) {
  const mode = normalizeDisplayMode(value);
  try {
    storage?.setItem(DISPLAY_MODE_KEY, mode);
  } catch {
    // Keep the current session usable when storage is disabled or full.
  }
  return mode;
}

export function applyDisplayMode(root, preference) {
  const mode = resolveDisplayMode(preference);
  root?.setAttribute('data-ui-mode', mode);
  return mode;
}
