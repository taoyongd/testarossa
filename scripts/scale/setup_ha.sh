#!/bin/bash

# For simplicity take all hosts as args again. We only care about $1 here though. 

# First, add a shared NFS SR to host 1
SERVER='10.71.160.15'
SERVER_PATH='/vol/xenrtnfs/1885284-BgLZmT'

SHARED_ISO_PATH='10.71.213.9:/vol/xenrtmedia/xenrtmedia/xenrtdata/linux/iso'
SSH_CONFIG_FILE='ssh-config-file'

echo "Adding the shared iSCSI SR to host $1"
ssh -F $SSH_CONFIG_FILE $1 xe sr-create type=lvmoiscsi device-config:target=10.71.161.1 device-config:targetIQN=iqn.2009-01.xenrt.test:iscsi07ef2aea device-config:SCSIid=1494554000000000036333730626664620000000000000000 name-label='Shared iSCSI' --shared
echo "done"

echo "Enabling HA on pool"
ssh -F $SSH_CONFIG_FILE $1 xe pool-ha-enable
echo "Done"

HA_TOLERANCE=$(vagrant ssh $1 -c 'xe pool-ha-compute-max-host-failures-to-tolerate')
echo "Setting HA tolerance to $HA_TOLERANCE"

POOL_UUID=$(vagrant ssh "$1" -c 'xe pool-list --minimal')
ssh -F $SSH_CONFIG_FILE $1 xe pool-param-set ha-host-failures-to-tolerate=$HA_TOLERANCE uuid=$POOL_UUID

echo "Done"

 
