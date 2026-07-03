#!/bin/bash

set -euo pipefail

echo "========================================"
echo "Installing Git"
echo "========================================"

apt-get update -y

apt-get install -y git

echo "Git Version:"
git --version

echo "Git installation completed."