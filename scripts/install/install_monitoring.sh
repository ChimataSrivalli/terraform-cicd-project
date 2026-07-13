#!/bin/bash

set -euo pipefail

echo "========================================"
echo "Installing Prometheus & Grafana"
echo "========================================"

####################################################
# Wait for Kubernetes
####################################################

kubectl wait \
--for=condition=Ready node/minikube \
--timeout=300s

####################################################
# Create Namespace
####################################################

kubectl create namespace monitoring \
--dry-run=client -o yaml | kubectl apply -f -

####################################################
# Add Helm Repositories
####################################################

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts

helm repo add grafana https://grafana.github.io/helm-charts

helm repo update

####################################################
# Install Prometheus
####################################################

helm upgrade --install prometheus \
prometheus-community/prometheus \
-n monitoring \
--set server.service.type=NodePort \
--set server.persistentVolume.enabled=false \
--wait

####################################################
# Install Grafana
####################################################

helm upgrade --install grafana \
grafana/grafana \
-n monitoring \
--set service.type=NodePort \
--set persistence.enabled=false \
--set adminPassword=admin123 \
--wait

####################################################
# Verify
####################################################

echo
echo "Prometheus Pods"

kubectl get pods -n monitoring

echo

echo "Services"

kubectl get svc -n monitoring

echo

echo "========================================"
echo "Monitoring Installed Successfully"
echo "========================================"