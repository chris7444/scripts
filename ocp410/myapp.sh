oc new-project myapp
oc new-app --template=openshift/nginx-example --name=myapp --param=NAME=myapp
oc apply -f - <<EOF
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: myapp
  namespace: myapp
spec:
  rules:
  - host: myapp.apps.hpe.cloudra.local
    http:
      paths:
      - backend:
          serviceName: myapp
          servicePort: 8080
        path: /
EOF
