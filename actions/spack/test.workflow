workflow "spack tests" {
  resolves = "run"
}

action "lint" {
  uses = "actions/bin/shellcheck@master"
  args = "./actions/spack/install.sh"
}

action "install" {
  needs = "lint"
  uses = "./actions/spack"
  runs = "install"
  env = {
      SPACK_GIT_URL = "https://github.com/spack/spack"
      SPACK_GIT_REF = "develop"
      SPACK_SPEC = "lulesh~mpi"
  }
}

action "run" {
  needs = "install"
  uses = "./actions/spack"
  runs = "run"
  args = ["lulesh2.0", "-s", "100", "-i", "10"]
  env = {
      SPACK_SPEC = "lulesh~mpi"
  }
}
