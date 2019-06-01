workflow "spack tests" {
  resolves = "run with spack"
}

action "lint" {
  uses = "actions/bin/shellcheck@master"
  args = "-x entrypoint.sh"
}

action "run with spack" {
  needs = "lint"
  uses = "./"
  args = "install lulesh~mpi"
  env = {
      SPACK_RESET_CONFIG="true"
      SPACK_GIT_REF ="develop"
  }
}
