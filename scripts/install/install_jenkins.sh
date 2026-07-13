#!/bin/bash

set -euo pipefail

echo "========================================"
echo "Installing Jenkins"
echo "========================================"

####################################################
# Verify Java
####################################################

if ! command -v java >/dev/null 2>&1; then
    echo "ERROR: Java is not installed."
    exit 1
fi

echo "Java Version:"
java -version


####################################################
# Add Jenkins Repository
####################################################

sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | \

sudo tee /etc/apt/keyrings/jenkins-keyring.asc >/dev/null


echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" | \
sudo tee /etc/apt/sources.list.d/jenkins.list >/dev/null
####################################################
# Install Jenkins
####################################################

sudo apt-get update -y

sudo apt-get install -y jenkins

####################################################
# Enable Jenkins
####################################################

sudo systemctl daemon-reload

sudo systemctl enable jenkins

sudo systemctl restart jenkins

sleep 15

####################################################
# Verify Jenkins
####################################################

if systemctl is-active --quiet jenkins; then
    echo "========================================"
    echo "Jenkins installed successfully."
    echo "========================================"
else
    echo "Jenkins installation failed."
    exit 1
fi

echo "========================================"
echo "Jenkins Version"
echo "========================================"

jenkins --version || true

echo "========================================"
echo "Jenkins Initial Password"
echo "========================================"

cat /var/lib/jenkins/secrets/initialAdminPassword

echo "========================================"
echo "Jenkins URL"
echo "========================================"

echo "Jenkins is running on port 8080."
echo "Access it using your EC2 public IP:"
<<<<<<< HEAD
=======

>>>>>>> ee667f1 (2)
echo "http://${PUBLIC_IP}:8080"

echo "========================================"
echo "Installation Complete"
echo "========================================"
