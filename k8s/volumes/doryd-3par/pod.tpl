---
apiVersion: apps/v1beta2
kind: Deployment

metadata:
  name: $techno-pod$i

spec:
  selector:
    matchLabels:
      app: $techno-pod$i

  replicas: 1

  template:
    metadata:
      labels:
        app: $techno-pod$i
    spec:
      volumes:
      - name: pod-data
        persistentVolumeClaim:
          claimName: $techno-pvc$i

      containers:
      - name: $techno-pod$i
        command:
        - sh
        - -c
        - while true; do sleep 1; done
        image: radial/busyboxplus:curl
        volumeMounts:
        - mountPath: /tmp/foo
          name: pod-data
