#!/bin/bash

set -euo pipefail

echo "========================================"
echo "Installing Minikube"
echo "========================================"

# Update package index
sudo apt-get update -y

# Install required packages
sudo apt-get install -y curl conntrack socat

# Download Minikube
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64

# Install Minikube
sudo install minikube-linux-amd64 /usr/local/bin/minikube

# Clean up installer
rm -f minikube-linux-amd64

# Verify installation
echo "========================================"
minikube version

echo "========================================"
echo "Starting Minikube"
echo "========================================"

# Start Minikube using Docker driver
sudo -u ubuntu minikube start \
    --driver=docker \
    --cpus=2 \
    --memory=4096 \
    --kubernetes-version=stable \
    --embed-certs \
    --wait=all

echo "========================================"
echo "Enabling Minikube Addons"
echo "========================================"

sudo -u ubuntu minikube addons enable ingress
sudo -u ubuntu minikube addons enable metrics-server

echo "========================================"
echo "Cluster Information"
echo "========================================"

sudo -u ubuntu kubectl get nodes
sudo -u ubuntu kubectl get pods -A

echo "========================================"
echo "Minikube installation completed successfully"
echo "========================================"