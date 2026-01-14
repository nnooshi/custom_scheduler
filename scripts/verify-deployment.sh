#!/bin/bash

set -e

echo "📊 Checking deployment status..."

# Ensure we're using the right profile
minikube profile scheduler-test

echo ""
echo "🖥️  Cluster Nodes:"
echo "=================="
kubectl get nodes -o wide

echo ""
echo "📦 Scheduler Pod:"
echo "================="
kubectl get pods -n kube-system -l component=custom-scheduler

echo ""
echo "🎯 Test Pods:"
echo "============"
kubectl get pods -o wide

echo ""
echo "💾 Memory Distribution:"
echo "======================="
echo ""
echo "Pod Memory Requests:"
kubectl get pods -o custom-columns=NAME:.metadata.name,NODE:.spec.nodeName,MEMORY:.spec.containers[0].resources.requests.memory 2>/dev/null || echo "No pods found"

echo ""
echo "Memory per Node:"
for node in $(kubectl get nodes -o jsonpath='{.items[*].metadata.name}'); do
  echo ""
  echo "Node: $node"
  kubectl get pods --field-selector spec.nodeName=$node -o custom-columns=POD:.metadata.name,MEMORY:.spec.containers[0].resources.requests.memory --no-headers 2>/dev/null | awk '{sum+=$2} END {print "  Total: " sum "Mi"}'
done

echo ""
echo "📋 Scheduler Logs (placement decisions):"
echo "========================================="
kubectl logs -n kube-system -l component=custom-scheduler | grep -E "(Assigning|Optimal)" || echo "No scheduling decisions yet"

echo ""
echo "✅ Verification complete!"
