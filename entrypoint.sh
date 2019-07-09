#!/usr/bin/env bash
set -e

# load bash integration
source "$SPACK_ROOT/share/spack/setup-env.sh"

# set env and view paths
SPACK_ENV_PATH="$GITHUB_WORKSPACE/spack/env"
SPACK_ENV_VIEW="$SPACK_ENV_PATH/view"

# create environment if it doesn't exist
if [ ! -d "$SPACK_ENV_PATH" ]; then
  mkdir -p "$SPACK_ENV_PATH"
  spack env create --dir "$SPACK_ENV_PATH" --with-view "$SPACK_ENV_VIEW"
fi

# activate environment
spack env activate "$SPACK_ENV_PATH"

# add environment view to PATH
PATH="$PATH:$SPACK_ENV_VIEW/bin"

sh -c "$*"
