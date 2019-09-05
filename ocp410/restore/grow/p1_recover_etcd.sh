hostname=$(hostname)
export SETUP_ETCD_ENVIRONMENT=$(oc adm release info --image-for setup-etcd-environment --registry-config=/var/lib/kubelet/config.json)
echo "etcd image: $SETUP_ETCD_ENVIRONMENT"
export KUBE_CLIENT_AGENT=$(oc adm release info --image-for kube-client-agent --registry-config=/var/lib/kubelet/config.json)
echo "kube client agent: $KUBE_CLIENT_AGENT"
sudo -E /usr/local/bin/etcd-member-recover.sh 10.15.152.210  etcd-member-${hostname} 

