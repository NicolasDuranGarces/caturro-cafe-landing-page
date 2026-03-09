# Caturro Café — Landing

Landing page oscura con estética underground, anillo de neón café alrededor del hero, marquee infinito y mapa embebido. Servida con Nginx y empaquetada con versionado automático de assets para mejorar caché y primera carga.

## Estructura

- `index.html`: marcado semántico y accesible.
- `styles.css`: tema oscuro cálido, variables CSS, responsive.
- `script.js`: interacciones (smooth scroll, reveal, parallax, marquee infinito, ajustes A11y).
- `assets/`: imágenes y logotipo.
- `Dockerfile` + `nginx.conf`: contenedor de producción con build estático versionado.
- `nginx.dev.conf`: configuración sin caché fuerte para desarrollo local.
- `docker-compose.yml`: ejecución unificada para desarrollo y producción.
- `scripts/build-static.sh`: genera el sitio final con nombres versionados.
- `Makefile`: atajos para `docker compose`.

## Desarrollo local

- Modo dev con Docker Compose:
  - `make dev`
  - abre `http://localhost:5003` o cambia el puerto con `DEV_PORT=8080 make dev`
  - modifica archivos y recarga el navegador

## Producción (Docker Compose)

- Build: `make build`
- Run: `make run`  → http://localhost:5002
- Logs: `make logs`
- Stop: `make stop`
- Restart: `make restart`
- Clean image: `make clean`

Variables opcionales: `PORT`, `DEV_PORT`, `IMAGE`, `TAG`

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
- `scripts/build-static.sh`: versiona `CSS`, `JS` e imágenes locales para permitir caché `immutable`.
- `nginx.conf`: deja `index.html` sin caché fuerte y comprime respuestas textuales con `gzip`.

## Seguridad (Nginx)

- `server_tokens off` y cabeceras: `X-Content-Type-Options`, `X-Frame-Options`, `Referrer-Policy`, `Permissions-Policy`.
- `Content-Security-Policy` permisiva para fuentes de Google y el iframe de Google Maps.
- Cache agresiva para assets versionados y HTML siempre revalidado.

## Notas

- Si usas una imagen JPG para el gato, el fondo negro se elimina visualmente con `mix-blend-mode: screen`. Para mayor control puedes subir un PNG/SVG con transparencia en `assets/` y actualizar el `src` en el hero.
