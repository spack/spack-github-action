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
  args = "install lulesh~mpi"
}

action "run lulesh" {
  needs = "spack install"
  uses = "./"
  runs = ["sh", "-c",
           "mpiexec --allow-run-as-root -np 1 ./install/spack/bin/lulesh2.0 -s 100 -i 10"]
}
