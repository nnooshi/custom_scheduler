#!/bin/bash

set -e

echo "🧹 Cleaning up test pods..."

# Make sure we're using the right profile
minikube profile scheduler-test

# Delete the test pods
kubectl delete pod pod1 pod2 pod3 --ignore-not-found=true

echo "✅ Pods cleaned up!"
echo ""
echo "You can now redeploy by running:"
echo "  ./scripts/deploy-pods.sh"
