const CACHE_NAME = 'jurigo-cache-v1';
const urlsToCache = [
  '/html/dashboard.html',
  '/html/Calendario.html',
  '/html/Casos.html',
  '/html/Chat.html',
  '/html/Clientes.html',
  '/html/Documentos.html',
  '/html/login.html',
  '/css/stylesdashboard.css',
  '/css/styleslogin.css',
  '/css/csstodo.css',
  '/js/scriptdashboard.js',
  '/js/pwa-register.js',
  '/manifest.json',
  '/icons/icon-192.png',
  '/icons/icon-512.png'
];

self.addEventListener('install', event => {
  event.waitUntil(
    caches.open(CACHE_NAME)
      .then(cache => cache.addAll(urlsToCache))
  );
});

self.addEventListener('fetch', event => {
  event.respondWith(
    caches.match(event.request)
      .then(response => response || fetch(event.request))
  );
});

self.addEventListener('activate', event => {
  const cacheWhitelist = [CACHE_NAME];
  event.waitUntil(
    caches.keys().then(cacheNames => 
      Promise.all(
        cacheNames.map(cacheName => {
          if (!cacheWhitelist.includes(cacheName)) {
            return caches.delete(cacheName);
          }
        })
      )
    )
  );
});