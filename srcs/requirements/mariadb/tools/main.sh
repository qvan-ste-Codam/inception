#!/bin/ash

if [ ! -f "$DIR_DATA/ibdata1" ]; then
    mariadb-install-db --datadir=${DIR_DATA} &
    wait $!
    
    mariadbd --datadir=${DIR_DATA} --skip-networking  &
    
    until mariadb-admin ping 2>/dev/null; do
        sleep 1
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

exec /usr/bin/mariadbd-safe --datadir=${DIR_DATA}