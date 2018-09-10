# use nmap to scan a subnet
nmap -sP -PS22,3389 172.17.0.0/16 | tee 172.17.scan.txt
