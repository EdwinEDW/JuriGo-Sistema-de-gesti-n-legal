            // Simulación de interacciones
            document.querySelectorAll('.nav-item').forEach(item => {
                item.addEventListener('click', function() {
                    document.querySelectorAll('.nav-item').forEach(el => {
                        el.classList.remove('active');
                    });
                    this.classList.add('active');
                });
            });
            
            // Simular notificación
            document.querySelector('.notification-btn').addEventListener('click', function() {
                this.querySelector('.notification-count').textContent = '0';
                alert('Tienes nuevas notificaciones');
            });
       

            /////////////////////////////////////////
     // Simular notificaciones
        document.querySelectorAll('.nav-item').forEach(item => {
            item.addEventListener('click', function(e) {
                e.preventDefault();
                
                // Actualizar navegación
                document.querySelectorAll('.nav-item').forEach(el => {
                    el.classList.remove('active');
                });
                this.classList.add('active');
                
                // Actualizar título del contenido
                const itemName = this.querySelector('span').textContent;
                document.querySelector('.content-title').textContent = itemName;
                
                // Animación
                document.querySelector('.content-title').style.animation = 'none';
                setTimeout(() => {
                    document.querySelector('.content-title').style.animation = 'fadeIn 0.8s ease-out forwards';
                }, 10);
            });
        });
        

        
        // Efecto de carga inicial
        document.addEventListener('DOMContentLoaded', function() {
            setTimeout(() => {
                document.querySelector('.logo').style.transform = 'scale(1.1)';
                setTimeout(() => {
                    document.querySelector('.logo').style.transform = 'scale(1)';
                }, 300);
            }, 500);
        });

        /* - Si el usuario recarga o abre otra pestaña, su sesión sigue validada.
- Si alguien intenta entrar sin login, será redirigido.
- Todo se conecta la base de datos real.
 */
/**************************************************************************************************** */

window.addEventListener('DOMContentLoaded', () => {
  console.log('✅ scriptLogin.js cargado correctamente');

  const btnLogin = document.getElementById('btnLogin');
  const loginForm = document.getElementById('loginForm');
  
  if (!btnLogin || !loginForm) {
    console.error('❌ Elementos críticos no encontrados');
    return;
  }

  // Remover cualquier listener previo para evitar duplicados
  btnLogin.replaceWith(btnLogin.cloneNode(true));
  const cleanBtnLogin = document.getElementById('btnLogin');
  
  // Controlador único para el evento submit
  loginForm.addEventListener('submit', async (e) => {
    e.preventDefault();
    
    const email = document.getElementById('email').value.trim();
    const password = document.getElementById('password').value.trim();

    // Validación mejorada
    if (!validateEmail(email)) {
      showError('Email inválido');
      return;
    }

    if (password.length < 8) {
      showError('Contraseña demasiado corta (mín. 8 caracteres)');
      return;
    }

    // Deshabilitar UI durante la petición
    cleanBtnLogin.disabled = true;
    cleanBtnLogin.innerHTML = 'Verificando... <span class="spinner"></span>';

    try {
      const response = await fetch('http://localhost:3000/api/login', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ email, password })
      });

      const result = await response.json();

      if (!response.ok) {
        throw new Error(result.mensaje || 'Error en autenticación');
      }

      // Guardar solo datos esenciales
      sessionStorage.setItem('userId', result.usuario.id);
      sessionStorage.setItem('userName', sanitizeInput(result.usuario.nombre));
      sessionStorage.setItem('userRole', result.usuario.rol);
      
      // Redirigir con URL absoluta
      window.location.href = '/frontend/html/dashboard.html';
      
    } catch (error) {
      console.error('Error en login:', error);
      showError(error.message || 'Error en el servidor');
      
      // Restaurar UI
      cleanBtnLogin.disabled = false;
      cleanBtnLogin.textContent = 'Iniciar sesión';
    }
  });

  // Funciones auxiliares
  function validateEmail(email) {
    const re = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return re.test(email);
  }

  function sanitizeInput(input) {
    return input.replace(/<[^>]*>/g, '');
  }

  function showError(message) {
    const errorEl = document.getElementById('login-error');
    if (errorEl) {
      errorEl.textContent = message;
      errorEl.style.display = 'block';
    } else {
      alert(message); // Fallback
    }
  }
});
/************************************** */

              //         sesión CARGAR USUARIO los nombres ****************

document.addEventListener('DOMContentLoaded', () => {
  const nombre = localStorage.getItem('nombre');
  const rol = localStorage.getItem('rol');

  const nombreElemento = document.getElementById('nombre-usuario');
  const rolElemento = document.getElementById('cargo-usuario');
  const avatarElemento = document.getElementById('avatar-iniciales');

  if (nombre) {
    nombreElemento.textContent = nombre;

    const iniciales = nombre.trim().split(' ')
      .map(p => p[0]?.toUpperCase())
      .slice(0, 2)
      .join('');

    avatarElemento.textContent = iniciales;
  }

  if (rol) {
    rolElemento.textContent = rol;
  }

  /* Botón cerrar sesión*/

});
              //         sesión CARGAR USUARIO los nombres ****************
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
document.addEventListener('DOMContentLoaded', () => {
  const usuarioId = sessionStorage.getItem('userId');


  // Llenar widgets
  fetch(`http://localhost:3000/api/dashboard/resumen?usuarioId=${usuarioId}`)
    .then(res => res.json())
    .then(data => {
      document.getElementById('casos-activos').textContent = data.CasosActivos;
      document.getElementById('nuevos-casos').textContent = `${data.NuevosCasosSemana} nuevos esta semana`;
      document.getElementById('citas-hoy').textContent = data.CitasHoy;
      document.getElementById('proxima-cita').textContent = data.ProximaCita || 'Sin agenda';
      document.getElementById('tareas-pendientes').textContent = data.TareasPendientes;
      document.getElementById('urgentes').textContent = `${data.TareasUrgentes} urgentes`;
    });

  // Llenar tabla de casos
  fetch(`http://localhost:3000/api/dashboard/casos?usuarioId=${usuarioId}`)
    .then(res => res.json())
    .then(casos => {
      const tabla = document.getElementById('tabla-casos');
      tabla.innerHTML = '';
      casos.forEach(caso => {
        const row = document.createElement('div');
        row.className = 'table-row';
        row.innerHTML = `
          <div>${caso.Titulo}</div>
          <div>${caso.Cliente}</div>
          <div>${caso.AreaLegal}</div>
          <div>${caso.Responsable}</div>
          <div><span class="estado ${caso.Estado.toLowerCase()}">${caso.Estado}</span></div>
          <div class="acciones"><i class="fas fa-eye"></i></div>
        `;
        tabla.appendChild(row);
      });
    });
});

