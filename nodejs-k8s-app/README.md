# Node.js Kubernetes Demo
### University Cloud Computing Project — AWS EC2 + Docker + Minikube

---

## Project Overview

A Node.js web application containerised with Docker and deployed on a single-node Kubernetes cluster (Minikube) running on an AWS EC2 t2.micro instance (Free Tier).

## Tech Stack

| Layer | Technology |
|---|---|
| Application | Node.js 18 + Express.js |
| Containerisation | Docker |
| Registry | Amazon ECR |
| Orchestration | Kubernetes (Minikube) |
| Infrastructure | AWS EC2 t2.micro (Free Tier) |
| Source Control | GitHub |

## Application Features

- Real-time ISO 8601 timestamp on every request
- Container / Pod hostname (proves containerisation)
- Visitor counter (resets on pod restart)
- `/health` endpoint for Kubernetes liveness & readiness probes
- Responsive dark-themed UI

## Project Structure

```
nodejs-k8s-app/
├── app.js            Main Express application
├── package.json      Node.js dependencies and scripts
├── Dockerfile        Container image build instructions
├── deployment.yaml   Kubernetes Deployment (2 replicas)
├── service.yaml      Kubernetes NodePort Service (:30080)
└── README.md         This file
```

## Quick Start (Local)

```bash
# Install dependencies
npm install

# Start the app
npm start

# Visit in browser
open http://localhost:3000
open http://localhost:3000/health
```

## Docker Commands

```bash
# Build image
docker build -t nodejs-k8s-app .

# Run container locally
docker run -p 3000:3000 nodejs-k8s-app

# Test
curl http://localhost:3000/health
```

## AWS ECR Commands

```bash
# Authenticate Docker to ECR (replace values)
aws ecr get-login-password --region us-east-1 | \
  docker login --username AWS \
  --password-stdin <ACCOUNT_ID>.dkr.ecr.us-east-1.amazonaws.com

# Tag image
docker tag nodejs-k8s-app:latest \
  <ACCOUNT_ID>.dkr.ecr.us-east-1.amazonaws.com/nodejs-k8s-app:latest

# Push to ECR
docker push <ACCOUNT_ID>.dkr.ecr.us-east-1.amazonaws.com/nodejs-k8s-app:latest
```

## Kubernetes Commands

```bash
# Deploy to Minikube
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml

# Check status
kubectl get pods
kubectl get services

# View logs
kubectl logs -l app=nodejs-app

# Scale up to 4 replicas (scaling demo)
kubectl scale deployment nodejs-app --replicas=4

# Access app (Minikube)
minikube service nodejs-service --url
```

## EC2 Setup Commands

```bash
# Install Docker
sudo yum update -y
sudo yum install -y docker
sudo systemctl start docker
sudo usermod -aG docker ec2-user

# Install kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# Install Minikube
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube

# Start Minikube (low memory for t2.micro)
minikube start --driver=docker --memory=700 --cpus=1
```

## Access the App

After deployment, access at:
```
http://<EC2_PUBLIC_IP>:30080
```

Make sure EC2 Security Group allows **inbound TCP port 30080**.

## Cost Warning

All resources use AWS Free Tier:
- EC2 t2.micro: 750 hrs/month free (first 12 months)
- ECR: 500 MB storage free
- **ALWAYS run Phase 12 cleanup after the demo to avoid charges**

## Author

- Name: [Zahid Bashir]
- Student ID: [55428]
- University: [Riphah international university]
- Course: Cloud Computing 
- Year: 2026
