oc label node hpe-ocp1 node-role.kubernetes.io/infra=""
oc label node hpe-ocp2 node-role.kubernetes.io/infra=""
oc label node hpe-ocp3 node-role.kubernetes.io/infra=""
oc patch ingresscontroller/default --type=merge -n openshift-ingress-operator -p '{"spec": {"nodePlacement":{"nodeSelector":{"matchLabels":{"node-role.kubernetes.io/infra": ""}}}}}'
oc patch --type=merge  -n openshift-logging clusterlogging/instance -p '{"spec":{"curation":{"curator":{"nodeSelector":{"node-role.kubernetes.io/infra":""}}},"logStore":{"elasticsearch":{"nodeSelector":{"node-role.kubernetes.io/infra":""}}},"visualization":{"kibana":{"nodeSelector":{"node-role.kubernetes.io/infra":""}}}}}'
