script_dir=$(dirname $0)
. ${script_dir}/vars.rc

pv_file=/tmp/pv.yml
pvc_file=/tmp/pvc.yml
class_file=/tmp/class.yml

provisioner_name=$provisioner_name techno=$techno envsubst <./class.tpl >${class_file}
kubectl apply -f ${class_file}


#
# Create $imax PVs and the corresponding PVCs
#

for (( i = 1 ; i <= imax ; i++ ))
do
#
# create the persistent volume claim, this will create the PV automatically
#
  i=$i techno=$techno envsubst < ./pvc.tpl >${pvc_file}
  kubectl apply -f ${pvc_file}

done

