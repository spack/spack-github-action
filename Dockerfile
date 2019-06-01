FROM alpine:3.8
RUN apk add --no-cache git bash python build-base
ADD entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
