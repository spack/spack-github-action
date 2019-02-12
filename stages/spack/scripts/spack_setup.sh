#!/bin/bash
set -ex

echo "using $PWD/install/spack as spack_root"
SPACK_ROOT=$PWD/install/spack
spack_root=$SPACK_ROOT

# clone
if [ ! -d $spack_root ]; then
  ssh -o StrictHostKeyChecking=no $spack_git_url
  git clone $spack_git_url install/spack
fi

# bash env
export PATH=$PATH:$spack_root/bin
source $spack_root/share/spack/setup-env.sh

# load modules
if [ -z "$spack_use_modules" ]; then
  echo "Expecting spack_use_modules variable (with 'true' or 'false')"
  exit 1
fi
if [ "$spack_use_modules" == "true" ] && [ -z "$spack_module_list" ]; then
  echo "Expecting spack_use_modules variable with list of modules to load"
  exit 1
else
  module purge
  module load $spack_module_list
  for m in ${spack_module_list//,/ }; do
    module load $m
  done
fi

# reset spack config
if [ "$1" == "fetch" ]; then
  git -c $spack_root fetch
  git -c $spack_root reset --hard $spack_git_ref

  if [ $spack_use_modules == 'true' ]; then
    function get_module_path {
      module_info=$(module show $1 2>&1 >/dev/null | grep 'prepend-path.* PATH' | awk '{ print $3 }')
      dirname $module_info
    }
    function get_module_version {
      basename $(get_module_path $1)
    }

    for m in ${spack_module_list//,/ }; do
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
    echo "$PACKAGESYML" >> $spack_root/etc/spack/defaults/packages.yaml
  fi
fi
