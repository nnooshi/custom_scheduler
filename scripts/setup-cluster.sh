#!/bin/bash

set -e

echo "🚀 Setting up Minikube cluster with 2 nodes..."

# Delete existing cluster if it exists
minikube delete --profile scheduler-test 2>/dev/null || true

# Create new cluster with 2 nodes (2GB memory each)
minikube start \
  --profile scheduler-test \
  --nodes 2 \
  --memory 2048 \
  --cpus 2

echo "✅ Minikube cluster created"

# Switch to the new profile
minikube profile scheduler-test

# Wait for nodes to be ready
echo "⏳ Waiting for nodes to be ready..."
kubectl wait --for=condition=Ready nodes --all --timeout=120s

# Display node information
echo ""
echo "📊 Node Information:"
kubectl get nodes -o wide

echo ""
echo "🎉 Cluster setup complete!"
echo ""
echo "Next steps:"
echo "  1. Run: ./scripts/deploy-scheduler.sh"
echo "  2. Run: ./scripts/deploy-pods.sh"
echo "  3. Run: ./scripts/verify-deployment.sh"
