#!/bin/bash

# 1 arg per host, names the pool master $1 and the rest of the hosts $2,...

SSH_CONFIG_FILE='ssh-config-file'

# Get the pool master host uuid
master_uuid=$(ssh -F $SSH_CONFIG_FILE $1 xe pool-list params=master --minimal) # host uuid

# Ensure the master is named $1
ssh -F $SSH_CONFIG_FILE $1 xe host-param-set uuid=$master_uuid name-label=$1

# Get the rest of the hosts
all_host_uuids=$(ssh -F $SSH_CONFIG_FILE $1 xe host-list --minimal | sed 's/,/ /g')

i=2 # Start naming at $2 (leave the master alone)
for uuid in $all_host_uuids
  do 
  if [ "$uuid" != "$master_uuid" ]
    then ssh -F $SSH_CONFIG_FILE $1 xe host-param-set uuid=$uuid name-label="${!i}" #${!i} gets $i from the script args
    let "i++"
  fi
done
