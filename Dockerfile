FROM alpine:3.21 AS builder

WORKDIR /app

COPY index.html styles.css script.js README.md robots.txt sitemap.xml ./
COPY assets ./assets
COPY scripts ./scripts

RUN ./scripts/build-static.sh /app/dist

FROM nginx:1.27-alpine

ENV NGINX_ENVSUBST_OUTPUT_DIR=/etc/nginx/conf.d

COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=builder /app/dist/ /usr/share/nginx/html/

EXPOSE 80

HEALTHCHECK --interval=30s --timeout=3s CMD wget -qO- http://127.0.0.1/ || exit 1
