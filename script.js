// Caturro Café — Interacciones básicas

// Año en footer
document.getElementById('year').textContent = new Date().getFullYear();

// Smooth scroll para anclas
document.querySelectorAll('a[href^="#"]').forEach(a => {
  a.addEventListener('click', (e) => {
    const href = a.getAttribute('href');
    if (href.length > 1) {
      e.preventDefault();
      const el = document.querySelector(href);
      if (el) el.scrollIntoView({ behavior: 'smooth', block: 'start' });
    }
  });
});

// Menú móvil
const hamburger = document.querySelector('.hamburger');
const menu = document.querySelector('.menu');
if (hamburger && menu) {
  hamburger.addEventListener('click', () => {
    const open = menu.classList.toggle('open');
    hamburger.setAttribute('aria-expanded', open ? 'true' : 'false');
  });
}

// Reveal on scroll con IntersectionObserver
const io = new IntersectionObserver((entries) => {
  entries.forEach((entry) => {
    if (entry.isIntersecting) {
      entry.target.classList.add('in-view');
      io.unobserve(entry.target);
    }
  });
}, { threshold: 0.15 });

document.querySelectorAll('.reveal').forEach((el) => io.observe(el));

// Parallax sutil en hero (logo + smoke)
const stage = document.querySelector('.hero-stage');
const reduceMotion = window.matchMedia && window.matchMedia('(prefers-reduced-motion: reduce)').matches;
if (stage && !reduceMotion) {
  const layers = Array.from(stage.querySelectorAll('.layer'));
  let px = 0, py = 0;
  stage.addEventListener('mousemove', (e) => {
    const r = stage.getBoundingClientRect();
    const x = (e.clientX - r.left) / r.width - 0.5;
    const y = (e.clientY - r.top) / r.height - 0.5;
    px = x; py = y;
  });

  const animate = () => {
    layers.forEach((el, i) => {
      const depth = (i + 1) * 3; // mayor índice, más desplazamiento
      const tx = -px * depth;
      const ty = -py * depth;
      el.style.transform = `translate3d(${tx}px, ${ty}px, 0)`;
    });
    requestAnimationFrame(animate);
  };
  animate();
}

// Marquee infinito que siempre ocupa ancho completo
function setupMarquees() {
  document.querySelectorAll('.marquee').forEach((marquee) => {
    const track = marquee.querySelector('.track');
    const first = track?.querySelector('.content');
    const second = track?.querySelector('.content + .content');
    if (!track || !first || !second) return;

    const base = first.dataset.text?.trim() || first.textContent.trim() || '';
    if (!base) return;

    // Rellena la primera cinta hasta cubrir 1× el viewport del marquee
    first.innerHTML = '';
    const span = (t) => {
      const s = document.createElement('span');
      s.textContent = t;
      return s;
    };
    // Añade mensajes hasta cubrir el ancho del contenedor + margen
    const target = () => marquee.clientWidth + 100; // margen de seguridad
    while (first.scrollWidth < target()) {
      first.appendChild(span(base));
    }
    // La segunda cinta es copia exacta para bucle perfecto
    second.innerHTML = first.innerHTML;

    // Duración proporcional al ancho para que la velocidad sea consistente
    const px = first.scrollWidth;
    const duration = Math.max(14, Math.min(40, px / 18)); // 18px/s aprox
    track.style.setProperty('--marquee-duration', `${duration}s`);
  });
}

window.addEventListener('load', setupMarquees);

// Debounce de resize para performance
let _rz;
window.addEventListener('resize', () => {
  clearTimeout(_rz);
  _rz = setTimeout(setupMarquees, 150);
});
