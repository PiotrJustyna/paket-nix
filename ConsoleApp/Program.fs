open Serilog

Log.Logger <-
    LoggerConfiguration()
        .Enrich.FromLogContext()
        .CreateLogger()

let libraryGreeting =
    Library.Say.hello "Piotr"

Log.Logger.Information($"{libraryGreeting}")