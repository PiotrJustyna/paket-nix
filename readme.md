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

  I changed the `framework` from `net5.0` to `net7.0`, but your `paket.dependencies` should look like this:

  ```
  source https://api.nuget.org/v3/index.json
  
  storage: none
  framework: net7.0
  ```

* Add the following dependencies to `paket.dependencies`:

  ```
  nuget FSharp.Core
  nuget Serilog
  ```

  Your `paket.dependencies` should look like this:

  ```
  source https://api.nuget.org/v3/index.json
  
  storage: none
  framework: net7.0
  
  nuget FSharp.Core
  nuget Serilog
  ```

* Add a new file to the `ConsoleApp` directory: `paket.references`. It should contain project-specific dependencies. In this case, we're just going to add two lines:

  ```
  FSharp.Core
  Serilog
  ```

* `dotnet paket install` - creates `paket.lock` file if one does not exist yet with the following output:

  ```bash
  Paket version 7.2.1+8e4eb74b42fbd45f39f7afce9184c16ebb65f16c
  Resolving dependency graph...
  Updated packages:
    Group: Main
      - FSharp.Core: 7.0.300 (added)
      - Serilog: 2.12.0 (added)
  Installing into projects:
  Created dependency graph (2 packages in total)
    - Project ConsoleApp.fsproj needs to be restored
  Calling dotnet restore on PaketNix.sln
    Determining projects to restore...
    Paket version 7.2.1+8e4eb74b42fbd45f39f7afce9184c16ebb65f16c
    The last full restore is still up to date. Nothing left to do.
    Total time taken: 0 milliseconds
    Paket version 7.2.1+8e4eb74b42fbd45f39f7afce9184c16ebb65f16c
    Restoring /Users/piotrjustyna/Documents/code/paket-nix/ConsoleApp/ConsoleApp.fsproj
    Starting restore process.
    Total time taken: 0 milliseconds
    Restored /Users/piotrjustyna/Documents/code/paket-nix/ConsoleApp/ConsoleApp.fsproj (in 263 ms).
    1 of 2 projects are up-to-date for restore.
    Total time taken: 3 seconds
  ```

  Your `paket.lock` should look like this:

  ```
  STORAGE: NONE
  RESTRICTION: == net7.0
  NUGET
    remote: https://api.nuget.org/v3/index.json
      FSharp.Core (7.0.300)
      Serilog (2.12)
  ```

* Leverage nuget functionality in your code:

  ```f#
  open Serilog
  
  let libraryGreeting = Library.Say.hello "Piotr"
  
  Log.Logger.Information($"{libraryGreeting}")
  ```

* make sure your `.gitignore` contains:

  ```bash
  #Paket dependency manager
  paket-files/
  ```

### building your code

Please note that the repository is equipped with two scripts:

* `./build.sh`
* `./run.sh`

Which are leveraging docker to build and run the application. This repository provides two options for building and running the code:

* simply build and run with your chosen ide - that way you are building and running the code using the **locally installed** dotnet dependencies. Ideal for day-to-day local development workflows.
* build and run with those two shell scripts - that way you are building and running the code using docker. Ideal as a starting point for a build agent, ci/cd. etc.

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

### to note

Unfortunately, rider is not a well supported ide meaning that it will point out problems where there are none - the solution compiles.

![](./img/sad%20rider.png)