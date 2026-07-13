#!/bin/bash

set -euo pipefail

echo "========================================"
echo "Installing Docker"
echo "========================================"

# Update package index
sudo apt-get update -y

# Install prerequisites
sudo apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

# Create keyrings directory
sudo install -m 0755 -d /etc/apt/keyrings

# Add Docker GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Add Docker repository
echo \
"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
https://download.docker.com/linux/ubuntu \
$(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update repositories
sudo apt-get update -y

# Install Docker Engine
sudo apt-get install -y \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-buildx-plugin

# Enable Docker
sudo systemctl enable docker
sudo systemctl start docker

# Add users to docker group
sudo usermod -aG docker ubuntu

if id "jenkins" &>/dev/null; then
    sudo usermod -aG docker jenkins
fi

# Configure Docker daemon
sudo mkdir -p /etc/docker

cat <<EOF | sudo tee /etc/docker/daemon.json
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m",
    "max-file": "3"
  },
  "storage-driver": "overlay2"
}
EOF

# Restart Docker
sudo systemctl restart docker

# Verify installation
echo "========================================"
docker --version
sudo docker version

echo "Docker Service Status:"
sudo systemctl is-active docker

echo "========================================"
echo "Docker installation completed successfully"
echo "========================================"