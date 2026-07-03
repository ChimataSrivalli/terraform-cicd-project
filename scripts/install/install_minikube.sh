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
    systemctl start docker
fi

####################################################
# Download Minikube
####################################################

curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64

install minikube-linux-amd64 /usr/local/bin/minikube

rm -f minikube-linux-amd64

####################################################
# Verify Installation
####################################################

echo "========================================"
echo "Minikube Version"
echo "========================================"

minikube version

####################################################
# Start Minikube
####################################################

echo "========================================"
echo "Starting Minikube"
echo "========================================"

minikube start \
    --driver=docker \
    --cpus=2 \
    --memory=4096 \
    --force

####################################################
# Wait for Kubernetes
####################################################

echo "Waiting for Kubernetes node..."

for i in {1..30}; do
    if kubectl get nodes >/dev/null 2>&1; then
        break
    fi

    echo "Attempt $i/30..."
    sleep 10
done

####################################################
# Verify Cluster
####################################################

echo "========================================"
echo "Cluster Information"
echo "========================================"

kubectl get nodes

kubectl get pods -A

echo "========================================"
echo "Minikube installation completed."
echo "========================================"