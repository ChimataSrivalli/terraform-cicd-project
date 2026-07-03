#!/bin/bash

set -euo pipefail

echo "========================================"
echo "Installing OpenJDK 21"
echo "========================================"

# Update package index
apt-get update -y

# Install Java 21
apt-get install -y openjdk-21-jdk

# Verify Java installation
echo "========================================"
echo "Java Version"
echo "========================================"

java -version

echo "========================================"
echo "JAVA_HOME"
echo "========================================"

JAVA_HOME=$(dirname $(dirname $(readlink -f $(which java))))
echo "JAVA_HOME=${JAVA_HOME}"

echo "========================================"
echo "OpenJDK 21 installation completed."
echo "========================================"