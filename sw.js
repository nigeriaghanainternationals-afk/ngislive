// NGIS Live App service worker v5 - lets the app open without internet.
// Pages: network first (always the newest version when online), saved copy when offline.
// Libraries / fonts / icons: saved after first use, then served instantly.
// Supabase data requests are NOT handled here (the app's offline layer manages those).
var CACHE='ngis-shell-v5';
var CORE=['./','index.html','manifest.json','icon-192.png','icon-512.png'];
self.addEventListener('install',function(e){
  e.waitUntil(caches.open(CACHE).then(function(c){return Promise.all(CORE.map(function(u){return c.add(u).catch(function(){});}));}).then(function(){return self.skipWaiting();}));
});
self.addEventListener('activate',function(e){
  e.waitUntil(caches.keys().then(function(keys){return Promise.all(keys.filter(function(k){return k!==CACHE;}).map(function(k){return caches.delete(k);}));}).then(function(){return self.clients.claim();}));
});
function timeout(ms){return new Promise(function(_,rej){setTimeout(function(){rej(new Error('timeout'));},ms);});}
self.addEventListener('fetch',function(e){
  var req=e.request;
  if(req.method!=='GET')return;
  var url=new URL(req.url);
  if(url.hostname.indexOf('supabase.co')>-1)return;                 // data: handled inside the app
  var sameOrigin=url.origin===self.location.origin;
  if(req.mode==='navigate'||(sameOrigin&&/\/(index\.html)?$/.test(url.pathname))){
    e.respondWith(
      Promise.race([fetch(req),timeout(6000)]).then(function(res){
        var copy=res.clone();caches.open(CACHE).then(function(c){c.put('index.html',copy);});
        return res;
      }).catch(function(){
        return caches.match('index.html').then(function(r){return r||caches.match('./');});
      })
    );
    return;
  }
  e.respondWith(
    caches.match(req).then(function(hit){
      if(hit)return hit;
      return fetch(req).then(function(res){
        if(res&&(res.status===200||res.type==='opaque')){var copy=res.clone();caches.open(CACHE).then(function(c){c.put(req,copy);});}
        return res;
      });
    })
  );
});
