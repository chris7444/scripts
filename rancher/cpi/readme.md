CPI/CSI works with Ubuntu 18.04 but not with RancherOS 1.5.5

When deploying the cluster 
- chose external cloud provider
- then edit the cluster,yaml file to add the following lines for the kubelet service (under services):

    kubelet:
      fail_swap_on: false
      generate_serving_certificate: false
      extra_binds:
        - /var/lib/csi/sockets/pluginproxy/csi.vsphere.vmware.com:/var/lib/csi/sockets/pluginproxy/csi.vsphere.vmware.com:rshared
        - /csi:/csi:rshared
      extra_args:
        cloud-provider: external


below the same in context
  services:
    kubelet:
      fail_swap_on: false
      generate_serving_certificate: false
      extra_binds:
        - /var/lib/csi/sockets/pluginproxy/csi.vsphere.vmware.com:/var/lib/csi/sockets/pluginproxy/csi.vsphere.vmware.com:rshared
        - /csi:/csi:rshared
      extra_args:
        cloud-provider: external
    etcd:
      backup_config:
        enabled: true
        interval_hours: 12
        retention: 6
        safe_timestamp: false
      creation: 12h
      extra_args:
        election-timeout: 5000
        heartbeat-interval: 500
      gid: 0
      retention: 72h
      snapshot: false
      uid: 0
    kube_api:
      always_pull_images: false
      pod_security_policy: false
      service_node_port_range: 30000-32767
  ssh_agent_auth: false
windows_prefered_cluster: false

Once the cluste ris deployed, run the xx-*.sh scripts in order
