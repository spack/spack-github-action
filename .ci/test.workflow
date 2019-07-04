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

action "run lulesh" {
  needs = "spack install"
  uses = "./"
  runs = ["sh", "-c",
           "mpiexec -np 1 ./install/linux-debian10-x86_64/gcc-8.3.0/lulesh-2.0.3-6qj75oexwprfrr6jjq52cbepcc6egxga/bin/lulesh2.0 -s 100 -i 10"]
}
