import { readFile, stat } from 'node:fs/promises';

const worker = await readFile('dist/service-worker.js', 'utf8');
const manifest = JSON.parse(await readFile('dist/manifest.webmanifest', 'utf8'));
const coreMatch = worker.match(/const CORE = \[([\s\S]*?)\];/);
if (!coreMatch) throw new Error('Service worker is missing its precache asset list.');
const paths = [...coreMatch[1].matchAll(/'([^']+)'/g)].map(([, path]) => path);
if (!paths.length) throw new Error('Service worker precache list is empty.');

for (const path of paths) {
  const target = path === '/' ? 'dist/index.html' : `dist${path}`;
  try {
    await stat(target);
  } catch {
    throw new Error(`PWA precache asset does not exist in the production build: ${path}`);
  }
}

if (manifest.display !== 'standalone' || !manifest.display_override?.includes('standalone')) {
  throw new Error('PWA manifest must request standalone display mode.');
}
if (/\/src\/(?:auth|components|data|game-engine|modules|profile|skill-matrix)\//.test(coreMatch[1])) {
  throw new Error('PWA precache must not reference unshipped source modules.');
}
if (!worker.includes("key.startsWith(CACHE_PREFIX)")) {
  throw new Error('Service worker cleanup must be limited to Game Hub cache names.');
}

console.log(`PWA build validated: ${paths.length} precache assets exist and standalone display is configured.`);
