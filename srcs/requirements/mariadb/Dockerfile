FROM alpine:3.20

COPY ["./tools/entrypoint.sh", "/usr/local/bin/."]

RUN apk add --no-cache \
    mariadb \
    mariadb-client

COPY ./conf/mariadb-server.cnf /etc/my.cnf
COPY ./conf/my.cnf /etc/my.cnf.d/mariadb-server.cnf

RUN chmod +x /usr/local/bin/entrypoint.sh 

ENTRYPOINT ["entrypoint.sh"]