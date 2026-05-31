#!/bin/bash
# ============================================================
# cleanup.sh
# Phase 12: Clean up ALL AWS resources to avoid charges
# Run this after your demo / project submission
# ============================================================

echo "============================================"
echo " PHASE 12: CLEANUP - Avoiding AWS Charges"
echo "============================================"
echo ""
echo "WARNING: This will delete Kubernetes resources."
echo "Press Ctrl+C in 10 seconds to cancel..."
sleep 10

echo "[1/4] Deleting Kubernetes Service..."
kubectl delete service nodejs-service --ignore-not-found=true

echo "[2/4] Deleting Kubernetes Deployment..."
kubectl delete deployment nodejs-app --ignore-not-found=true

echo "[3/4] Stopping Minikube..."
minikube stop

echo "[4/4] Done with Kubernetes cleanup."
echo ""
echo "============================================"
echo " MANUAL AWS CONSOLE STEPS (do these now):"
echo "============================================"
echo " 1. EC2 Console -> Instances -> Select t2.micro -> Instance State -> TERMINATE"
echo " 2. ECR Console -> Repositories -> nodejs-k8s-app -> DELETE"
echo " 3. EC2 Console -> Key Pairs -> Delete your key pair"
echo " 4. EC2 Console -> Security Groups -> Delete project security group"
echo ""
echo " Verify in AWS Billing Console that no charges are accruing."
echo "============================================"
