#!/bin/bash
# 1. Create Cluster (3-node k3d)
k3d cluster create assignment-cluster --servers 1 --agents 2 --port "8080:80@loadbalancer"

# 2. Install Argo CD
kubectl create namespace argocd
kubectl label namespace argocd project=assignment --overwrite
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# 3. Bootstrap the Root Application
kubectl apply -f root-app.yaml

echo "Waiting for Argo CD to initialize..."
sleep 30

# 4. Install Argo Workflows
kubectl create namespace argo
kubectl label namespace argo project=assignment --overwrite
kubectl apply -n argo -f https://github.com/argoproj/argo-workflows/releases/download/v3.5.5/install.yaml

echo "Stack is bootstrapping. Check Argo CD UI to monitor progress."
