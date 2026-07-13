#!/bin/bash

set -euo pipefail

LOG_FILE="/var/log/bootstrap.log"

exec > >(tee -a "$LOG_FILE")
exec 2>&1

echo "=================================================="
echo " DevOps CI/CD Bootstrap Started"
echo "=================================================="

REPO_DIR="/home/ubuntu/terraform-cicd-project"

while [ ! -d "$REPO_DIR/scripts" ]; do
    echo "Waiting for repository to be available..."
    sleep 10
done

cd "$REPO_DIR"

chmod -R +x scripts

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

echo "Starting Services..."
./scripts/configure/start_services.sh

echo "Waiting for Jenkins..."

until curl -fs http://localhost:8080/login >/dev/null 2>&1
do
    sleep 10
done

echo "Installing ArgoCD..."
./scripts/install/install_argocd.sh

echo "Installing Monitoring..."
./scripts/install/install_monitoring.sh

echo "Verifying Installation..."
./scripts/verify/verify_installation.sh

apt-get autoremove -y
apt-get autoclean -y
apt-get clean

echo "=================================================="
echo " Bootstrap Completed Successfully"
echo "=================================================="