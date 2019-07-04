FROM debian:buster-slim

RUN apt update && \
    apt install -y \
    git mpich bash curl python build-essential && \
    git clone --depth=1 https://github.com/spack/spack /spack; \
    old_path='install_tree: $spack/opt/spack';\
    new_path='install_tree: $GITHUB_WORKSPACE/install';\
    sed -i "s+$old_path+$new_path+" /spack/etc/spack/defaults/config.yaml; \
    old_var='${ARCHITECTURE}/${COMPILERNAME}-${COMPILERVER}/${PACKAGE}-${VERSION}-${HASH}'; \
    new_var='';\
    sed -i "s+$old_var+$new_var+" /spack/etc/spack/defaults/config.yaml; \
    rm -rf /var/lib/apt/lists/*
RUN apt-get update && apt-get install -y gfortran
ADD entrypoint.sh /
ENV SPACK_ROOT=/spack
ENV PATH=$PATH:/spack/bin

ENTRYPOINT ["/entrypoint.sh"]
