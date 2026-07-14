# syntax=docker/dockerfile:1
FROM alpine:3.24 AS fetcher

ADD --unpack=true --chown=82:82 https://github.com/kanboard/kanboard/archive/refs/tags/v1.2.52.tar.gz /var/www/html/kanboard/

FROM alpine:3.24

RUN <<EOF
apk add --no-cache \
    s6 \
    nginx \
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
    php84-session \
    php84-simplexml \
    php84-xml \
    php84

adduser -u 82 -D -S -G www-data www-data
mkdir -m 0755 -p /etc/services.d/
mkdir -m 0755 -p /etc/services.d/cron
mkdir -m 0755 -p /etc/services.d/nginx
mkdir -m 0755 -p /etc/services.d/php
mkdir -m 0755 -p /etc/services.d/.s6-svscan

EOF

COPY --from=fetcher /var/www/html/kanboard/kanboard-1.2.52/ /var/www/html/

COPY files/nginx.conf /etc/nginx/nginx.conf
COPY files/php-fpmd-env.conf /etc/php84/php-fpm.d/env.conf
COPY files/php-fpm.conf /etc/php84/php-fpm.conf
COPY files/php-confd-local.ini /etc/php84/conf.d/local.ini
COPY --chmod=750 files/services.d/php/run /etc/services.d/php/run
COPY --chmod=750 files/services.d/nginx/run /etc/services.d/nginx/run
COPY --chmod=750 files/services.d/cron/run /etc/services.d/cron/run
COPY --chmod=750 files/services.d/.s6-svscan/finish /etc/services.d/.s6-svscan/finish

VOLUME ["/var/www/html/data", "/var/www/html/plugins", "/etc/nginx/ssl"]
EXPOSE 8000

USER www-data

HEALTHCHECK --start-period=3s --timeout=5s \
  CMD curl -f http://localhost/healthcheck.php || exit 1

ENTRYPOINT ["/usr/bin/s6-svscan", "/etc/services.d"]
