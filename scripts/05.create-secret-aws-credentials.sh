echo "[default]
aws_access_key_id = $1
aws_secret_access_key = $2
" >aws-creds.conf

kubectl create secret generic aws-secret -n crossplane-system --from-file creds=./aws-creds.conf
#rm aws-creds.conf
