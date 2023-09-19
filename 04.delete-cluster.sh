rm -rf backstage-repository/catalog/generated
git commit -m "Delete files generated during the demo"
git push .
eksctl delete cluster -f cluster-conf.yaml --disable-nodegroup-eviction
