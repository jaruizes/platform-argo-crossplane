kubectl create namespace crossplane-test
kubectl apply -f crossplane/aws-resources/s3/bucket.yaml -n crossplane-test
