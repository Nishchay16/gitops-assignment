# SRE Technical Challenge: GitOps Infrastructure

## 1. High-Level Architecture
This project implements a production-grade Kubernetes stack using **k3s**. 

* **GitOps:** Argo CD manages the cluster state via the App-of-Apps pattern.
* **Automation:** Argo Workflows executes post-deployment connectivity tests.
* **Security:** OPA Gatekeeper enforces mandatory project labels and CPU resource limits.
* **Messaging:** NATS provides asynchronous communication between the UI and HTTP services.
* **Storage:** MinIO simulates a CSI driver for block/object storage.

## 2. MinIO CSI Integration
In this local k3s environment, **MinIO** is deployed as a high-availability storage layer. It provides S3-compatible object storage to the application suite, simulating a Cloud Storage Interface (CSI) to ensure data persistence for distributed services.

## 3. Verification Instructions

### OPA Enforcement
Try to deploy a pod without a CPU limit; Gatekeeper will block it:
`kubectl run nginx --image=nginx -n app-system`

### RBAC Restrictions
Verify the Developer Role cannot access the 'kube-system' namespace:
`kubectl get pods -n kube-system --as=developer-user`

### Sanity Check (Argo Workflows)
Check the result of the post-deployment NATS connectivity test:
`kubectl get workflow nats-connectivity-check -n app-system`

### External Access
The WebSocket service is exposed via Traefik Ingress:
`http://localhost:8080/ws`
