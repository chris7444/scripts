rke up --config ./rancher-cluster.yml
mv kube_config_rancher-cluster.yml ~/.rancher/kubeconfig
export KUBECONFIG=~/.rancher/kubeconfig
kubectl get nodes -o wide

