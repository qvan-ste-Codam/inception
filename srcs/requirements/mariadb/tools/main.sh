#!/bin/ash

set -e

if [ ! -f "$DIR_DATA/ibdata1" ]; then
    mariadb-install-db \
        --datadir=$DIR_DATA \
        --auth-root-authentication-method=socket &
    wait $!
    
    mariadbd --datadir=$DIR_DATA  &
    PID=$!
    
    until mariadb-admin ping 
    do
        sleep 1
    done
    
    mariadb <<-EOF
        CREATE DATABASE IF NOT EXISTS ${DB_NAME};
        CREATE USER IF NOT EXISTS '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}';
        GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'%';
        DELETE FROM mysql.user WHERE User='';
        FLUSH PRIVILEGES; 
EOF

    kill $PID
    wait $PID || true
fi

exec /usr/bin/mariadbd-safe --datadir=$DIR_DATA