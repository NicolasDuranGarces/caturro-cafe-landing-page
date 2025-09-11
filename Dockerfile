FROM nginx:1.27-alpine

# Variables
ENV NGINX_ENVSUBST_OUTPUT_DIR=/etc/nginx/conf.d

# Configuración nginx para servir sitio estático
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copiar el sitio
COPY index.html /usr/share/nginx/html/index.html
COPY styles.css /usr/share/nginx/html/styles.css
COPY script.js /usr/share/nginx/html/script.js
COPY README.md /usr/share/nginx/html/README.md
COPY assets /usr/share/nginx/html/assets

EXPOSE 5002

HEALTHCHECK --interval=30s --timeout=3s CMD wget -qO- http://127.0.0.1/ || exit 1

# Ejecuta nginx (arranca por defecto en la imagen base)
