FROM alpine:3.20

ARG CONTAINER_NAME

RUN apk add --no-cache \
    php83 \
    php83-fpm \
    php83-mysqli \
    mysql-client \
    wget 

RUN wget https://wordpress.org/latest.tar.gz &&\
    mkdir -p /var/www/html/ &&\
    tar -xf latest.tar.gz && \
    mv wordpress/* /var/www/html/ && \
    rm -rf latest.tar.gz wordpress

RUN echo "listen = ${CONTAINER_NAME}:9000" >> /etc/php83/php-fpm.d/www.conf
COPY conf/wp-config.php /var/www/html/wp-config.php

CMD ["/usr/sbin/php-fpm83", "-F"]
