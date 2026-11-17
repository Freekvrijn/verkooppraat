/* VerkoopPraat – service worker (PWA).
   Bewaart alleen de app zelf, zodat hij snel opent en installeerbaar is.
   Supabase, Gemini en andere externe aanvragen gaan altijd rechtstreeks naar het netwerk en worden nooit bewaard. */
const CACHE = 'verkooppraat-v1';
const APP = ['./', './index.html', './manifest.webmanifest', './pwa/icon-192.png', './pwa/icon-512.png', './pwa/icon-maskable-512.png', './pwa/apple-touch-icon.png'];

self.addEventListener('install', (e) => {
  e.waitUntil(caches.open(CACHE).then((c) => c.addAll(APP)).then(() => self.skipWaiting()));
});

self.addEventListener('activate', (e) => {
  e.waitUntil(caches.keys().then((keys) => Promise.all(keys.filter((k) => k !== CACHE).map((k) => caches.delete(k)))).then(() => self.clients.claim()));
});

self.addEventListener('fetch', (e) => {
  const url = new URL(e.request.url);
  if (e.request.method !== 'GET' || url.origin !== self.location.origin) return; // database en AI: altijd live
  // Eerst het netwerk (zodat je altijd de nieuwste versie krijgt), bij geen verbinding de bewaarde versie.
  e.respondWith(
    fetch(e.request).then((res) => {
      if (res.ok) { const kopie = res.clone(); caches.open(CACHE).then((c) => c.put(e.request, kopie)); }
      return res;
    }).catch(() => caches.match(e.request).then((r) => r || caches.match('./index.html')))
  );
});
