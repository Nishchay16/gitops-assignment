# GitOps Assignment: Kubernetes & Argo CD

This repository contains a complete GitOps implementation for a microservices stack using **Argo CD**, **Gatekeeper (OPA)**, and **MetalLB**. It follows the **App-of-Apps pattern** to manage infrastructure and application manifests from a single root application.

##  Architecture
- **Root Application:** root-app.yaml (Manages the lifecycle of all sub-applications).
- **App-of-Apps Pattern:** Located in apps/, defining individual sync policies for MinIO, NATS, and OPA.
- **Base Manifests:** Located in base/, containing the core K8s resources, RBAC, and Policies.

##  Key Technical Features

### 1. Automated Policy Enforcement (OPA/Gatekeeper)
Implemented **Policy-as-Code** to ensure cluster security.
- **ConstraintTemplate:** Defines a Rego policy requiring CPU limits on all Pods and Deployments.
- **Constraint:** Enforces the policy across the app-system namespace.
- **Race Condition Resolution:** Used **Argo CD Sync Waves** (Wave 0 for Templates, Wave 5 for Constraints) to ensure the Kubernetes API registers CRDs before resources are applied.

### 2. Networking & Load Balancing
- **MetalLB:** Configured for Layer 2 load balancing to provide external IPs to the cluster.
- **Ingress Controller:** NGINX Ingress managed via GitOps to route traffic to internal services (ws-service, ui-service, http-service).

### 3. Automated Sanity Checks
- **Argo Workflows:** Includes a sanity-workflow.yaml that automatically triggers a NATS connectivity check upon deployment to verify the messaging layer is functional.

##  Deployment & Sync Instructions

1. **Bootstrap the Cluster:**
   kubectl apply -f root-app.yaml

2. **Force Manual Refresh:**
   kubectl annotate application assignment-root -n argocd argocd.argoproj.io/refresh=hard --overwrite

##  Validation Tests

### OPA Policy Test (Negative)
To verify that the CPU limit policy is active, run a pod without limits:
kubectl run opa-test --image=nginx -n app-system
# Expected Output: Error from server (Forbidden)... has no CPU limit

### Connectivity Test
Check the status of the automated sanity check:
kubectl get workflow -n app-system

##  Project Structure
- /apps: Argo CD Application manifests.
- /base: Base Kubernetes resources (Services, Deployments, RBAC).
- /overlays: Environment-specific patches.
- init.sh: Bootstrap script for cluster initialization.
