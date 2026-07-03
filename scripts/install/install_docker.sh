#!/bin/bash

set -euo pipefail

echo "========================================"
echo "Installing Docker"
echo "========================================"

# Update package index
apt-get update -y

# Install Docker
apt-get install -y docker.io

# Enable Docker service
systemctl enable docker
systemctl start docker

# Verify Docker service
systemctl is-active --quiet docker

echo "========================================"
echo "Docker Version"
echo "========================================"

docker --version

echo "========================================"
echo "Docker Service Status"
echo "========================================"

systemctl status docker --no-pager

echo "========================================"
echo "Docker installation completed."
echo "========================================"