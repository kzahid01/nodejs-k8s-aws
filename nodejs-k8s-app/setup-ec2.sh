#!/bin/bash
# ============================================================
# setup-ec2.sh
# Run this script on your EC2 t2.micro instance after launch.
# Phases 6 & 7: Install Docker, kubectl, Minikube
# Usage: chmod +x setup-ec2.sh && ./setup-ec2.sh
# ============================================================

set -e  # Exit immediately if any command fails
echo "============================================"
echo " EC2 Setup: Docker + kubectl + Minikube"
echo "============================================"

# ── 1. Update system packages ────────────────────────────────
echo "[1/7] Updating system packages..."
sudo yum update -y

# ── 2. Install Docker ────────────────────────────────────────
echo "[2/7] Installing Docker..."
sudo yum install -y docker
sudo systemctl start docker
sudo systemctl enable docker        # auto-start on reboot
sudo usermod -aG docker ec2-user    # run docker without sudo
echo "Docker installed: $(docker --version)"

# ── 3. Install kubectl ───────────────────────────────────────
echo "[3/7] Installing kubectl..."
KUBECTL_VERSION=$(curl -L -s https://dl.k8s.io/release/stable.txt)
curl -LO "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
rm kubectl
echo "kubectl installed: $(kubectl version --client --short 2>/dev/null || kubectl version --client)"

# ── 4. Install Minikube ──────────────────────────────────────
echo "[4/7] Installing Minikube..."
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube
rm minikube-linux-amd64
echo "Minikube installed: $(minikube version)"

# ── 5. Install AWS CLI v2 ────────────────────────────────────
echo "[5/7] Installing AWS CLI..."
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
sudo yum install -y unzip
unzip -q awscliv2.zip
sudo ./aws/install
rm -rf awscliv2.zip aws/
echo "AWS CLI installed: $(aws --version)"

# ── 6. Apply Docker group change ─────────────────────────────
echo "[6/7] Applying Docker group membership..."
echo "NOTE: You must log out and log back in for docker group to take effect."
echo "After re-login, run: newgrp docker"

# ── 7. Start Minikube ────────────────────────────────────────
echo "[7/7] Starting Minikube (low memory mode for t2.micro)..."
echo "NOTE: Run this AFTER logging back in (so docker group is active):"
echo ""
echo "  minikube start --driver=docker --memory=700 --cpus=1 --disk-size=5g"
echo ""
echo "============================================"
echo " Setup complete! Next steps:"
echo " 1. Log out: exit"
echo " 2. SSH back in to EC2"
echo " 3. Run: minikube start --driver=docker --memory=700 --cpus=1"
echo " 4. Run: kubectl get nodes"
echo "============================================"
