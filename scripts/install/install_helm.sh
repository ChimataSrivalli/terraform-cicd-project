#!/bin/bash

set -euo pipefail

echo "========================================"
echo "Installing Helm"
echo "========================================"

####################################################
# Check kubectl
####################################################

if ! command -v kubectl >/dev/null 2>&1; then
    echo "ERROR: kubectl is not installed."
    exit 1
fi

####################################################
# Download and Install Helm
####################################################

curl -fsSL -o get_helm.sh \
https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3

chmod +x get_helm.sh

./get_helm.sh

rm -f get_helm.sh

####################################################
# Verify Installation
####################################################

echo "========================================"
echo "Helm Version"
echo "========================================"

helm version

####################################################
# Verify Kubernetes Connection
####################################################

echo "========================================"
echo "Checking Kubernetes Cluster"
echo "========================================"

kubectl cluster-info

echo "========================================"
echo "Helm installation completed."
echo "========================================"