# Stage Library

This repository contains a library of generic stages that can be used 
to create experimentation pipelines. Every subfolder contained in the 
`stages/` folder corresponds to a stage.

## Stage Definition Convention

The convention is the following:

  * The minimal folder structure for a stage is:

    ```
    stages/<name>
    | README.md
    | popper.yml
    | run.sh
    | test.sh
    ```

  * The name of the folder is the name of the stage.

  * Every stage performs one or more tasks. In the example, a `run` 
    task is defined (the `run.sh` script). Every new bash script in 
    this folder defines a new task.

  * Every stage folder contains at least two bash scripts, one 
    defining a task (e.g. `run.sh` in the above example) and another 
    one named `test.sh` that is executed by the CI service to test the 
    stage.

  * The `popper.yml` file describes the stage. The following are the 
    expected YAML entries:

      * `description`. A short description of what the stage does.

      * `dependencies`. List of binary dependencies that need to be 
        installed on the machine that is executing the pipeline. 
        Format is `binary@version`.

      * `parameters`. Dictionary of parameters, expected to be read 
        available in a `parameters.yml` file. Parameters with `null` 
        value assigned to them are required (In the case of lists or 
        dictionaries, they contain a null string). Name of parameter 
        should be prefixed with name of stage to avoid name clashes 
        between distinct stages. For example `spack_git_url` is the 
        name of the variable holding the Git URL for the spack stage.

      * `secrets`. Dictionary of environment variables containing 
        sensitive information. These are expected to be injected into 
        the environment prior to the execution of this stage. These 
        variables differ from `parameters` in that these should not be 
        shared nor kept inside the repository storing the 
        experimentation pipeline. The name of secrets should be 
        prefixed with the name of the stage to avoid name clashes 
        between distinct stages.

      * `tasks`. Dictionary of tasks and their description. An task 
        name has to be one word. For example:

        ```yml
        tasks:
          request: execute a request
          release: release resources acquired by the request task
        ```

      * `tags`. List of tags used to categorize the stage.

      * `docker`. If the stage is packaged as a container image, then 
        a `docker` entry points to its name in the `[url]/repo/image` 
        format.

  * If a task installs software, it should do so in an `install/` 
    folder inside the pipeline folder. The folder name should 
    correspond to the name of the stage, e.g. `install/spack`.

  * Scripts used by tasks go in a `scripts/` folder, prefixed by name 
    of stage. For example, `cloudlab_request.py` contains python code 
    for the `request` task for the `cloudlab` stage.

  * Output files for a stage are placed in a subfolder inside 
    `output/`, named as the name of the stage, e.g. `output/spack`.

  * If a stage has dependencies, a `docker/` folder is created such 
    that these dependencies are packaged in a container image. The 
    available packages for testing stages in this repository are those 
    that come with Travis' Ubuntu Xenial environment.

## Stage Execution Convention

This is the high-level steps that are executed every time a stage is 
executed:

 1. Check whether binaries in `dependencies` are present.
 2. Check whether `secrets` are defined as environment variables 
    defined.
 3. Run the stage's action.
