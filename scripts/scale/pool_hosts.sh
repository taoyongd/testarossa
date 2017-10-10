#!/bin/bash

# 1 arg per host to pool

SSH_CONFIG_FILE='ssh-config-file'

# Get IP of host1
IP_TMP=$(ssh -F $SSH_CONFIG_FILE $1 /scripts/xs/get_public_ip.sh) #uuid,ip
IP=$(echo $IP_TMP | cut -d, -f2)

echo "Pool master IP is $IP"

# Ignore first param for looping over the rest
shift

# Join the rest of the hosts to the pool with the first
for i in "$@"
do
  echo "Joining $i to the pool..."
  ssh -F $SSH_CONFIG_FILE $i sudo xe pool-join master-address=$IP master-username=root master-password=xenroot 
  echo "Done"
done

echo "Add the pool to XC using master IP $IP"
