const BASE = new URL(self.registration.scope).pathname;
const CACHE_PREFIX = 'hiutmc-game-hub-shell-' + encodeURIComponent(BASE);
const CACHE_NAME = CACHE_PREFIX + '-v4';
const CORE = [
  '/', '/manifest.webmanifest', '/service-worker.js', '/icons/game-hub.svg',
  '/assets/app.js', '/assets/app.css', '/src/styles.css', '/garden-decor-sprite.svg',
  '/y-quan-live/index.html', '/y-quan-live/game.js', '/y-quan-live/game.css',
  '/y-quan-live/interview/index.html', '/y-quan-live/interview/app.js',
  '/y-quan-live/interview/interview.css'
];

self.addEventListener('install', event => {
  event.waitUntil(caches.open(CACHE_NAME).then(cache => cache.addAll(CORE.map(path => BASE + path.slice(1)))).then(() => self.skipWaiting()));
});

self.addEventListener('activate', event => {
  event.waitUntil(caches.keys().then(keys => Promise.all(keys.filter(key =>
    (key.startsWith(CACHE_PREFIX) || (BASE === '/' && key === 'hiutmc-game-hub-shell-v3')) && key !== CACHE_NAME
  ).map(key => caches.delete(key)))).then(() => self.clients.claim()));
});

self.addEventListener('fetch', event => {
  const request = event.request;
  if (request.method !== 'GET' || new URL(request.url).origin !== self.location.origin) return;
  const destination = request.destination;
  const isScript = destination === 'script' || request.url.endsWith('.js');
  const isStyle = destination === 'style' || request.url.endsWith('.css');
  event.respondWith(fetch(request).then(response => {
    const type = (response.headers.get('content-type') || '').toLowerCase();
    const validAsset = (!isScript || /javascript|ecmascript/.test(type)) &&
      (!isStyle || type.includes('text/css'));
    if (response.ok && validAsset) {
      const copy = response.clone();
      void caches.open(CACHE_NAME).then(cache => cache.put(request, copy));
    }
    // Static hosts may serve index.html with status 200 for a missing .js file.
    // Never feed that HTML to the module loader or store it under a script URL.
    return validAsset ? response : Response.error();
  }).catch(async () => {
    const cached = await (await caches.open(CACHE_NAME)).match(request);
    if (cached) return cached;
    if (request.mode === 'navigate') return (await (await caches.open(CACHE_NAME)).match(BASE)) || Response.error();
    return Response.error();
  }));
});
