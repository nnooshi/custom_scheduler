#!/bin/bash

set -e

echo "🔨 Building and deploying custom scheduler..."

# Ensure we're using the right profile
minikube profile scheduler-test

# Copy scheduler.py to build directory
cp "Task Files/scheduler.py" .

# Build Docker image
echo "Building Docker image..."
docker build -t custom-scheduler:latest .

# Load image into minikube
echo "📦 Loading image into Minikube..."
minikube image load custom-scheduler:latest

# Deploy RBAC and scheduler
echo "🚀 Deploying scheduler to cluster..."
kubectl apply -f scheduler-rbac.yaml
kubectl apply -f scheduler-deployment.yaml

# Wait for scheduler to be ready
echo "⏳ Waiting for scheduler pod to be ready..."
kubectl wait --for=condition=Ready pod -l component=custom-scheduler -n kube-system --timeout=120s

echo ""
echo "✅ Scheduler deployed successfully!"
echo ""
echo "📋 Scheduler pod status:"
kubectl get pods -n kube-system -l component=custom-scheduler

echo ""
echo "📊 Initial scheduler logs:"
kubectl logs -n kube-system -l component=custom-scheduler --tail=20

# Clean up copied file
rm scheduler.py

echo ""
echo "Ready to deploy pods! Run: ./scripts/deploy-pods.sh"
