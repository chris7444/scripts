---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: storage-claim${i}
spec:
  accessModes:
    - ReadWriteOnce
  storageClassName: csivols
  resources:
    requests:
      storage: 100Mi

---
apiVersion: v1
kind: Pod
metadata:
  name: pod${i}
  labels:
    app: $techno-pod$i
    mypod: "" 
spec:
#  nodeSelector:
#    mylabel: "yes"
  volumes:
  - name: pod-data${i}
    persistentVolumeClaim:
      claimName: storage-claim${i}
  terminationGracePeriodSeconds: 1
  containers:
  - name: storage-pod
    command:
    - sh
    - -c
    - while true; do sleep 1; done
    image: radial/busyboxplus:curl
    volumeMounts:
    - mountPath: /tmp/foo
      name: pod-data${i}
