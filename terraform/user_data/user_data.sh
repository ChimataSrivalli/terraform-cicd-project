#!/bin/bash

set -euo pipefail

LOG_FILE="/var/log/devops-bootstrap.log"

exec > >(tee -a "$LOG_FILE") 2>&1

echo "========================================"
echo "Terraform CI/CD Bootstrap Started"
echo "========================================"

####################################################
# Update System
####################################################

apt-get update -y

####################################################
# Go to Project Directory
####################################################

PROJECT_DIR="/home/ubuntu/terraform-cicd-project"

if [ ! -d "$PROJECT_DIR" ]; then
    echo "ERROR: Project directory not found: $PROJECT_DIR"
    exit 1
fi

cd "$PROJECT_DIR"

####################################################
# Make All Scripts Executable
####################################################

chmod +x scripts/install/*.sh
chmod +x scripts/configure/*.sh
chmod +x scripts/verify/*.sh

####################################################
# Install Software
####################################################

bash scripts/install/install_git.sh
bash scripts/install/install_java.sh
bash scripts/install/install_docker.sh
bash scripts/install/install_jenkins.sh
bash scripts/install/install_kubectl.sh
bash scripts/install/install_minikube.sh
bash scripts/install/install_helm.sh

####################################################
# Configure Docker
####################################################

bash scripts/configure/configure_docker.sh

####################################################
# Start Services
####################################################

systemctl enable docker
systemctl enable jenkins

systemctl restart docker
systemctl restart jenkins

####################################################
# Start Minikube as ubuntu User
####################################################

sudo -u ubuntu bash <<EOF

minikube start \
    --driver=docker \
    --cpus=2 \
    --memory=2500

EOF

####################################################
# Verify Installation
####################################################

sudo -u ubuntu bash scripts/verify/verify_installation.sh

echo "========================================"
echo "Bootstrap Completed Successfully"
echo "========================================"
