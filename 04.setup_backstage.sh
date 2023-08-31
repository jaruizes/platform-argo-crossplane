#!/bin/bash
set -e

GIT_TOKEN=$1

createNamespace() {
  kubectl create namespace backstage
}
createSecret() {
  kubectl create secret generic backstage-secrets --from-literal=GITHUB_TOKEN="$GIT_TOKEN" -n backstage
}

configureKubectl() {
  aws eks --region eu-west-3 update-kubeconfig --name crossplane-poc-cluster
}

deployBackstage() {
  kubectl apply -f control-plane/backstage/backstage.yaml -n backstage
  sleep 120
}

showInfo() {
  ARGOCD_URL=$(kubectl get service argocd-server -n argocd -o jsonpath='https://{.status.loadBalancer.ingress[0].hostname}:{.spec.ports[0].port}/')
  ARGOCD_PASSWORD=$(kubectl get secret argocd-initial-admin-secret -n argocd --template={{.data.password}} | base64 -D)
  BACKSTAGE_URL=$(kubectl get service backstage -n backstage -o jsonpath='https://{.status.loadBalancer.ingress[0].hostname}:{.spec.ports[0].port}/')

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
#  configureKubectl
#  createNamespace
#  createSecret
  deployBackstage
  showInfo
}

setup
