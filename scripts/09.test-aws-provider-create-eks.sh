kubectl create namespace crossplane-test
kubectl apply -f crossplane/aws-resources/eks/eks.yaml -n crossplane-test
kubectl get clusters.eks.aws.upbound.io -n crossplane-test
