#!/bin/bash
# ============================================================
# deploy-to-k8s.sh
# Run on EC2 after Minikube is running.
# Phases 8 & 9: Deploy app and expose via NodePort
# Usage: ./deploy-to-k8s.sh <ECR_IMAGE_URL>
# ============================================================

set -e
ECR_IMAGE=${1:-"YOUR_ECR_IMAGE_URL:latest"}

echo "============================================"
echo " Deploying Node.js App to Kubernetes"
echo " Image: $ECR_IMAGE"
echo "============================================"

# Update deployment.yaml with actual ECR image URL
sed -i "s|YOUR_ECR_IMAGE_URL:latest|${ECR_IMAGE}|g" deployment.yaml

# Apply Kubernetes manifests
echo "[1/4] Applying Deployment..."
kubectl apply -f deployment.yaml

echo "[2/4] Applying Service..."
kubectl apply -f service.yaml

echo "[3/4] Waiting for pods to be ready (up to 120s)..."
kubectl rollout status deployment/nodejs-app --timeout=120s

echo "[4/4] Deployment complete! Status:"
echo ""
kubectl get pods -o wide
echo ""
kubectl get services
echo ""

# Get EC2 Public IP
EC2_IP=$(curl -s --max-time 3 http://169.254.169.254/latest/meta-data/public-ipv4 2>/dev/null || echo "YOUR_EC2_IP")

echo "============================================"
echo " App is running! Access it at:"
echo " http://${EC2_IP}:30080"
echo " http://${EC2_IP}:30080/health"
echo ""
echo " REMINDER: Make sure EC2 Security Group"
echo " allows inbound TCP port 30080!"
echo "============================================"
