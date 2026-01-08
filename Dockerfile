# =========================
# Build stage
# =========================
FROM mcr.microsoft.com/dotnet/sdk:10.0-alpine AS build
WORKDIR /src

# Copy project files first for layer caching
COPY src/OpenIpam.Agent/OpenIpam.Agent.csproj src/OpenIpam.Agent/
RUN dotnet restore src/OpenIpam.Agent/OpenIpam.Agent.csproj

# Copy remaining source
COPY src/ src/

# Publish
RUN dotnet publish src/OpenIpam.Agent/OpenIpam.Agent.csproj \
    -c Release \
    -o /app/publish \
    /p:UseAppHost=false

# =========================
# Runtime stage
# =========================
FROM mcr.microsoft.com/dotnet/runtime:9.0-alpine AS final
WORKDIR /app

# Create non-root user
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
USER appuser

# Copy published output
COPY --from=build /app/publish .

# Required for Azure SDK diagnostics
ENV DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=false \
    ASPNETCORE_URLS=http://+:8080 \
    DOTNET_RUNNING_IN_CONTAINER=true

ENTRYPOINT ["dotnet", "OpenIpam.Agent.dll"]
