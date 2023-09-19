git pull .

rm -rf backstage-repository/catalog/generated
git commit -a -m "Deleted files generated during the demo"
git push origin main

sleep 10

echo "Removing claims associated to platform tools and CI/CD...."
rm -rf platform-gitops-repositories/claims/products/platform-tools
rm -rf platform-gitops-repositories/claims/products/platform-cicd
git commit -a -m "Deleted tools and cicd claims"
git push origin main
sleep 360

echo "Removing claims associated to platform base...."
rm -rf platform-gitops-repositories/claims/products
git commit -a -m "Deleted platform claim"
git push origin main
sleep 900


eksctl delete cluster -f cluster-conf.yaml --disable-nodegroup-eviction
