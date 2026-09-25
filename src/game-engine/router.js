export function readRoute(hash = globalThis.location?.hash || '') {
  const normalized = hash.replace(/^#\/?/, '').trim();
  return normalized ? normalized.split('/').filter(Boolean) : ['world'];
}

export function writeRoute(route) {
  const parts = Array.isArray(route) ? route : [String(route)];
  const next = `#/${parts.map(part => encodeURIComponent(part)).join('/')}`;
  if (globalThis.location && globalThis.location.hash !== next) globalThis.location.hash = next;
  return next;
}
