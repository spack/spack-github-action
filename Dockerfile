FROM debian:buster-slim

# install spack
RUN apt update && \
    apt install -y --no-install-recommends \
      autoconf build-essential gfortran coreutils \
      ca-certificates curl ssh-client git python unzip tar && \
    git clone --depth=1 https://github.com/spack/spack /spack && \
    rm -rf /var/lib/apt/lists/*

# modify spack config
RUN sed -i \
      's/$spack\(.*\)/"${GITHUB_WORKSPACE}\/spack\1"/' \
      /spack/etc/spack/defaults/config.yaml && \
    sed -i \
      's/misc_cache: .*/misc_cache: "${GITHUB_WORKSPACE}\/spack\/misc_cache"/' \
      /spack/etc/spack/defaults/config.yaml

ENV SPACK_ROOT=/spack
ENV PATH=$PATH:/spack/bin

# configure system-wide compiler
RUN spack compiler find --scope defaults

ADD entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]
