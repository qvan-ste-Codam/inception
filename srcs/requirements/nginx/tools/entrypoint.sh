#!/bin/ash
set -e

mkdir -p /var/www/certs

if [ ! -f /var/www/certs/nginx.crt ] || [ ! -f /var/www/certs/nginx.key ]; then
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
        -keyout /var/www/certs/nginx.key \
        -out /var/www/certs/nginx.crt \
        -subj "/CN=localhost" > /dev/null
fi

ln -sf /var/www/certs/nginx.key /etc/nginx/nginx.key
ln -sf /var/www/certs/nginx.crt /etc/nginx/nginx.crt

exec nginx -g "daemon off;"