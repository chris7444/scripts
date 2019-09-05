export ETCDCTL=/var/home/core/assets/bin/etcdctl
export ASSET_DIR=/home/core/assets/
export ETCDCTL_API=3
sudo ETCDCTL_API=3 ${ETCDCTL} --cert $ASSET_DIR/backup/etcd-client.crt --key $ASSET_DIR/backup/etcd-client.key --cacert $ASSET_DIR/backup/etcd-ca-bundle.crt member list
