#!/bin/sh
set -e

# Check if DB_ROOT_PASSWORD is set
if [ -z "${DB_ROOT_PASSWORD}" ]; then
  echo "Error: DB_ROOT_PASSWORD environment variable is not set." >&2
  exit 1
fi

# Install MariaDB
mariadb-install-db --datadir=/var/lib/mysql --auth-root-authentication-method=normal

# Start MariaDB in background for setup
mariadbd --datadir=/var/lib/mysql --skip-networking --socket=/run/mysqld/mysqld.sock &
PID=$!

# Wait for MariaDB to be ready
tries=30
while [ $tries -gt 0 ] && ! mariadb-admin ping --socket=/run/mysqld/mysqld.sock --silent; do
    sleep 1
    tries=$((tries - 1))
    if [ $tries -eq 0 ]; then
      exit 1
    fi
done

# Set root password
mariadb --user=root --socket=/run/mysqld/mysqld.sock <<-SQL
    ALTER USER 'root'@'localhost' IDENTIFIED BY '$(printf "%s" "${DB_ROOT_PASSWORD}")';
SQL

# Try to kill MariaDB gracefully, if it fails, kill it forcefully
tries=5
while [ $tries -gt 0 ] && ! kill -s TERM "$PID"; do
    sleep 1
    tries=$((tries - 1))
    if [ $tries -eq 0 ]; then
        kill -9 "$PID"
    fi
done

# Wait for MariaDB to exit
wait "$PID"
