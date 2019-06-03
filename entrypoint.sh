#!/bin/bash
set -ex

if [[ -z "$*" ]]; then
  echo "Expecting one or more arguments"
  exit 1
fi
#source '/etc/profile.d/spack.sh'
##remove spack if exist previously
#if [[   -d "$GITHUB_WORKSPACE"/temp/spack ]]; then
#    rm -rf "$GITHUB_WORKSPACE"/temp
#fi
#
## install Spack
#git clone https://github.com/spack/spack  "$GITHUB_WORKSPACE"/temp/spack
#PATH=$PATH:"$GITHUB_WORKSPACE"/temp/spack/bin
#echo "$PATH" && export PATH
#bash "$GITHUB_WORKSPACE"/temp/spack/share/spack/setup-env.sh
#
#if [[ -n "$SPACK_RESET_CONFIG" ]]; then
#  if [[ -z "$SPACK_GIT_REF" ]]; then
#    echo "Please provide the git ref to reset"
#    exit 1
#  else
#    git -C "$GITHUB_WORKSPACE"/temp/spack fetch
#    git -C "$GITHUB_WORKSPACE"/temp/spack reset --hard "$SPACK_GIT_REF"
#  fi
#fi

# run commands
spack "$@"
