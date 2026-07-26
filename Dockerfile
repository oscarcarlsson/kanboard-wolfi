# syntax=docker/dockerfile:1
FROM alpine:3.24 AS fetcher

ADD --unpack=true --chown=82:82 https://github.com/kanboard/kanboard/archive/refs/tags/v1.2.53.tar.gz /var/www/html/kanboard/

FROM alpine:3.24

RUN <<EOF
apk add --no-cache \
    php85-ctype \
    php85-dom \
    php85-fpm \
    php85-gd \
    php85-ldap \
    php85-mbstring \
    php85-openssl \
    php85-pdo \
    php85-pdo_mysql \
    php85-pdo_pgsql \
    php85-pdo_sqlite \
    php85-session \
    php85-simplexml \
    php85-xml \
    php85-zip \
    php85-curl \
    php85 \
    caddy \
    s6-overlay

adduser -u 82 -D -S -G www-data www-data
addgroup caddy www-data

rm -rf /etc/s6-overlay/
EOF

COPY --from=fetcher /var/www/html/kanboard/kanboard-1.2.53/ /var/www/html/
COPY rootfs/ /

VOLUME ["/var/www/html/data", "/var/www/html/plugins"]
EXPOSE 8000

USER www-data

HEALTHCHECK --start-period=3s --timeout=5s \
  CMD curl -f http://localhost/healthcheck.php || exit 1

WORKDIR /var/www/html
ENTRYPOINT ["php-fpm85"]
