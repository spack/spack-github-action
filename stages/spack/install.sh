#!/bin/bash
# [wf] run the spack stage
set -ex

# [wf] install/update spack
source scripts/spack_setup.sh fetch

# [wf] install spec
spack install $spack_spec
