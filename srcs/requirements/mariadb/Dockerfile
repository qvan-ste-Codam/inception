FROM alpine:3.20

ARG DB_ROOT_PASSWORD=FOO

RUN apk add --no-cache \
    mariadb \
    mariadb-client \
    procps

RUN mkdir -p /var/lib/mysql /run/mysqld

RUN chown -R mysql:mysql /var/lib/mysql /run/mysqld && \
    chmod 755 /run/mysqld && \
    chmod -R 755 /var/lib/mysql

COPY tools/init.sh /usr/local/bin/init.sh

RUN chown mysql:mysql /usr/local/bin/init.sh && \
    chmod +x /usr/local/bin/init.sh

USER mysql

RUN /usr/local/bin/init.sh

EXPOSE 3306

CMD ["mariadbd", "--datadir=/var/lib/mysql", "--bind-address=0.0.0.0"]
