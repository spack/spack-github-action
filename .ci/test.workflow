workflow "spack tests" {
  resolves = "run"
}

action "lint" {
  uses = "actions/bin/shellcheck@master"
  args = "-x run/entrypoint.sh scripts/spack_setup.sh "
}

action "run" {
  needs = "lint"
  uses = "./run"
  args = ["lulesh2.0", "-s", "100", "-i", "10"]
  env = {
      SPACK_GIT_URL = "https://github.com/spack/spack"
      SPACK_GIT_REF = "develop"
      SPACK_SPEC = "lulesh~mpi"
  }
}
