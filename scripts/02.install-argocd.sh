kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'
sleep 5
PASS=$(kubectl get secret argocd-initial-admin-secret -n argocd --template={{.data.password}} | base64 -D)

echo ""
echo "---- Argo deployed ----"
echo "- Credentials: admin/$PASS"



