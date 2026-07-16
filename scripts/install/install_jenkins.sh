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

echo
echo "Java Version"
java -version

####################################################
# Install Required Packages
####################################################

sudo apt-get update -y

sudo apt-get install -y \
    curl \
    wget \
    gnupg \
    ca-certificates

####################################################
# Remove Old Jenkins Repository
####################################################

sudo rm -f /etc/apt/sources.list.d/jenkins.list
sudo rm -f /etc/apt/keyrings/jenkins-keyring.*

####################################################
# Create Keyring Directory
####################################################

sudo mkdir -p /etc/apt/keyrings

####################################################
# Download Jenkins GPG Key (2026)
####################################################

curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2026.key \
| gpg --dearmor \
| sudo tee /etc/apt/keyrings/jenkins-keyring.gpg >/dev/null

sudo chmod 644 /etc/apt/keyrings/jenkins-keyring.gpg

####################################################
# Add Jenkins Repository
####################################################

echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.gpg] https://pkg.jenkins.io/debian-stable binary/" \
| sudo tee /etc/apt/sources.list.d/jenkins.list >/dev/null

####################################################
# Update Repository
####################################################

sudo apt-get update -y

####################################################
# Verify Repository
####################################################

echo
echo "Available Jenkins Package"

apt-cache policy jenkins

####################################################
# Install Jenkins
####################################################

sudo apt-get install -y jenkins

####################################################
# Enable Jenkins
####################################################

sudo systemctl daemon-reload

sudo systemctl enable jenkins

sudo systemctl restart jenkins

sleep 20

####################################################
# Verify Jenkins
####################################################

if sudo systemctl is-active --quiet jenkins
then
    echo
    echo "========================================"
    echo "Jenkins Installed Successfully"
    echo "========================================"
else
    echo
    echo "ERROR : Jenkins Failed To Start"
    sudo systemctl status jenkins --no-pager
    exit 1
fi

####################################################
# Jenkins Information
####################################################

echo
echo "========================================"
echo "Jenkins Status"
echo "========================================"

sudo systemctl status jenkins --no-pager

echo
echo "========================================"
echo "Initial Admin Password"
echo "========================================"

sudo cat /var/lib/jenkins/secrets/initialAdminPassword

####################################################
# Public IP
####################################################

TOKEN=$(curl -X PUT \
"http://169.254.169.254/latest/api/token" \
-H "X-aws-ec2-metadata-token-ttl-seconds:21600" \
-s)

PUBLIC_IP=$(curl \
-H "X-aws-ec2-metadata-token:$TOKEN" \
-s http://169.254.169.254/latest/meta-data/public-ipv4)

echo
echo "========================================"
echo "Jenkins URL"
echo "========================================"

echo "http://${PUBLIC_IP}:8080"

echo
echo "========================================"
echo "Installation Complete"
echo "========================================"