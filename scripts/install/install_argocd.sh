#!/bin/bash

set -euo pipefail

echo "========================================"
echo "Installing ArgoCD"
echo "========================================"

####################################################
# Wait for Minikube
####################################################

kubectl wait \
--for=condition=Ready node/minikube \
--timeout=300s

####################################################
# Create Namespace
####################################################

kubectl create namespace argocd --dry-run=client -o yaml | kubectl apply -f -

####################################################
# Install ArgoCD using Helm
####################################################

helm repo add argo https://argoproj.github.io/argo-helm

helm repo update

helm upgrade --install argocd argo/argo-cd \
    --namespace argocd \
    --set server.service.type=NodePort \
    --wait

####################################################
# Wait for Pods
####################################################

kubectl rollout status deployment/argocd-server \
    -n argocd \
    --timeout=300s

####################################################
# Verify
####################################################

kubectl get pods -n argocd

kubectl get svc -n argocd

echo

echo "========================================"
echo "ArgoCD Admin Password"
echo "========================================"

kubectl -n argocd get secret argocd-initial-admin-secret \
-o jsonpath="{.data.password}" | base64 -d

echo
echo

echo "========================================"
echo "ArgoCD Installed Successfully"
echo "========================================"