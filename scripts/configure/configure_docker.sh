#!/bin/bash

set -euo pipefail

echo "========================================"
echo "Configuring Docker"
echo "========================================"

####################################################
# Enable Docker
####################################################

sudo systemctl enable docker
sudo systemctl start docker

####################################################
# Add Users to Docker Group
####################################################

sudo usermod -aG docker ubuntu

if id "jenkins" &>/dev/null; then
    sudo usermod -aG docker jenkins
fi

####################################################
# Configure Docker Daemon
####################################################

sudo mkdir -p /etc/docker

cat <<EOF | sudo tee /etc/docker/daemon.json
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "storage-driver": "overlay2",
  "log-driver": "json-file",
  "log-opts": {
      "max-size":"10m",
      "max-file":"3"
  }
}
EOF

####################################################
# Restart Docker
####################################################

sudo systemctl restart docker

####################################################
# Verify
####################################################

docker --version
sudo docker info

echo "========================================"
echo "Docker configured successfully"
echo "========================================"