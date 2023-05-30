open Serilog

let libraryGreeting = Library.Say.hello "Piotr"

Log.Logger.Information($"{libraryGreeting}")