FROM alpine:3.20

RUN apk add --no-cache \
    openssl \
    curl \
    ca-certificates \
    && printf "%s%s%s%s\n" \
    "@nginx " \
    "http://nginx.org/packages/alpine/v" \
    `egrep -o '^[0-9]+\.[0-9]+' /etc/alpine-release` \
    "/main" \
    | tee -a /etc/apk/repositories \
    && curl -o /tmp/nginx_signing.rsa.pub https://nginx.org/keys/nginx_signing.rsa.pub \
    && openssl rsa -pubin -in /tmp/nginx_signing.rsa.pub -text -noout \
    && mv /tmp/nginx_signing.rsa.pub /etc/apk/keys/ \
    && apk add --no-cache nginx-module-image-filter@nginx nginx-module-njs@nginx

COPY ./conf/nginx.conf /etc/nginx/conf.d/default.conf

CMD ["nginx", "-g", "daemon off;"]
