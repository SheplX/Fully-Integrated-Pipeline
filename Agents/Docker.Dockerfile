FROM alpine:3.14

MAINTAINER shepl.dev@gmail.com

RUN mkdir /workspace

WORKDIR /workspace

RUN apk add --update --no-cache nano curl docker-cli python3 && \
    rm -rf /var/cache/apk/*

CMD ["/bin/sh"]