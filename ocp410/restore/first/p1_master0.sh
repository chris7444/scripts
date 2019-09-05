hostname=${hostname}
export INITIAL_CLUSTER="etcd-member-${hostname}=https://etcd-0.hpe.hpecloud.org:2380"
sudo /usr/local/bin/etcd-snapshot-restore.sh /home/core/snapshot.db $INITIAL_CLUSTER
