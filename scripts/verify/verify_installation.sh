#!/bin/bash

set -euo pipefail

echo "========================================"
echo "Verifying Installation"
echo "========================================"

echo
echo "Git"
git --version

echo
echo "Java"
java -version

echo
echo "Docker"
docker --version

echo
echo "kubectl"
kubectl version --client

echo
echo "Minikube"
minikube version

echo
echo "Helm"
helm version

echo
echo "Jenkins"
sudo systemctl status jenkins --no-pager

echo
echo "Kubernetes Nodes"
kubectl get nodes

echo
echo "Pods"
kubectl get pods -A

echo
echo "========================================"
echo "Verification Completed Successfully"
echo "========================================"