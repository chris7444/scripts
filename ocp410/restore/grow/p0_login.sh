echo -n "Enter name of a cluster-admin: "
read -e user
echo -n "Enter password: "
read -e password

oc login https://localhost:6443 -u $user -p $password --insecure-skip-tls-verify=true
