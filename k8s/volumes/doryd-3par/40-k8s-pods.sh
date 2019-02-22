#
# Create pods 
#
script_dir=$(dirname $0)
. ${script_dir}/vars.rc

pod_file=/tmp/pod.yml
for (( i = 1 ; i <= imax ; i++ ))
do

  i=$i techno=$techno envsubst < ./pod.tpl >${pod_file}
  kubectl apply -f ${pod_file}

done

