// LOGIN SCRIPT
       
       // Generador de partículas para el fondo
        function createParticles() {
            const container = document.getElementById('particles');
            const particleCount = 30;
            
            for (let i = 0; i < particleCount; i++) {
                const particle = document.createElement('div');
                particle.classList.add('particle');
                
                // Tamaño aleatorio entre 5px y 50px
                const size = Math.random() * 45 + 5;
                particle.style.width = `${size}px`;
                particle.style.height = `${size}px`;
                
                // Posición aleatoria
                particle.style.left = `${Math.random() * 100}%`;
                particle.style.top = `${Math.random() * 100}%`;
                
                // Opacidad aleatoria
                particle.style.opacity = Math.random() * 0.2 + 0.05;
                
                // Animación
                particle.style.animation = `float ${Math.random() * 10 + 10}s infinite ease-in-out`;
                particle.style.animationDelay = `${Math.random() * 5}s`;
                
                // Añadir al contenedor
                container.appendChild(particle);
            }
            
            // Añadir animación CSS
            const style = document.createElement('style');
            style.textContent = `
                @keyframes float {
                    0%, 100% { transform: translate(0, 0); }
                    25% { transform: translate(${Math.random() * 40 - 20}px, ${Math.random() * 40 - 20}px); }
                    50% { transform: translate(${Math.random() * 40 - 20}px, ${Math.random() * 40 - 20}px); }
                    75% { transform: translate(${Math.random() * 40 - 20}px, ${Math.random() * 40 - 20}px); }
                }
            `;
            document.head.appendChild(style);
        }
    //  FIN LOGIN
    /**************************************************************************************************** */
   
   
   window.addEventListener('DOMContentLoaded', () => {
  console.log('✅ scriptLogin.js CARGADO');

  const btn = document.getElementById('btnLogin');
  if (!btn) {
    console.error('❌ No se encontró el botón con id="btnLogin"');
    return;
  }

  btn.addEventListener('click', async (e) => {
    e.preventDefault();

    if (btn.disabled) return; // ⛔ Bloquea clics repetidos
    btn.disabled = true;

    const email = document.getElementById('email').value.trim();
    const password = document.getElementById('password').value.trim();

    if (!email || !password) {
      alert('Por favor completa todos los campos');
      btn.disabled = false;
      return;
    }

    console.log('📨 Enviando credenciales:', { email });

    try {
      const res = await fetch('http://localhost:3000/api/login', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ email, password })
      });

      const data = await res.json();
      console.log('📦 Respuesta del backend:', data);

      if (!res.ok || !data.usuario) {
        alert(data.mensaje || 'Credenciales incorrectas');
        btn.disabled = false;
        return;
      }

      // Guardar datos en localStorage
      const { id, nombre, rol, email: correo, avatar, sesionId } = data.usuario;
      localStorage.setItem('usuarioId', id);
      localStorage.setItem('nombre', nombre);
      localStorage.setItem('rol', rol);
      localStorage.setItem('email', correo);
      localStorage.setItem('avatar', avatar || '');
      localStorage.setItem('sesionId', sesionId);

      // Redirigir al dashboard
      window.location.href = '../html/dashboard.html';

    } catch (error) {
      console.error('❌ Error al iniciar sesión:', error);
      alert('No se pudo conectar al servidor');
      btn.disabled = false;
    }
  });
});
   
 