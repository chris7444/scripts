cd ~/Docker-Synergy/ops
ips=$(awk '/10.60.59/ {print $2}' vm_hosts.all  | awk -F'=' '{print $2}' | awk -F'/' '{print $1}' |  awk -F"'" '{print $2}' | sort -u)
ips="10.96.0.1 $ips"
echo $ips
for ip in $ips
do
  ping $ip -c 1 >/dev/null
  status=$?
  if [ $status == 0 ]
  then
    echo OK $ip
  else
    echo KO $ip
  fi
done

