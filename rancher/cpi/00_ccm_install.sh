cat >/tmp/vsphere.conf <<EOF
[Global]
insecure-flag = "true"

[VirtualCenter "vcentergen9.am2.cloudra.local"]
user = "Administrator@vsphere.local"
password = "Just4m\$hpe20!9"
port = "443"
datacenters = "DEVOPS"

[Network]
public-network = "clh2964"
EOF

kubectl delete configmap cloud-config -n kube-system 
kubectl create configmap cloud-config --from-file=/tmp/vsphere.conf -n kube-system
kubectl apply -f cpi/cloud-controller-manager-roles.yaml
kubectl apply -f cpi/cloud-controller-manager-role-bindings.yaml
kubectl apply -f cpi/vsphere-cloud-controller-manager-ds.rancher.yaml
