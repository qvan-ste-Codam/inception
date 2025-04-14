FROM alpine:3.20

COPY ["./tools/main.sh", "/usr/local/bin/"]

RUN apk add --no-cache \
    mariadb \
    mariadb-client

RUN mkdir -p /var/lib/mariadb/ \
    && mkdir -p /run/mariadb \
    && chown -R mysql:mysql /var/lib/mariadb/ \
    && chown -R mysql:mysql /run/mariadb

RUN chmod +x /usr/local/bin/main.sh

COPY ./conf/mariadb-server.cnf /etc/my.cnf
COPY ./conf/my.cnf /etc/my.cnf.d/mariadb-server.cnf

ENTRYPOINT ["main.sh"]