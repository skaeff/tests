FROM mcr.microsoft.com/dotnet/core/runtime:3.1-buster-slim AS base
WORKDIR /app

FROM mcr.microsoft.com/dotnet/core/sdk:3.1-buster AS build
WORKDIR /src
COPY ["emulator/emulator.csproj", "emulator/"]
RUN dotnet restore "emulator/emulator.csproj"
COPY . .
WORKDIR "/src/emulator"
RUN dotnet build "emulator.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "emulator.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "emulator.dll"]