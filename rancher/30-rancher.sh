helm install rancher rancher-stable/rancher \
  --namespace cattle-system \
  --set hostname=rancher.clh.org

kubectl -n cattle-system rollout status deploy/rancher
