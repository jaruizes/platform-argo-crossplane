#!/bin/bash
set -e

TEAM=$1

configureKubectl() {
  aws eks --region eu-west-3 update-kubeconfig --name "$TEAM-cluster"
}

showInfo() {
  ARGOCD_URL=$(kubectl get service products-argo-helm-release-argocd-server -n argocd -o jsonpath='https://{.status.loadBalancer.ingress[0].hostname}:{.spec.ports[0].port}/')
  ARGOCD_PASSWORD=$(kubectl get secret argocd-initial-admin-secret -n argocd --template={{.data.password}} | base64 -D)
  KAFDROP_URL=$(kubectl get service kafdrop -n kafka -o jsonpath='http://{.status.loadBalancer.ingress[0].hostname}:{.spec.ports[0].port}/')

  echo ""
  echo ""
  echo "---------------------------------------"

  echo "ARGOCD URL: $ARGOCD_URL"
  echo "ARGOCD Credentials: admin/$ARGOCD_PASSWORD"
  echo "KAFDROP URL: $KAFDROP_URL"

  echo "---------------------------------------"
  echo ""
  echo ""
}

setup() {
  configureKubectl
  showInfo
}

setup
