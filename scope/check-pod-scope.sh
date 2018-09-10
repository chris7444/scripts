curdir=$PWD
range=$1
if [ "$range" == "" ]
then
  echo "usage: $(basename $0) range"
  echo "  where range is assumed to be the first 16 bits of an IP adresses (typically 172.16 or 172.17 or 172.18 or 192.168, etc)" 
  exit 1
fi
range=$range

tmpdir=$(mktemp -d)
echo Verifying range=$range.255.255
echo "This will take a few minutes!!"
for m in {1..255}
do
(
  for n in {1..255}
  do
    ping -W 1 -c 1 $range.$m.$n  >/dev/null
    status=$?
    if [ $status == 0 ]
    then
      echo OK $range.$m.$n 
    else
      echo KO $range.$m.$n
    fi
  done
) > ${tmpdir}/scope.$range.$m.txt  &
done
wait
grep OK ${tmpdir}/scope.$range.*.txt | tee /tmp/scope.$range.txt
status=$?
if [ $status == 0 ]
then
  echo warning There are IP addresses in use in this scope
  exit 1
else
  echo "Scope $range seems to be available"
fi
rm -rf ${tmpdir}
