FROM alpine:3.8
ENV DEBIAN_FRONTEND=noninteractive \
     SPACK_ROOT=/usr/local

RUN apk add --no-cache git bash python build-base; \
    git clone https://github.com/spack/spack $SPACK_ROOT/spack;
RUN echo "echo "Hello"; source $SPACK_ROOT/spack/share/spack/setup-env.sh" > /etc/profile.d/spack.sh
ADD entrypoint.sh /
SHELL ["/usr/bin/bash", "-l", "-c"]
ENTRYPOINT ["/entrypoint.sh"]
