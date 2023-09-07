#!/bin/bash

# Define the log file path
LOG_FILE="init.log"

echo "Beginning the installation of ArgoCD into the cluster"

# Function to log messages to the log file
function log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') $1" >> "$LOG_FILE"
}

# Function to check if a resource exists
function resource_exists() {
    local resource_type="$1"
    local resource_name="$2"
    kubectl get "$resource_type" "$resource_name" >/dev/null 2>&1
}

# Create namespace for Argo CD
if ! resource_exists namespace argocd; then
    log "Creating namespace argocd..."
    kubectl create namespace argocd >> "$LOG_FILE" 2>&1
    log "Namespace argocd created."
fi

# Install Argo CD
if ! resource_exists pod argocd-server -n argocd; then
    log "Installing Argo CD..."
    kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml >> "$LOG_FILE" 2>&1

    # Wait for the argocd-server pod to be in a "Running" state
    log "Waiting for Argo CD server to be ready..."
    while [[ "$(kubectl get pod -n argocd -l app.kubernetes.io/name=argocd-server -o 'jsonpath={..status.conditions[?(@.type=="Ready")].status}')" != "True" ]]; do
        sleep 5
    done
    log "Argo CD server is now ready."
fi

# Create namespace for Webservice
if ! resource_exists namespace webservice; then
    log "Creating namespace webservice..."
    kubectl create namespace webservice >> "$LOG_FILE" 2>&1
    log "Namespace webservice created."
fi

# Didn't want to waste time setting setup ingress so i converted the ClusterIP to Loadbalancer
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'

ARGOCD_ADMIN_PASSWORD=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)

argocd login --insecure --grpc-web k3s_master:32761 --username admin --password $ARGOCD_ADMIN_PASSWORD


sleep 10 // just sleep for some seconds

ARGOCD_SERVER=$(kubectl get services --namespace argocd argocd-server --output jsonpath='{.status.loadBalancer.ingress[0].ip}')

echo "Argocd Url : $ARGOCD_SERVER" >> argocd-credentials.txt
echo "Argocd Username : admin" >>  argocd-credentials.txt
echo "Argocd Password : $ARGOCD_ADMIN_PASSWORD" >> argocd-credentials.txt
echo "Argocd Url : " >> argocd-credentials.txt >> argocd-credentials.txt

echo "ArgoCD successfully installed"
echo "ArgoCD is running on $ARGOCD_SERVER"
echo "ArgoCD username is admin and password is $ARGOCD_ADMIN_PASSWORD"
echo "Created ArgoCD and webservice namespaces"

