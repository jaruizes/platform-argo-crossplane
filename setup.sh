#!/bin/bash
set -e

AWS_ACCESS_KEY_ID=$1
AWS_SECRET_ACCESS_KEY=$2
GITLAB_TOKEN=$3

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
  sleep 90
}

createSecretAWSCredentials() {
  CREDS="[default]
  aws_access_key_id = $AWS_ACCESS_KEY_ID
  aws_secret_access_key = $AWS_SECRET_ACCESS_KEY
  "

  kubectl create secret generic aws-secret -n crossplane-system --from-literal creds="$CREDS"
}

configAWSProviderToUseAWSCredentials() {
  kubectl apply -f crossplane/providers/aws-provider-config.yaml -n crossplane-system
}

configureArgoCDApps() {
  kubectl apply -f argocd/apps/manager/crossplane-resources-app -n argocd
  kubectl apply -f argocd/apps/manager/claims-app -n argocd
}

createTeamsNamespace() {
  kubectl create namespace teams
}

setupGitlabProvider() {
  kubectl create secret generic gitlab-credentials -n crossplane-system --from-literal=token="$GITLAB_TOKEN"
  kubectl apply -f crossplane/providers/gitlab-provider.yaml -n crossplane-system
  sleep 60
  kubectl apply -f crossplane/providers/gitlab-provider-config.yaml -n crossplane-system
  sleep 10
}

installHelmAndK8sProviders() {
  kubectl apply -f crossplane/providers/helm-provider.yaml -n crossplane-system
  sleep 60
  kubectl apply -f crossplane/providers/k8s-provider.yaml -n crossplane-system
  sleep 30
}

configureKubectl() {
  aws eks --region eu-west-3 update-kubeconfig --name crossplane-poc-cluster
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
  configureKubectl
  createTeamsNamespace
  installArgoCD
  setupCrossplane
  configureArgoCDApps
#  setupGitlabProvider
  installHelmAndK8sProviders
  showInfo
}

setup
