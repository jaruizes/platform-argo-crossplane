#!/bin/bash
set -e

AWS_ACCESS_KEY_ID=$1
AWS_SECRET_ACCESS_KEY=$2
GITHUB_TOKEN=$3

installArgoCD() {
  kubectl create namespace argocd
  kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
  kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'
}

installCrossplane() {
  helm repo add crossplane-stable https://charts.crossplane.io/stable
  helm repo update
  helm install crossplane crossplane-stable/crossplane --namespace crossplane-system --create-namespace
  sleep 30
}

installAWSProvider() {
  kubectl apply -f crossplane/providers/aws-provider.yaml -n crossplane-system
  sleep 60
}

createSecretAWSCredentials() {
  echo "[default]
  aws_access_key_id = $AWS_ACCESS_KEY_ID
  aws_secret_access_key = $AWS_SECRET_ACCESS_KEY
  " >aws-creds.conf

  kubectl create secret generic aws-secret -n crossplane-system --from-file creds=./aws-creds.conf
  rm aws-creds.conf
}

configAWSProviderToUseAWSCredentials() {
  kubectl apply -f crossplane/providers/aws-provider-config.yaml -n crossplane-system
}

configArgoCDProvider() {
  kubectl patch configmap/argocd-cm -n argocd --type merge -p '{"data":{"accounts.provider-argocd":"apiKey", "application.resourceTrackingMethod": "annotation"}}'
  kubectl patch configmap/argocd-rbac-cm -n argocd --type merge -p '{"data":{"policy.csv":"g, provider-argocd, role:admin"}}'

  ARGOCD_ADMIN_SECRET=$(kubectl get secret argocd-initial-admin-secret -n argocd --template={{.data.password}} | base64 -D)
  ARGOCD_URL=$(kubectl get service argocd-server -n argocd -o jsonpath='https://{.status.loadBalancer.ingress[0].hostname}:{.spec.ports[0].port}/')
  ARGOCD_ADMIN_TOKEN=$(curl -s -X POST -k -H "Content-Type: application/json" --data-binary '{"username":"admin","password":"'"$ARGOCD_ADMIN_SECRET"'"}' "$ARGOCD_URL"api/v1/session | jq -r .token)
  ARGOCD_TOKEN=$(curl -s -X POST -k -H "Authorization: Bearer $ARGOCD_ADMIN_TOKEN" -H "Content-Type: application/json" "$ARGOCD_URL"api/v1/account/provider-argocd/token | jq -r .token)
#  echo "ARGOCD_ADMIN_SECRET = $ARGOCD_ADMIN_SECRET"
#  echo "ARGOCD_URL = $ARGOCD_URL"
#  echo "ARGOCD_ADMIN_TOKEN = $ARGOCD_ADMIN_TOKEN"
#  echo "ARGOCD_TOKEN = $ARGOCD_TOKEN"

  kubectl create secret generic argocd-credentials -n crossplane-system --from-literal=authToken="$ARGOCD_TOKEN"
  kubectl apply -f crossplane/providers/argocd-provider.yaml -n crossplane-system
  sleep 60
  kubectl apply -f crossplane/providers/argocd-provider-config.yaml -n crossplane-system
}

configureArgoCDRepositoryAndProject() {
  kubectl apply -f crossplane/argocd/claims-repository.yaml -n crossplane-system
  kubectl apply -f crossplane/argocd/claims-application.yaml -n argocd
}

createTeamsNamespace() {
  kubectl create namespace k8s-teams
}

setupCrossplane() {
  installCrossplane
  installAWSProvider
  createSecretAWSCredentials
  configAWSProviderToUseAWSCredentials
  configArgoCDProvider
}

showInfo() {
  ARGOCD_URL=$(kubectl get service argocd-server -n argocd -o jsonpath='https://{.status.loadBalancer.ingress[0].hostname}:{.spec.ports[0].port}/')
  ARGOCD_PASSWORD=$(kubectl get secret argocd-initial-admin-secret -n argocd --template={{.data.password}} | base64 -D)

  echo ""
  echo ""
  echo "---------------------------------------"

  echo "ARGOCD URL: $ARGOCD_URL"
  echo "ARGOCD Credentials: admin/$ARGOCD_PASSWORD"

  echo "---------------------------------------"
  echo ""
  echo ""
}

setup() {
  installArgoCD
  setupCrossplane
  configureArgoCDRepositoryAndProject
  createTeamsNamespace
  showInfo
}

setup
