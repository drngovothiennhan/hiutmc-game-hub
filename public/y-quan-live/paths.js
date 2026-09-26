const GAME_HUB_MOUNT='/apps/game-hub/';

export function gameHubBasePath(pathname=globalThis.location?.pathname||'/') {
  const path=String(pathname||'/');
  const mountIndex=path.indexOf(GAME_HUB_MOUNT);
  return mountIndex<0?'/':path.slice(0,mountIndex+GAME_HUB_MOUNT.length);
}

export function gameHubPath(path,pathname=globalThis.location?.pathname||'/') {
  const value=String(path||'');
  if (/^(?:[a-z][a-z0-9+.-]*:|\/\/|#)/i.test(value)) return value;
  return gameHubBasePath(pathname)+value.replace(/^\/+/, '');
}
