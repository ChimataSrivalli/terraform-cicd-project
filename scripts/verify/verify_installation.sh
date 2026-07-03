#!/bin/bash

set -euo pipefail

echo "========================================"
echo "DevOps Environment Verification"
echo "========================================"

PASS=0
FAIL=0

check() {
    NAME="$1"
    COMMAND="$2"

    echo -n "Checking ${NAME} ... "

    if eval "$COMMAND" >/dev/null 2>&1; then
        echo "PASS"
        PASS=$((PASS+1))
    else
        echo "FAIL"
        FAIL=$((FAIL+1))
    fi
}

####################################################
# Installed Software
####################################################

check "Git" "command -v git"
check "Java" "command -v java"
check "Docker" "command -v docker"
check "Jenkins" "command -v jenkins"
check "kubectl" "command -v kubectl"
check "Minikube" "command -v minikube"
check "Helm" "command -v helm"

####################################################
# Services
####################################################

check "Docker Service" "systemctl is-active --quiet docker"
check "Jenkins Service" "systemctl is-active --quiet jenkins"

####################################################
# Kubernetes
####################################################

check "Minikube Running" "minikube status | grep -q 'Running'"
check "Kubernetes API" "kubectl cluster-info"
check "Kubernetes Nodes" "kubectl get nodes"

####################################################
# Summary
####################################################

echo
echo "========================================"
echo "Verification Summary"
echo "========================================"

echo "Passed : $PASS"
echo "Failed : $FAIL"

if [ "$FAIL" -eq 0 ]; then
    echo
    echo "All components are installed and working."
    exit 0
else
    echo
    echo "Some components failed verification."
    exit 1
fi
