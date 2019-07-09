# Spack

Install packages using [Spack](https://github.com/spack/spack).

## Usage

This action creates a `$GITHUB_WORKSPACE/spack/` folder where all 
configuration files are stored. An [environment][env] is created in 
`$GITHUB_WORKSPACE/spack/env`  and a view for this environment in 
`$GITHUB_WORKSPACE/spack/env/view`. The entrypoint creates/loads the 
environment and adds the `bin/` folder to the `PATH`.

### Example workflow

#### Statically linking binaries

```hcl
workflow "install and run LULESH" {
  resolves = "run"
}

action "install" {
  uses = "popperized/spack@master"
  args = "spack install lulesh~mpi"
}

action "run" {
  needs = "install"
  uses = "popperized/spack@master"
  args = "lulesh2.0 -s 100 -i 10"
}
```

## License

[MIT](LICENSE). Please see additional information in each 
subdirectory.
