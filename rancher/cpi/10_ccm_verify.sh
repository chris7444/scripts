kubectl describe CSINode
kubectl get pods --namespace=kube-system -o wide
kubectl describe nodes | grep ProviderID
kubectl describe nodes | egrep "Taints:|Name:"
