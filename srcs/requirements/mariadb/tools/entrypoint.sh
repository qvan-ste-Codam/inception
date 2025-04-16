#!/bin/ash

set -e

if [ ! -f "${DB_DIR}/ibdata1" ]; then
    mkdir -p run/mariadb 
    chown mysql:mysql /run/mariadb ${DB_DIR}
    mariadb-install-db --user=mysql --datadir=${DB_DIR} &
    wait $!
    
    mariadbd --datadir=${DB_DIR} --skip-networking  &
    
    until mariadb-admin ping 2>/dev/null; do
        sleep 2
    done

    mariadb <<-EOF
        CREATE DATABASE IF NOT EXISTS ${DB_NAME};
        CREATE USER IF NOT EXISTS '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}';
        GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'%';
        DELETE FROM mysql.user WHERE User='';
        DROP DATABASE IF EXISTS test;
        FLUSH PRIVILEGES; 
EOF

    mariadb-admin  shutdown
    wait $!
fi

exec mariadbd-safe --user=mysql --datadir=${DB_DIR}