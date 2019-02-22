---
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: ${techno}-pvc${i}
  annotations:
    volume.beta.kubernetes.io/storage-class: "${techno}"
spec:
  accessModes:
    - ReadWriteMany
  resources:
    requests:
      storage: 100Mi
