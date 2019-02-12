#!/bin/bash
set -ex

export spack_git_url="git@github.com:spack/spack"
export spack_git_ref="origin/develop"
export spack_use_modules="false"
export spack_module_list="[]"
export spack_spec="lulesh~mpi"

source ./install.sh
