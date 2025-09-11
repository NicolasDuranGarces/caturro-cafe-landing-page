# Caturro Café — Landing

Landing page oscura con estética underground y animaciones sutiles.

## Desarrollo

- Abrir `index.html` en el navegador.
- Estilos en `styles.css` y scripts en `script.js`.
- Reemplaza el logo de ejemplo:
  - Coloca tu archivo en `assets/logo.png` o `assets/logo.svg`.
  - Actualiza la ruta en `index.html` si usas otro nombre.

## Docker

Requisitos: Docker y Make.

- Build: `make build`
- Run: `make run` (abre en `http://localhost:8080`)
- Logs: `make logs`
- Stop: `make stop`
- Clean image: `make clean`

Variables útiles:

```
PORT=8081 IMAGE=caturro-cafe TAG=dev make run
```

## Secciones

- Hero con logo, efecto “smoke” y grano.
- Nosotros, Cafés destacados, Orígenes (timeline), Visítanos (info + mapa placeholder).
- Marquee de texto y animaciones de aparición al hacer scroll.

## Personalización rápida

- Colores: variables CSS en `:root` (ej. `--accent`).
- Tipografías: Google Fonts en el `<head>`.
- Cards de cafés: editar en la sección `#coffee`.
# caturro-cafe-landing-page
