FROM alpine:3.9

RUN apk add --no-cache git bash python build-base && \
    git clone --depth=1 https://github.com/spack/spack /spack
ADD entrypoint.sh /

ENV SPACK_ROOT=/spack
ENV PATH=$PATH:/spack/bin

ENTRYPOINT ["/entrypoint.sh"]
