FROM mcr.microsoft.com/dotnet/core/aspnet:2.1-stretch-slim AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/core/sdk:2.1-stretch AS build
WORKDIR /src
COPY ["WebApplication6/WebApplication6.csproj", "WebApplication6/"]
RUN dotnet restore "WebApplication6/WebApplication6.csproj"
COPY . .
WORKDIR "/src/WebApplication6"
RUN dotnet build "WebApplication6.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "WebApplication6.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "WebApplication6.dll"]