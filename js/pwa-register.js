// Registrar el Service Worker
if ('serviceWorker' in navigator) {
  window.addEventListener('load', () => {
    navigator.serviceWorker.register('/sw.js')
      .then(registration => {
        console.log('✅ ServiceWorker registrado:', registration.scope);
      })
      .catch(error => {
        console.error('❌ Error al registrar ServiceWorker:', error);
      });
  });
}

// Instalación como PWA
let deferredPrompt;
window.addEventListener('beforeinstallprompt', (e) => {
  e.preventDefault();
  deferredPrompt = e;

  const installButton = document.getElementById('install-button');
  if (installButton) {
    installButton.style.display = 'inline-block';
    installButton.addEventListener('click', () => {
      deferredPrompt.prompt();
      deferredPrompt.userChoice.then(choiceResult => {
        if (choiceResult.outcome === 'accepted') {
          console.log('✅ Usuario aceptó la instalación');
        } else {
          console.log('❌ Usuario rechazó la instalación');
        }
        deferredPrompt = null;
        installButton.style.display = 'none';
      });
    });
  }
});