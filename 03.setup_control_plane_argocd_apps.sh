#!/bin/bash
set -e

configureArgoCDApps() {
  kubectl apply -f control-plane/argocd/apps/crossplane-resources-app -n argocd
  kubectl apply -f control-plane/argocd/apps/claims-app -n argocd
}

configureKubectl() {
  aws eks --region eu-west-3 update-kubeconfig --name crossplane-poc-cluster
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
  configureArgoCDApps
  showInfo
}

setup
