#!/bin/bash
set -e

AWS_ACCESS_KEY_ID=$1
AWS_SECRET_ACCESS_KEY=$2
GITHUB_TOKEN=$3

installArgoCD() {
  kubectl create namespace argocd
  kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
  kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'
  kubectl patch configmap/argocd-cm -n argocd --type merge -p '{"data":{"application.resourceTrackingMethod": "annotation"}}'
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

configureArgoCDApps() {
  kubectl apply -f crossplane/argocd/crossplane-resources-app -n argocd
  kubectl apply -f crossplane/argocd/claims-app -n argocd
}

createTeamsNamespace() {
  kubectl create namespace teams
}

setupCrossplane() {
  installCrossplane
  installAWSProvider
  createSecretAWSCredentials
  configAWSProviderToUseAWSCredentials
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
  createTeamsNamespace
  installArgoCD
  setupCrossplane
  configureArgoCDApps
  showInfo
}

setup
