#!/bin/sh
ip=$(ssh root@10.71.137.225 "xe pif-list device=eth1 params=all | grep \"IP ( \" | awk -F \":\" '{print \$2}'")

for a in $ip
do
 # ssh-copy-id -i ~/.ssh/id_rsa.pub root@$a
  sshpass -p "xenroot" ssh -o "StrictHostKeyChecking no"  root@$a "mv /opt/xensource/bin/xapi /opt/xensource/bin/xapi.bak"
  sshpass -p "xenroot" scp -o "StrictHostKeyChecking no" xapi root@$a:/opt/xensource/bin/ 
  sshpass -p "xenroot" ssh -o "StrictHostKeyChecking no" root@$a "xe-toolstack-restart"
done
