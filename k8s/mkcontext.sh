. ../ucp/mycloud.rc
set -x
kubectl config set-context system  --cluster=ucp_${CLOUD}-ucp.${DOMAIN}:6443_admin --namespace=kube-system --user=ucp_${CLOUD}-ucp.${DOMAIN}:6443_admin
kubectl config set-context default --cluster=ucp_${CLOUD}-ucp.${DOMAIN}:6443_admin --namespace=default     --user=ucp_${CLOUD}-ucp.${DOMAIN}:6443_admin
kubectl config set-context monitoring --cluster=ucp_${CLOUD}-ucp.${DOMAIN}:6443_admin --namespace=monitoring     --user=ucp_${CLOUD}-ucp.${DOMAIN}:6443_admin
