script_dir=$(dirname $0)
. ${script_dir}/vars.rc

for (( i = 1 ; i <= imax ; i++ ))
do
  pod=$(kubectl get pod -l app=$techno-pod$i -o json | jq .items[].metadata.name)
  pod=$( eval echo $pod )
  echo pod=$pod
  status=$(kubectl get pods $pod -o json | jq -r .status.phase)
  while [ "$status" != "Running" ]
  do
    Waiting for the pod to start
    status=$(kubectl get pods $pod -o json | jq -r .status.phase)
  done
  date=$(date)
  kubectl exec -it $pod -- sh -c "echo $date $techno pod$i >/tmp/foo/foo.txt"
done

