yarn build:backend --config ../../app-config.yaml
docker image build . -f packages/backend/Dockerfile --tag backstage:1.0.0
sh publish_ecr.sh
