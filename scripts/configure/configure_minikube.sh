#!/bin/bash

set -euo pipefail

echo "========================================"
echo "Configuring Minikube"
echo "========================================"

####################################################
# Wait for Cluster
####################################################

kubectl wait \
--for=condition=Ready node/minikube \
--timeout=300s

####################################################
# Enable Addons
####################################################

minikube addons enable ingress

minikube addons enable metrics-server

####################################################
# Verify
####################################################

kubectl get nodes

kubectl get pods -A

echo "========================================"
echo "Minikube configured successfully"
echo "========================================"