# Stage 1: Build the application
FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /app

# Copy the .csproj file to the working directory
COPY *.csproj ./

# Restore the dependencies and tools
RUN dotnet restore

# Copy the remaining source files
COPY . ./

# Build the application
RUN dotnet publish -c Release -o out

# Stage 2: Run the application
FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS runtime
WORKDIR /app

# Copy the published application
COPY --from=build /app/out ./

# Run the application
ENTRYPOINT ["dotnet", "aspnetapp.dll"]
