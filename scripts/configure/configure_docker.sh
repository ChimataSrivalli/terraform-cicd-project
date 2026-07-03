#!/bin/bash

set -euo pipefail

echo "========================================"
echo "Configuring Docker"
echo "========================================"

####################################################
# Check Docker Installation
####################################################

if ! command -v docker >/dev/null 2>&1; then
    echo "ERROR: Docker is not installed."
    exit 1
fi

####################################################
# Create Docker Group (if it doesn't exist)
####################################################

if ! getent group docker >/dev/null; then
    groupadd docker
fi

####################################################
# Add ubuntu user to Docker group
####################################################

if id "ubuntu" &>/dev/null; then
    usermod -aG docker ubuntu
    echo "Added ubuntu to docker group."
fi

####################################################
# Add jenkins user to Docker group
####################################################

if id "jenkins" &>/dev/null; then
    usermod -aG docker jenkins
    echo "Added jenkins to docker group."
fi

####################################################
# Restart Docker
####################################################

systemctl restart docker

####################################################
# Verify Docker
####################################################

echo "========================================"
echo "Docker Service Status"
echo "========================================"

systemctl is-active docker

echo "========================================"
echo "Docker Group Members"
echo "========================================"

getent group docker

echo "========================================"
echo "Docker configuration completed."
echo "========================================"
