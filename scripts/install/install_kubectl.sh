#!/bin/bash

set -euo pipefail

echo "========================================"
echo "Installing kubectl"
echo "========================================"

# Update package index
apt-get update -y

# Download the latest stable kubectl
KUBECTL_VERSION=$(curl -L -s https://dl.k8s.io/release/stable.txt)

echo "Latest kubectl version: ${KUBECTL_VERSION}"

curl -LO "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl"

# Install kubectl
install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# Clean up
rm -f kubectl

# Verify installation
echo "========================================"
echo "kubectl Version"
echo "========================================"

kubectl version --client

echo "========================================"
echo "kubectl installed successfully."
echo "========================================"