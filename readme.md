# paket-nix

paket experiments with unix/linux systems

## how to use

### preparation

Install and restore Paket as a local tool in the root of your codebase.

* `dotnet new tool-manifest` - this will create `.config/dotnet-tools.json` containing:

  ```json
  {
    "version": 1,
    "isRoot": true,
    "tools": {}
  }
  ```

* `dotnet tool install paket` - this adds paket to `.config/dotnet-tools.json` outputting the following:

  ```bash
  You can invoke the tool from this directory using the following commands: 'dotnet tool run paket' or 'dotnet paket'.
  Tool 'paket' (version '7.2.1') was successfully installed. Entry is added to the manifest file /Users/piotrjustyna/Documents/code/paket-nix/.config/dotnet-tools.json.
  ```

  `.config/dotnet-tools.json` should look like this now:

  ```json
  {
    "version": 1,
    "isRoot": true,
    "tools": {
      "paket": {
        "version": "7.2.1",
        "commands": [
          "paket"
        ]
      }
    }
  }
  ```

* `dotnet tool restore` - restore the freshly installed tool with the following output:

  ```bash
  Tool 'paket' (version '7.2.1') was restored. Available commands: paket
  
  Restore was successful.
  ```

* `dotnet paket init` - create the `paket.dependencies` file with the following output:

  ```bash
  Paket version 7.2.1+8e4eb74b42fbd45f39f7afce9184c16ebb65f16c
  Total time taken: 0 milliseconds
  ```

* make sure your `.gitignore` contains:

  ```bash
  #Paket dependency manager
  paket-files/
  ```

### building your code

Following paket commands should execute ***before*** your code gets built, so integrate the commands in whatever way suits your dev workflow.

#### bash

For build scripts, simply add the following lines before the commands building your code:

```bash
dotnet tool restore
dotnet paket restore
```

#### ide

For IDEs, simply add those two as scripts to be executed before building the code. Example with rider:

* add the two commands as shell scripts:

![](./img/dotnet%20tool%20restore.png)
![](./img/dotnet%20paket%20restore.png)

* in your build configuration, select "run another configuration" and add the two scripts:

![](./img/run%20another%20configuration.png)

* your final build configuration should look like this:
![](./img/build%20configuration.png)

### references:

* https://fsprojects.github.io/Paket/get-started.html#NET-Core-preferred
* https://stackoverflow.com/questions/15203498/intellij-idea-running-a-shell-script-as-a-run-debug-configuration