# Use a multi-stage build
FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /src

# Copy the solution file and restore dependencies
COPY ["Simulation.sln", "./"]
COPY ["backend/backend.csproj", "backend/"]
RUN dotnet restore

# Copy the rest of the code
COPY ["backend/", "backend/"]

# Build the application
WORKDIR "/src/backend"
RUN dotnet build -c Release -o /app/build

# Publish the application
FROM build AS publish
WORKDIR "/src/backend"
RUN dotnet publish -c Release -o /app/publish

# Final stage
FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "backend.dll"]   