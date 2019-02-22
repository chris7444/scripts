#
# delete PVs, PVCs, deployments
#
script_dir=$(dirname $0)
. ${script_dir}/vars.rc

#
# delete the deployments
#
for (( i = 1 ; i <= imax ; i++ ))
do
  kubectl get deploy $techno-pod$i 2>/dev/null && kubectl delete deploy $techno-pod$i
done

#
# Wait for the deployments to be fully terminated
#
for (( i = 1 ; i <= imax ; i++ ))
do
  pod=$(kubectl get pod -l app=$techno-pod$i -o json | jq .items[].metadata.name)
  if [ "$pod" != "" ]
  then
    kubectl delete deployment $techno-pod$i
    while [ "$pod" != "" ]
    do
      echo Waiting for $techno-pod$i to be deleted
      sleep 5
      pod=$(kubectl get pod -l app=$techno-pod$i -o json | jq .items[].metadata.name)
    done
  fi
done

#
# delete the storage (PV claims and PVs)
#
for (( i = 1 ; i <= imax ; i++ ))
do
  kubectl get pvc $techno-pvc$i 2>/dev/null && kubectl delete pvc $techno-pvc$i 
#  kubectl get pv $techno-pv$i  2>/dev/null && kubectl delete pv $techno-pv$i
done

#
# delete the storage class
#
kubectl delete sc ${techno}
