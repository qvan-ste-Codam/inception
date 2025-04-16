FROM alpine:3.20

# Install dependencies
RUN apk add --no-cache \
    openssl \
    curl \
    ca-certificates 

# Fetch and install latest version of Nginx
RUN printf "%s%s%s%s\n" \
    "@nginx " \
    "http://nginx.org/packages/alpine/v" \
    `egrep -o '^[0-9]+\.[0-9]+' /etc/alpine-release` \
    "/main" \
    | tee -a /etc/apk/repositories \
    && curl -o /tmp/nginx_signing.rsa.pub https://nginx.org/keys/nginx_signing.rsa.pub \
    && openssl rsa -pubin -in /tmp/nginx_signing.rsa.pub -text -noout \
    && mv /tmp/nginx_signing.rsa.pub /etc/apk/keys/ \
    && apk add --no-cache nginx-module-image-filter@nginx nginx-module-njs@nginx

# Copy config file
COPY conf/nginx.conf /etc/nginx/conf.d/default.conf

# Copy and execute entrypoint
COPY tools/entrypoint.sh /usr/local/bin/.
RUN chmod +x /usr/local/bin/entrypoint.sh 

ENTRYPOINT ["entrypoint.sh"]
