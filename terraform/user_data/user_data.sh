#!/bin/bash

set -euo pipefail

LOG_FILE="/var/log/bootstrap.log"

exec > >(tee -a "$LOG_FILE")
exec 2>&1

echo "=================================================="
echo " DevOps CI/CD Bootstrap Started"
echo "=================================================="

####################################################
# Update Ubuntu
####################################################

sudo apt-get update -y
sudo apt-get upgrade -y

####################################################
# Move to Project Directory
####################################################

cd /workspaces/terraform-cicd-project/terraform

chmod -R +x scripts

####################################################
# Installation Scripts
####################################################

echo "Installing Git..."
./scripts/install/install_git.sh

echo "Installing Java..."
./scripts/install/install_java.sh

echo "Installing Docker..."
./scripts/install/install_docker.sh

echo "Configuring Docker..."
./scripts/configure/configure_docker.sh

echo "Installing kubectl..."
./scripts/install/install_kubectl.sh

echo "Installing Minikube..."
./scripts/install/install_minikube.sh

echo "Configuring Minikube..."
./scripts/configure/configure_minikube.sh

echo "Installing Helm..."
./scripts/install/install_helm.sh

echo "Installing Jenkins..."
./scripts/install/install_jenkins.sh

####################################################
# Start Services
####################################################

echo "Starting Services..."
./scripts/configure/start_services.sh

####################################################
# Wait for Jenkins
####################################################

echo "Waiting for Jenkins..."

until curl -fs http://localhost:8080/login >/dev/null 2>&1
do
    sleep 10
done

####################################################
# Install ArgoCD
####################################################

echo "Installing ArgoCD..."
./scripts/install/install_argocd.sh

####################################################
# Install Monitoring
####################################################

echo "Installing Prometheus & Grafana..."
./scripts/install/install_monitoring.sh

####################################################
# Verify Installation
####################################################

echo "Running Verification..."
./scripts/verify/verify_installation.sh

####################################################
# Cleanup
####################################################

sudo apt-get autoremove -y
sudo apt-get autoclean -y
sudo apt-get clean

####################################################
# Finished
####################################################

echo "=================================================="
echo " Bootstrap Completed Successfully"
echo "=================================================="

echo
echo "Bootstrap Log:"
echo "/var/log/bootstrap.log"