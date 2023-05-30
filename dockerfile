FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build-env

WORKDIR /App

COPY ./.paket/ ./.paket/
COPY ./paket.dependencies ./
COPY ./paket.lock ./

COPY ./.config/ ./.config/

COPY ./ConsoleApp/ ./ConsoleApp/
COPY ./Library/ ./Library/
COPY ./PaketNix.sln ./

RUN dotnet tool restore

RUN dotnet paket restore

RUN dotnet build ./PaketNix.sln

RUN dotnet publish ./ConsoleApp/ConsoleApp.fsproj -c Release -o out

FROM mcr.microsoft.com/dotnet/runtime:7.0

WORKDIR /App

COPY --from=build-env /App/out .

ENTRYPOINT ["dotnet", "ConsoleApp.dll"]