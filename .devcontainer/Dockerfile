FROM mcr.microsoft.com/devcontainers/dotnet:10.0

# -------------------------
# Install OS dependencies
# -------------------------
RUN apt-get update && apt-get install -y \
    curl \
    ca-certificates \
    gnupg \
    lsb-release \
    git \
    && rm -rf /var/lib/apt/lists/*

# -------------------------
# Install Azure CLI
# -------------------------
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash

# -------------------------
# Install Azure Developer CLI
# -------------------------
RUN curl -fsSL https://aka.ms/install-azd.sh | bash

# -------------------------
# Install Bicep (explicit)
# -------------------------
RUN az bicep install

# -------------------------
# Docker CLI (not daemon)
# -------------------------
RUN apt-get update && apt-get install -y docker-cli \
    && rm -rf /var/lib/apt/lists/*

# -------------------------
# Non-root user already configured by base image
# -------------------------
