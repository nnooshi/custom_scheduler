#!/bin/bash

set -e

echo "🚀 Deploying test pods in sequence..."

# Make sure we're using the right profile
minikube profile scheduler-test

echo ""
echo "📦 Deploying pod1 (600Mi memory request)..."
kubectl apply -f "Task Files/pods_engineer_task_1.yaml"
echo "Waiting for pod1 to be scheduled..."
sleep 3

echo ""
echo "📦 Deploying pod2 (800Mi memory request)..."
kubectl apply -f "Task Files/pods_engineer_task_2.yaml"
echo "Waiting for pod2 to be scheduled..."
sleep 3

echo ""
echo "📦 Deploying pod3 (600Mi memory request)..."
kubectl apply -f "Task Files/pods_engineer_task_3.yaml"
echo "Waiting for pod3 to be scheduled..."
sleep 3

echo ""
echo "🎉 All pods deployed!"
echo ""
echo "📊 Pod distribution across nodes:"
kubectl get pods -o wide

echo ""
echo "💾 Memory per pod:"
kubectl get pods -o=jsonpath='{range .items[*]}{.metadata.name}{"\t"}{.spec.containers[0].resources.requests.memory}{"\n"}{end}'

echo ""
echo "📋 Scheduler Decision Logs:"
echo "============================"
kubectl logs -n kube-system -l component=custom-scheduler | grep -E "Assigning|Optimal"
