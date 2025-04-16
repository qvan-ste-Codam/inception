FROM alpine:3.20

# Install dependencies
RUN apk add --no-cache \
    php83 \
    php83-fpm \
    php83-mysqli \
    wget  \
    mariadb-client

# Fetch latest Wordpress 
RUN wget https://wordpress.org/latest.tar.gz &&\
    mkdir -p /var/www/html/ && \
    tar -xf latest.tar.gz && \
    mv wordpress/* /var/www/html/ && \
    rm -rf latest.tar.gz wordpress

# Copy config files
COPY conf/www.conf /etc/php83/php-fpm.d/www.conf
COPY conf/wp-config.php /var/www/html/wp-config.php
COPY conf/install.php /var/www/html/install.php

# Generate salts
RUN wget -O - https://api.wordpress.org/secret-key/1.1/salt/ > /tmp/wp-keys && \
    sed -i "/\/\/ AUTH KEY PLACEHOLDER/r /tmp/wp-keys" /var/www/html/wp-config.php && \
    rm /tmp/wp-keys 

# Copy and execute entrypoint
COPY tools/entrypoint.sh /usr/local/bin/.
RUN chmod +x /usr/local/bin/entrypoint.sh 

ENTRYPOINT [ "entrypoint.sh" ]
