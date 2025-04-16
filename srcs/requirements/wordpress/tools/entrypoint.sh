#!/bin/ash

set -e
 
until mariadb-admin ping -h ${WP_DB_HOST} -u ${WP_DB_USER} -p${WP_DB_PASSWORD} 2>/dev/null; do
  sleep 2
done

php83 /var/www/html/install.php
echo "Wordpress initialized"
exec php-fpm83 -F
