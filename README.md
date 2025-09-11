# Caturro Café — Landing

Landing page oscura con estética underground, anillo de neón café alrededor del hero, marquee infinito y mapa embebido. Servida con Nginx (Docker), sin dependencias externas.

## Estructura

- `index.html`: marcado semántico y accesible.
- `styles.css`: tema oscuro cálido, variables CSS, responsive.
- `script.js`: interacciones (smooth scroll, reveal, parallax, marquee infinito, ajustes A11y).
- `assets/`: imágenes y logotipo.
- `Dockerfile` + `nginx.conf`: contenedor de producción.
- `Makefile`: comandos de build/run/dev.

## Desarrollo local

- Abrir `index.html` directamente o usar Docker.
- Modo dev en Docker (monta los archivos con hot-reload de Nginx):
  - `make build`
  - `make dev` (abre `http://localhost:8080`)
  - Cambia archivos y recarga el navegador.

## Producción (Docker)

- Build: `make build`
- Run: `make run`  → http://localhost:8080
- Logs: `make logs`
- Stop: `make stop`
- Restart: `make restart`
- Clean image: `make clean`

Variables opcionales: `PORT`, `IMAGE`, `TAG`

Ejemplo: `PORT=8081 IMAGE=caturro-cafe TAG=dev make run`

## Personalización rápida

- Colores: editar variables en `styles.css` (bloque `:root`).
- Hero: el centro del motivo se ajusta con `--img-x` y `--img-y` en `styles.css`.
- Texto del marquee: `index.html` → atributo `data-text` dentro de `.marquee .content`.
- Mapa: `index.html` sección `Visítanos` (iframe de Google Maps).

## Accesibilidad y rendimiento

- `prefers-reduced-motion`: desactiva animaciones para usuarios sensibles.
- `IntersectionObserver`: carga progresiva con animaciones suaves.
- Marquee infinito: relleno dinámico según ancho de pantalla; velocidad estable.

## Seguridad (Nginx)

- `server_tokens off` y cabeceras: `X-Content-Type-Options`, `X-Frame-Options`, `Referrer-Policy`, `Permissions-Policy`.
- `Content-Security-Policy` permisiva para fuentes de Google y el iframe de Google Maps.
- Cache estática agresiva para `css/js/img/svg`, HTML sin cache.

## Notas

- Si usas una imagen JPG para el gato, el fondo negro se elimina visualmente con `mix-blend-mode: screen`. Para mayor control puedes subir un PNG/SVG con transparencia en `assets/` y actualizar el `src` en el hero.
