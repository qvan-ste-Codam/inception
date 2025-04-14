#!/bin/ash

set -e

if [ ! -f "$DIR_DATA/ibdata1" ]; then
    mariadb-install-db \
        --datadir=$DIR_DATA \
        --auth-root-authentication-method=socket &
    wait $!
    
    mariadbd --datadir=$DIR_DATA  &
    MARIADB_PID=$!
    
    until mariadb-admin ping 
    do
        sleep 1
    done
    
    mariadb <<-EOF
        CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
        CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
        GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
        FLUSH PRIVILEGES;
EOF
    
    kill $MARIADB_PID
    wait $MARIADB_PID || true
fi

exec /usr/bin/mariadbd-safe --datadir=$DIR_DATA