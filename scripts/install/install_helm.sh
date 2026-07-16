#!/bin/bash

set -euo pipefail

echo "========================================"
echo "Installing Helm"
echo "========================================"

####################################################
# Update Packages
####################################################

sudo apt-get update -y
sudo apt-get install -y curl apt-transport-https gnupg

####################################################
# Add Helm GPG Key
####################################################

curl -fsSL https://packages.buildkite.com/helm-linux/helm-debian/gpgkey | \
sudo gpg --dearmor -o /usr/share/keyrings/helm.gpg

####################################################
# Add Helm Repository
####################################################

echo "deb [signed-by=/usr/share/keyrings/helm.gpg] https://packages.buildkite.com/helm-linux/helm-debian/any/ any main" | \
sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
####################################################
# Install Helm
####################################################

sudo apt-get update -y

sudo apt-get install -y helm

####################################################
# Verify Installation
####################################################

echo "========================================"
echo "Helm Version"
echo "========================================"

helm version

echo "========================================"
echo "Adding Required Helm Repositories"
echo "========================================"

helm repo add argo https://argoproj.github.io/argo-helm

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts

helm repo add grafana https://grafana.github.io/helm-charts

helm repo update

echo "========================================"
echo "Helm installation completed successfully"
echo "========================================"
