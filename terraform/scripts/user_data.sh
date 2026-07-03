#!/bin/bash

set -euxo pipefail

echo "===== SYSTEM UPDATE ====="
apt update -y
apt upgrade -y

echo "===== BASE PACKAGES ====="
apt install -y \
    curl \
    wget \
    git \
    unzip \
    apt-transport-https \
    ca-certificates \
    gnupg \
    lsb-release \
    software-properties-common

####################################################
# JAVA (Required for Jenkins)
####################################################
echo "===== INSTALLING JAVA ====="
apt install -y openjdk-17-jdk

####################################################
# JENKINS INSTALLATION
####################################################
echo "===== INSTALLING JENKINS ====="

curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io.key | tee \
    /usr/share/keyrings/jenkins-keyring.asc > /dev/null

echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
    https://pkg.jenkins.io/debian-stable binary/ | tee \
    /etc/apt/sources.list.d/jenkins.list > /dev/null

apt update -y
apt install -y jenkins

systemctl enable jenkins
systemctl start jenkins

####################################################
# DOCKER INSTALLATION
####################################################
echo "===== INSTALLING DOCKER ====="
apt install -y docker.io

systemctl enable docker
systemctl start docker

# IMPORTANT: Fix permissions for Jenkins + Ubuntu user
usermod -aG docker ubuntu || true
usermod -aG docker jenkins || true

####################################################
# KUBECTL INSTALLATION
####################################################
echo "===== INSTALLING KUBECTL ====="

curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

chmod +x kubectl
mv kubectl /usr/local/bin/

####################################################
# MINIKUBE INSTALLATION
####################################################
echo "===== INSTALLING MINIKUBE ====="

curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64

install minikube-linux-amd64 /usr/local/bin/minikube

####################################################
# START MINIKUBE (Docker driver)
####################################################
echo "===== STARTING MINIKUBE ====="

systemctl restart docker

minikube start --driver=docker || true

####################################################
# HELM INSTALLATION
####################################################
echo "===== INSTALLING HELM ====="

curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

####################################################
# ARGO CD INSTALLATION
####################################################
echo "===== INSTALLING ARGO CD ====="

kubectl create namespace argocd || true

kubectl apply -n argocd \
  -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml || true

####################################################
# PROMETHEUS + GRAFANA
####################################################
echo "===== INSTALLING MONITORING STACK ====="

kubectl create namespace monitoring || true

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts || true
helm repo update

helm install prometheus prometheus-community/kube-prometheus-stack \
    --namespace monitoring || true

####################################################
# FINAL FIX (IMPORTANT)
####################################################
echo "===== FINAL SYSTEM FIX ====="

# ensure docker permissions are applied
newgrp docker || true

# optional reboot to stabilize services
# reboot

####################################################
# COMPLETION MESSAGE
####################################################
echo "===== SETUP COMPLETE ====="
echo "Jenkins: http://<EC2-PUBLIC-IP>:8080"
echo "Grafana: http://<EC2-PUBLIC-IP>:3000"
echo "Prometheus: http://<EC2-PUBLIC-IP>:9090"