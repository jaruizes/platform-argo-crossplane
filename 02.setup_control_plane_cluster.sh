#!/bin/bash
set -e

AWS_ACCESS_KEY_ID=$1
AWS_SECRET_ACCESS_KEY=$2
GIT_TOKEN=$3

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
  sleep 120
}

installProviders() {
  kubectl apply -f control-plane/crossplane/providers/aws-provider.yaml -n crossplane-system
  sleep 10
  kubectl apply -f control-plane/crossplane/providers/k8s-provider.yaml -n crossplane-system
  sleep 10
  kubectl apply -f control-plane/crossplane/providers/helm-provider.yaml -n crossplane-system
  sleep 10
  kubectl apply -f control-plane/crossplane/providers/github-provider.yaml -n crossplane-system
  kubectl create secret generic github-credentials --from-literal=token="$GIT_TOKEN" --from-literal=credentials='{"owner": "jaruizes", "token": "'"$GIT_TOKEN"'"}' -n crossplane-system
  sleep 300
}

createSecretAWSCredentials() {
  CREDS="[default]
  aws_access_key_id = $AWS_ACCESS_KEY_ID
  aws_secret_access_key = $AWS_SECRET_ACCESS_KEY
  "

  kubectl create secret generic aws-secret -n crossplane-system --from-literal creds="$CREDS"
}

configAWSProviderToUseAWSCredentials() {
  kubectl apply -f control-plane/crossplane/providers/aws-provider-config.yaml -n crossplane-system
}

configureArgoCDApps() {
  kubectl apply -f argocd/apps/manager/crossplane-resources-app -n argocd
  kubectl apply -f argocd/apps/manager/claims-app -n argocd
}

createTeamsNamespace() {
  kubectl create namespace teams
}

setupGitProvider() {
  kubectl create secret generic gitlab-credentials -n crossplane-system --from-literal=token="$GIT_TOKEN"
  kubectl apply -f crossplane/providers/gitlab-provider.yaml -n crossplane-system
#  sleep 120
#  kubectl apply -f crossplane/providers/gitlab-provider-config.yaml -n crossplane-system | true
#  sleep 30
}

configureK8sProviderSA() {
  SA=$(kubectl -n crossplane-system get sa -o name | grep provider-kubernetes | sed -e 's|serviceaccount\/|crossplane-system:|g')
  kubectl create clusterrolebinding provider-kubernetes-admin-binding --clusterrole cluster-admin --serviceaccount="${SA}"
}

configureKubectl() {
  aws eks --region eu-west-3 update-kubeconfig --name crossplane-poc-cluster
}

configureAWSProvider() {
  createSecretAWSCredentials
  configAWSProviderToUseAWSCredentials
}

setupCrossplane() {
  installCrossplane
  installProviders
  configureAWSProvider
}

installBackstage() {
  kubectl create namespace backstage
  kubectl create secret generic backstage-secrets --from-literal=GITHUB_TOKEN="$GIT_TOKEN" -n backstage
  kubectl apply -f control-plane/backstage/backstage.yaml -n backstage
}

showInfo() {
  ARGOCD_URL=$(kubectl get service argocd-server -n argocd -o jsonpath='https://{.status.loadBalancer.ingress[0].hostname}:{.spec.ports[0].port}/')
  ARGOCD_PASSWORD=$(kubectl get secret argocd-initial-admin-secret -n argocd --template={{.data.password}} | base64 -D)
  BACKSTAGE_URL=$(kubectl get service backstage -n backstage -o jsonpath='http://{.status.loadBalancer.ingress[0].hostname}:{.spec.ports[0].port}/')

  echo ""
  echo ""
  echo "---------------------------------------"

  echo "ARGOCD URL: $ARGOCD_URL"
  echo "ARGOCD Credentials: admin/$ARGOCD_PASSWORD"
  echo "BACKSTAGE URL: $BACKSTAGE_URL"

  echo "---------------------------------------"
  echo ""
  echo ""
}

setup() {
  configureKubectl
  createTeamsNamespace
  installBackstage
  installArgoCD
  setupCrossplane
  configureK8sProviderSA
  showInfo
}

setup
