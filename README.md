# Spack

Install packages using [Spack](https://github.com/spack/spack).

## Usage

The action installs packages into `$GITHUB_WORKSPACE/install`.

### Example workflow

```hcl
workflow "Install and run LULESH" {
  on = "push"
  resolves = "run lulesh"
}

action "install" {
  uses = "popperized/spack@master"
  args = "install lulesh~mpi cppflags=-static cflags=-static"
}

action "create view" {
  needs = "install"
  uses = "popperized/spack@master"
  args = "view -d yes hard -i ./install/ lulesh~mpi "
}

action "run lulesh" {
  needs = "create view"
  uses = "docker://debian:buster-slim"
  runs = ["sh", "-c", "install/bin/lulesh2.0 -s 100 -i 10"]
}
```

Note that the `install` action above instructs Spack to statically 
link the generated binary so that all the system dependencies are 
"taken out" of the container and placed into the `install/` folder. 
The `create view` action creates a [filesystem view][view] ( folders 
`bin/`, `doc/`, etc.) that the `run lulesh` action references.

## License

[MIT](LICENSE). Please see additional information in each 
subdirectory.

[view]: https://spack.readthedocs.io/en/v0.12.1/workflows.html#filesystem-views
