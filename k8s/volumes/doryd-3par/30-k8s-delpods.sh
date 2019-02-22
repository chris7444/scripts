#
# delete the NFS pods (synchronous)
#
script_dir=$(dirname $0)
. ${script_dir}/vars.rc


for (( i = 1 ; i <= imax ; i++ ))
do
  kubectl get deploy $techno-pod$i 2>/dev/null && kubectl delete deploy $techno-pod$i
done

for (( i = 1 ; i <= imax ; i++ ))
do
  echo Waiting for $techno-pod$i to terminate
  pod=$(kubectl get pod -l app=$techno-pod$i -o json | jq .items[].metadata.name)
  while [ "$pod" != "" ]
  do
     echo Waiting for $techno-pod$i to terminate
     sleep 5
     pod=$(kubectl get pod -l app=$techno-pod$i -o json | jq .items[].metadata.name)
  done
done


