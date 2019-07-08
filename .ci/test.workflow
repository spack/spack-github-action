workflow "spack tests" {
  resolves = "run"
}

action "lint" {
  uses = "actions/bin/shellcheck@master"
  args = "-x entrypoint.sh"
}

action "install" {
  needs = "lint"
  uses = "./"
  args = "install lulesh~mpi"
}

action "run" {
  needs = "install"
  uses = "./"
  runs = [
    "sh", "-c",
    "$(spack location --install-dir lulesh~mpi)/bin/lulesh2.0 -s 100 -i 10"
  ]
}
