const CACHE_PREFIX = 'hiutmc-game-hub-shell-';
const CACHE_NAME = `${CACHE_PREFIX}v4`;
const CORE = [
  '/', '/manifest.webmanifest', '/service-worker.js', '/icons/game-hub.svg',
  '/assets/app.js', '/assets/app.css', '/src/styles.css', '/garden-decor-sprite.svg'
];

self.addEventListener('install', event => {
  event.waitUntil((async () => {
    const cache = await caches.open(CACHE_NAME);
    await cache.addAll(CORE);
    await self.skipWaiting();
  })());
});

self.addEventListener('activate', event => {
  event.waitUntil(caches.keys()
    .then(keys => Promise.all(keys.filter(key => key.startsWith(CACHE_PREFIX) && key !== CACHE_NAME).map(key => caches.delete(key))))
    .then(() => self.clients.claim()));
});

self.addEventListener('fetch', event => {
  const request = event.request;
  if (request.method !== 'GET' || new URL(request.url).origin !== self.location.origin) return;
  const url = new URL(request.url);
  if (/^\/(?:api|auth|rest|functions|rpc)(?:\/|$)/.test(url.pathname)) return;

  if (request.mode === 'navigate') {
    event.respondWith(fetch(request).catch(() => caches.match(request).then(cached => cached || caches.match('/'))));
    return;
  }

  const isStaticAsset = request.destination && ['script', 'style', 'image', 'font'].includes(request.destination)
    && (url.pathname.startsWith('/assets/') || url.pathname.startsWith('/icons/')
      || url.pathname.startsWith('/y-quan-live/') || url.pathname === '/src/styles.css'
      || url.pathname === '/garden-decor-sprite.svg');
  if (!isStaticAsset) return;

  event.respondWith((async () => {
    const cached = await caches.match(request);
    const network = fetch(request).then(response => {
      if (response.ok) void caches.open(CACHE_NAME).then(cache => cache.put(request, response.clone()));
      return response;
    });
    return cached || network;
  })());
});
