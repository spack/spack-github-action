workflow "spack tests" {
  resolves = "run lulesh"
}

action "lint" {
  uses = "actions/bin/shellcheck@master"
  args = "-x entrypoint.sh"
}

action "add compiler"{
    needs = "lint"
    uses = "./"
    args = "compiler find"
}

action "spack install" {
  needs = "add compiler"
  uses = "./"
  args = "install lulesh+mpi"
}

action "create view" {
  needs = "spack install"
  uses = "./"
  args = "view -d yes hard -i ./install/ lulesh+mpi "
}

action "run lulesh" {
  needs = "create view"
  uses = "./"
  runs = ["sh", "-c",
           "mpiexec -np 1 ./install/bin/lulesh2.0 -s 100 -i 10"]
}
