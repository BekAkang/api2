# Stage 1: Build the application
FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /src

# Copy the .csproj file to the working directory
COPY api2/api.csproj .

# Restore NuGet packages
RUN dotnet restore

# Copy the entire solution to the working directory
COPY . .

# Build the application
RUN dotnet build -c Release -o /app/build

# Stage 2: Publish the application
FROM build AS publish
RUN dotnet publish -c Release -o /app/publish

# Stage 3: Create the final runtime image
FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS final
WORKDIR /app
COPY --from=publish /app/publish .

# Expose the port the app will run on
EXPOSE 80

# Define the entry point for the application
ENTRYPOINT ["dotnet", "api.dll"]