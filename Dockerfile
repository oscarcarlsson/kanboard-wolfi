# https://github.com/shyim/wolfi-php/tree/main/images/nginx
FROM ghcr.io/shyim/wolfi-php/nginx:8.4
VOLUME ["/var/www/html/data", "/var/www/html/plugins", "/etc/nginx/ssl"]
EXPOSE 8000

# Remove wolfi-php test folder, which otherwise contains a phpinfo() page
RUN <<EOF
[ -d /var/www/html/public ] && rm -rf /var/www/html/public
EOF

RUN <<EOF
apk add --no-cache \
    php-8.4-pdo \
    php-8.4-pdo_sqlite \
    php-8.4-pdo_sqlite-config \
    php-8.4-gd \
    php-8.4-mbstring \
    php-8.4-openssl \
    php-8.4-ctype \
    php-8.4-dom \
    php-8.4-simplexml \
    php-8.4-xml
EOF

COPY --chown=82:82 ./app /var/www/html
COPY nginx.conf /etc/nginx/nginx.conf
COPY files/php-fpmd-env.conf /etc/php/php-fpm.d/env.conf
COPY files/php-fpm.conf /etc/php/php-fpm.conf
COPY files/php-confd-local.ini /etc/php/conf.d/local.ini
USER www-data
HEALTHCHECK --start-period=3s --timeout=5s \
  CMD curl -f http://localhost/healthcheck.php || exit 1
