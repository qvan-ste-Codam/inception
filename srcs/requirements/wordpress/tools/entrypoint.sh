#!/bin/ash
set -e

retry_count=0
max_retries=30
until mariadb-admin ping -h ${WP_DB_HOST} -u ${WP_DB_USER} -p$(cat $DB_PASSWORD_FILE) 2>/dev/null; do
    retry_count=$((retry_count+1))
    if [ $retry_count -ge $max_retries ]; then
        echo "ERROR: MariaDB failed to start after $max_retries attempts"
        exit 1
    fi
        sleep 2
done

php83 /var/www/html/install.php
exec php-fpm83 -F
