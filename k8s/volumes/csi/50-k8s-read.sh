#
# Read the psistent volumes
#
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
    echo Waiting for the pod to start
    status=$(kubectl get pods $pod -o json | jq -r .status.phase)
  done

  echo Reading $techno-pod$i
  kubectl exec -it $pod -- sh -c "cat /tmp/foo/foo.txt"
done

