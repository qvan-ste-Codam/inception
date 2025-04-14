FROM alpine:3.20

COPY ["./tools/main.sh", "/usr/local/bin/"]

RUN apk add --no-cache \
    mariadb \
    mariadb-client

RUN chmod +x /usr/local/bin/main.sh && \
    mkdir -p run/mariadb

COPY ./conf/mariadb-server.cnf /etc/my.cnf
COPY ./conf/my.cnf /etc/my.cnf.d/mariadb-server.cnf

ENTRYPOINT ["main.sh"]