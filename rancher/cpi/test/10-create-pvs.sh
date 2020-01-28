#
# Create SC and PVCs
#
script_dir=$(dirname $0)
. ${script_dir}/vars.rc

out_file=/tmp/pvc.tpl
for (( i = 1 ; i <= imax ; i++ ))
do
  i=$i techno=$techno envsubst < ./pvc.tpl >${out_file}
  kubectl apply -f ${out_file}
done

