#
# delete existing pod and creates new ones
script_dir=$(dirname $0)
. ${script_dir}/vars.rc

for i in $(seq $imax)
do 
  kubectl delete pod pod$i
done

pod_file=/tmp/pod.yml
for (( i = 1 ; i <= imax ; i++ ))
do
  i=$i techno=$techno envsubst < ./pod.tpl >${pod_file}
  kubectl apply -f ${pod_file}
done

