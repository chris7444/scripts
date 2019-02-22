---
kind: StorageClass
apiVersion: storage.k8s.io/v1
metadata:
  name: ${techno}
provisioner: ${provisioner_name}
parameters:
  size: "16"
  compression: "false"
