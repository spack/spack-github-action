workflow "spack tests" {
  resolves = "run"
}

action "lint" {
  uses = "actions/bin/shellcheck@master"
  args = "-x install.sh"
}

action "install" {
  needs = "lint"
  uses = "./"
  runs = "install.sh"
  env = {
      SPACK_GIT_URL = "https://github.com/spack/spack"
      SPACK_GIT_REF = "develop"
      SPACK_SPEC = "lulesh~mpi"
  }
}

action "run" {
  needs = "install"
  uses = "./"
  runs = "run"
  args = ["lulesh2.0", "-s", "100", "-i", "10"]
  env = {
      SPACK_SPEC = "lulesh~mpi"
  }
}
