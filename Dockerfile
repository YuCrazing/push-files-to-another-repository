FROM alpine:3.12

RUN apk add --no-cache git \
    git-lfs

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
