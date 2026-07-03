#!/bin/bash

set -euo pipefail

echo "========================================"
echo "Installing Minikube"
echo "========================================"

####################################################
# Check Docker
####################################################

if ! systemctl is-active --quiet docker; then
    echo "Docker is not running. Starting Docker..."
    sudo systemctl start docker
fi

####################################################
# Download Minikube
####################################################

curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64

sudo install minikube-linux-amd64 /usr/local/bin/minikube

rm -f minikube-linux-amd64

####################################################
# Verify Installation
####################################################

echo "========================================"
echo "Minikube Version"
echo "========================================"

minikube version

####################################################
# Delete old root-owned cluster (optional)
####################################################

sudo minikube delete >/dev/null 2>&1 || true

####################################################
# Start Minikube
####################################################

echo "========================================"
echo "Starting Minikube"
echo "========================================"

minikube start \
    --driver=docker \
    --cpus=2 \
    --memory=2500

####################################################
# Wait for Cluster
####################################################

kubectl wait \
    --for=condition=Ready node/minikube \
    --timeout=300s

####################################################
# Verify
####################################################

kubectl get nodes

kubectl get pods -A

echo "========================================"
echo "Minikube installation completed."
echo "========================================"
