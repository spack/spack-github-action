#!/bin/bash
set -ex

if [ -z "$*" ]; then
  echo "Expecting one or more arguments"
  exit 1
fi
# shellcheck source=scripts/spack_setup.sh
source "$GITHUB_WORKSPACE"/scripts/spack_setup.sh fetch
spack install "$SPACK_SPEC"
PATH="$PATH:$(spack location --install-dir "$SPACK_SPEC")/bin/"
export PATH

"$@"