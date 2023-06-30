kubectl patch configmap/argocd-cm -n argocd --type merge -p '{"data":{"accounts.provider-argocd":"apiKey"}}'
kubectl patch configmap/argocd-rbac-cm -n argocd --type merge -p '{"data":{"policy.csv":"g, provider-argocd, role:admin"}}'


ARGOCD_ADMIN_SECRET=$(kubectl get secret argocd-initial-admin-secret -n argocd --template={{.data.password}} | base64 -D)
ARGOCD_URL=$(kubectl get service argocd-server -n argocd -o jsonpath='https://{.status.loadBalancer.ingress[0].hostname}:{.spec.ports[0].port}/')
ARGOCD_ADMIN_TOKEN=$(curl -s -X POST -k -H "Content-Type: application/json" --data-binary '{"username":"admin","password":"'"$ARGOCD_ADMIN_SECRET"'"}' "$ARGOCD_URL"api/v1/session | jq -r .token)
ARGOCD_TOKEN=$(curl -s -X POST -k -H "Authorization: Bearer $ARGOCD_ADMIN_TOKEN" -H "Content-Type: application/json" "$ARGOCD_URL"api/v1/account/provider-argocd/token | jq -r .token)
echo "ARGOCD_ADMIN_SECRET = $ARGOCD_ADMIN_SECRET"
echo "ARGOCD_URL = $ARGOCD_URL"
echo "ARGOCD_ADMIN_TOKEN = $ARGOCD_ADMIN_TOKEN"
echo "ARGOCD_TOKEN = $ARGOCD_TOKEN"


kubectl create secret generic argocd-credentials -n crossplane-system --from-literal=authToken="$ARGOCD_TOKEN"
kubectl apply -f crossplane/providers/argocd-provider.yaml
kubectl apply -f crossplane/providers/argocd-provider-config.yaml
