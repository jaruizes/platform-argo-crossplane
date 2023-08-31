aws --profile=paradigma ecr get-login-password --region eu-west-3 | docker login --username AWS --password-stdin 043264546031.dkr.ecr.eu-west-3.amazonaws.com
aws --profile=paradigma ecr create-repository --repository-name backstage-devex-poc --image-scanning-configuration scanOnPush=false --region eu-west-3
docker tag backstage:1.0.0 043264546031.dkr.ecr.eu-west-3.amazonaws.com/backstage-devex-poc:1.0.0
docker push 043264546031.dkr.ecr.eu-west-3.amazonaws.com/backstage-devex-poc:1.0.0
