#!/bin/bash

set -euo pipefail

echo "========================================"
echo "Starting DevOps Services"
echo "========================================"

####################################################
# Start Docker
####################################################

echo "Starting Docker..."

systemctl enable docker
systemctl restart docker

####################################################
# Start Jenkins
####################################################

echo "Starting Jenkins..."

systemctl enable jenkins
systemctl restart jenkins

####################################################
# Wait for Jenkins
####################################################

sleep 20

####################################################
# Start Minikube
####################################################

echo "Checking Minikube..."

if ! minikube status >/dev/null 2>&1; then

    echo "Starting Minikube..."

    minikube start \
        --driver=docker \
        --cpus=2 \
        --memory=2500

else

    echo "Minikube is already running."

fi

####################################################
# Verify Docker
####################################################

echo "========================================"
echo "Docker Status"
echo "========================================"

systemctl is-active docker

####################################################
# Verify Jenkins
####################################################

echo "========================================"
echo "Jenkins Status"
echo "========================================"

systemctl is-active jenkins

####################################################
# Verify Minikube
####################################################

echo "========================================"
echo "Minikube Status"
echo "========================================"

minikube status

####################################################
# Verify Kubernetes
####################################################

echo "========================================"
echo "Kubernetes Nodes"
echo "========================================"

kubectl get nodes

echo "========================================"
echo "All services started successfully."
echo "========================================"
