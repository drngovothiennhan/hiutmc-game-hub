const CACHE_NAME = 'hiutmc-game-hub-shell-v2';
const CORE = [
  '/', '/manifest.webmanifest', '/service-worker.js', '/icons/game-hub.svg',
  '/assets/app.js', '/assets/app.css', '/src/config.js', '/src/styles.css', '/garden-decor-sprite.svg',
  '/src/auth/session.js', '/src/game-engine/router.js',
  '/src/components/shell.js', '/src/components/world-map.js',
  '/src/data/world-map.js', '/src/profile/profile.js',
  '/src/skill-matrix/skill-matrix.js', '/src/achievements/achievements.js',
  '/src/modules/garden/index.js', '/src/modules/clinic/index.js',
  '/src/modules/meridian/index.js', '/src/modules/herbal/index.js',
  '/src/modules/four-diagnosis/index.js', '/src/modules/formulas/index.js'
];

self.addEventListener('install', event => {
  event.waitUntil(caches.open(CACHE_NAME).then(cache => cache.addAll(CORE)).then(() => self.skipWaiting()));
});

self.addEventListener('activate', event => {
  event.waitUntil(caches.keys().then(keys => Promise.all(keys.filter(key => key !== CACHE_NAME).map(key => caches.delete(key)))).then(() => self.clients.claim()));
});

self.addEventListener('fetch', event => {
  const request = event.request;
  if (request.method !== 'GET' || new URL(request.url).origin !== self.location.origin) return;
  event.respondWith(fetch(request).then(response => {
    if (response.ok) {
      const copy = response.clone();
      void caches.open(CACHE_NAME).then(cache => cache.put(request, copy));
    }
    return response;
  }).catch(() => caches.match(request).then(cached => cached || caches.match('/'))));
});
