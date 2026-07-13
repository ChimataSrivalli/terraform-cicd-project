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
# Install Jenkins Repository
####################################################

mkdir -p /etc/apt/keyrings

wget -O /etc/apt/keyrings/jenkins-keyring.asc \
https://pkg.jenkins.io/debian-stable/jenkins.io-2026.key

echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" \
| tee /etc/apt/sources.list.d/jenkins.list >/dev/null

####################################################
# Install Jenkins
####################################################

apt-get update -y

apt-get install -y jenkins

####################################################
# Enable Jenkins
####################################################

systemctl daemon-reload

systemctl enable jenkins

systemctl restart jenkins

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
PUBLIC_IP=$(curl -s http://checkip.amazonaws.com)

echo "http://${PUBLIC_IP}:8080"

echo "========================================"
echo "Installation Complete"
echo "========================================"
