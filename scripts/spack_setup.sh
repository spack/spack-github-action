#!/bin/bash
set -ex

if [ -z "$SPACK_SPEC" ]; then
  echo "Expecting SPACK_SPEC variable"
  exit 1
fi
if [ -z "$SPACK_GIT_URL" ]; then
  echo "Using https://github.com/spack/spack as SPACK_GIT_URL"
  SPACK_GIT_URL="https://github.com/spack/spack"
fi
if [ -z "$SPACK_GIT_REF" ]; then
  echo "Using 'develop' for SPACK_GIT_REF"
  SPACK_GIT_REF="develop"
fi
if [ -z "$SPACK_ROOT" ]; then
  echo "using $WORKSPACE/install/spack as SPACK_ROOT"
  SPACK_ROOT=$WORKSPACE/install/spack
fi
mkdir -p $(dirname $SPACK_ROOT)

# clone
if [ ! -d $SPACK_ROOT ]; then
  git clone $SPACK_GIT_URL $SPACK_ROOT
fi

# bash env
export PATH=$PATH:$SPACK_ROOT/bin
source $SPACK_ROOT/share/spack/setup-env.sh

# load modules
if [ -n "$SPACK_USE_MODULES" ]; then
  if [ "$SPACK_USE_MODULES" == "true" ] && [ -z "$SPACK_MODULE_LIST" ]; then
    echo "Expecting SPACK_USE_MODULES variable with list of modules to load"
    exit 1
  else
    module purge
    module load $SPACK_MODULE_LIST
    for m in ${SPACK_MODULE_LIST//,/ }; do
      module load $m
    done
  fi
fi

# reset spack config
if [ "$1" == "fetch" ]; then
  git -C $SPACK_ROOT fetch
  git -C $SPACK_ROOT reset --hard $SPACK_GIT_REF

  if [ -n $SPACK_USE_MODULES ]; then
    function get_module_path {
      module_info=$(module show $1 2>&1 >/dev/null | grep 'prepend-path.* PATH' | awk '{ print $3 }')
      dirname $module_info
    }
    function get_module_version {
      basename $(get_module_path $1)
    }

    for m in ${SPACK_MODULE_LIST//,/ }; do
      mod_name=$m
      if [[ "$m" == **"/"** ]]; then
        mod_name=$(dirname $m)
      fi
PACKAGESYML+="  $mod_name:
    paths:
      $mod_name@$(get_module_version $m): $(get_module_path $m)
    buildable: False
"
    done

    # add system packages
    echo "$PACKAGESYML" >> $SPACK_ROOT/etc/spack/defaults/packages.yaml
  fi
fi
