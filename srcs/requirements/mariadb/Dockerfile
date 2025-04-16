FROM alpine:3.20

# Install dependencies
RUN apk add --no-cache \
    mariadb \
    mariadb-client

# Copy config file  
COPY conf/my.cnf /etc/my.cnf

# Copy and execute entrypoint
COPY ./tools/entrypoint.sh /usr/local/bin/.
RUN chmod +x /usr/local/bin/entrypoint.sh 

ENTRYPOINT ["entrypoint.sh"]