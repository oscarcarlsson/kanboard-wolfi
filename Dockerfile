# syntax=docker/dockerfile:1
FROM alpine:3.24

VOLUME ["/var/www/html/data", "/var/www/html/plugins", "/etc/nginx/ssl"]
EXPOSE 8000

RUN <<EOF
apk add --no-cache \
    php84-fpm \
    php84-pdo \
    php84-pdo_sqlite \
    php84-pdo_pgsql \
    php84-pdo_mysql \
    php84-gd \
    php84-mbstring \
    php84-opcache \
    php84-openssl \
    php84-ctype \
    php84-dom \
    php84-simplexml \
    php84-xml
EOF

ADD --unpack=true --chown=82:82 https://github.com/kanboard/kanboard/archive/refs/tags/v1.2.52.tar.gz /var/www/html

COPY files/nginx.conf /etc/nginx/nginx.conf
COPY files/php-fpmd-env.conf /etc/php84/php-fpm.d/env.conf
COPY files/php-fpm.conf /etc/php84/php-fpm.conf
COPY files/php-confd-local.ini /etc/php84/conf.d/local.ini
USER www-data

HEALTHCHECK --start-period=3s --timeout=5s \
  CMD curl -f http://localhost/healthcheck.php || exit 1
