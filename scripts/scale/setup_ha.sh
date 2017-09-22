#!/bin/bash

# For simplicity take all hosts as args again. We only care about $1 here though. 

# First, add a shared NFS SR to host 1
SERVER='10.71.160.15'
SERVER_PATH='/vol/xenrtnfs/1885284-BgLZmT'

SHARED_ISO_PATH='10.71.213.9:/vol/xenrtmedia/xenrtmedia/xenrtdata/linux/iso'
SSH_CONFIG_FILE='ssh-config-file'

echo "Adding the shared NFS SR to host $1"
ssh -F $SSH_CONFIG_FILE $1 xe sr-create name-label='Shared NFS' type='NFS' device-config:server=$SERVER device-config:serverpath=$SERVER_PATH --shared
echo "done"

echo "Adding shared linux ISOs to host $1"
ssh -F $SSH_CONFIG_FILE $1 xe sr-create content-type=iso type=iso name-label='Shared Linux ISOs' device-config:location=$SHARED_ISO_PATH --shared
echo "done"

echo "Enabling HA on pool"
ssh -F $SSH_CONFIG_FILE $1 xe pool-ha-enable
echo "Done"

HA_TOLERANCE=$(vagrant ssh $1 -c 'xe pool-ha-compute-max-host-failures-to-tolerate')
echo "Setting HA tolerance to $HA_TOLERANCE"

POOL_UUID=$(vagrant ssh "$1" -c 'xe pool-list --minimal')
ssh -F $SSH_CONFIG_FILE $1 xe pool-param-set ha-host-failures-to-tolerate=$HA_TOLERANCE uuid=$POOL_UUID

echo "Done"

 
