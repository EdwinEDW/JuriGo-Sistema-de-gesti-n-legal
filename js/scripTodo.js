    // Destacar el día actual
    document.addEventListener('DOMContentLoaded', function() {
      const today = new Date();
      if (today.getMonth() === 5 && today.getFullYear() === 2025) {
        const day = today.getDate();
        const cells = document.querySelectorAll('.day-number');
        cells.forEach(cell => {
          if (parseInt(cell.textContent) === day) {
            cell.parentElement.classList.add('today');
          }
        });
      }
    });

    