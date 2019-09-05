echo -n "Enter te name of a cluster admin: "
read -e user
echo -n "Enter the password: "
read -e password 
oc login https://localhost:6443 -u user -p $password --insecure-skip-tls-verify=true

