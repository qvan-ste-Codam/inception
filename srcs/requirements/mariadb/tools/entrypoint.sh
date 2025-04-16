#!/bin/ash
set -e

if [ ! -f "${DB_DIR}/ibdata1" ]; then
    mkdir -p run/mariadb 
    chown mysql:mysql /run/mariadb ${DB_DIR}
    mariadb-install-db --user=mysql --datadir=${DB_DIR} &
    wait $!
    
    mariadbd --datadir=${DB_DIR} --skip-networking  &
    
    retry_count=0
    max_retries=30
    until mariadb-admin ping 2>/dev/null; do
        retry_count=$((retry_count+1))
        if [ $retry_count -ge $max_retries ]; then
            echo "ERROR: MariaDB failed to start after $max_retries attempts"
            exit 1
        fi
        sleep 2
    done

    mariadb <<-EOF
        CREATE DATABASE IF NOT EXISTS ${DB_NAME};
        CREATE USER IF NOT EXISTS '${DB_USER}'@'%' IDENTIFIED BY '$(cat $DB_PASSWORD_FILE)';
        GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'%';
        DELETE FROM mysql.user WHERE User='';
        DROP DATABASE IF EXISTS test;
        FLUSH PRIVILEGES; 
EOF

    mariadb-admin  shutdown
    wait $!
fi

exec mariadbd-safe --user=mysql --datadir=${DB_DIR}