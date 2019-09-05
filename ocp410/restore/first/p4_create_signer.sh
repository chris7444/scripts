hostname=$(hostname)
export KUBE_ETCD_SIGNER_SERVER=$(oc adm release info --image-for kube-etcd-signer-server --registry-config=/var/lib/kubelet/config.json)
sudo -E /usr/local/bin/tokenize-signer.sh ${hostname}
oc create -f assets/manifests/kube-etcd-cert-signer.yaml
ss -ltn | grep 9943

