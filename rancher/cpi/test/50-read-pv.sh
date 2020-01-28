script_dir=$(dirname $0)
. ${script_dir}/vars.rc

for i in $(seq $imax)
do 
  kubectl exec -it  pod$i -- sh -c "cat /tmp/foo/foo.txt"
done
