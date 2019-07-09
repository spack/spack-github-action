workflow "spack tests" {
  resolves = "run"
}

action "install" {
  uses = "./"
  args = "spack install lulesh~mpi"
}

action "run" {
  needs = "install"
  uses = "./"
  args = "lulesh2.0 -s 100 -i 10"
}
