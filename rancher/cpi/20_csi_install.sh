cat >/tmp/csi-vsphere.conf <<EOF
[Global]
cluster-id = "ClusterClh2964"
[VirtualCenter "vcentergen9.am2.cloudra.local"]
insecure-flag = "true"
user = "Administrator@vsphere.local"
password = "Just4m\$hpe20!9"
port = "443"
datacenters = "DEVOPS"
EOF


kubectl delete secret vsphere-config-secret -n kube-system
kubectl create secret generic vsphere-config-secret --from-file=/tmp/csi-vsphere.conf --namespace=kube-system


kubectl apply -f csi/csi-driver-rbac.yaml
kubectl apply -f csi/vsphere-csi-controller-ss.yaml
kubectl apply -f csi/vsphere-csi-node-ds.yaml
