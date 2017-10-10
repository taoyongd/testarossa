#!/bin/bash

# For simplicity take all hosts as args again. We only care about $1 here though. 

SSH_CONFIG_FILE='ssh-config-file'

function add_iscsi_small {
  # iSCSI VM on perfuk-01-01
  ssh -F $SSH_CONFIG_FILE $1 'xe sr-create type=lvmoiscsi device-config:target=10.71.217.138 device-config:targetIQN=iqn.2009-01.xenrt.test:iscsi11ac8a78 device-config:SCSIid=1494554000000000031373033616135390000000000000000 name-label="Small shared ISCSI" --shared'
}

function add_iscsi_medium {
  # iSCSI VM on xrtuk-05-08-perf
  ssh -F $SSH_CONFIG_FILE $1 'xe sr-create device-config:target=10.71.137.12 type=lvmoiscsi device-config:targetIQN=iqn.2009-01.xenrt.test:iscsi2b83e6a0 device-config:SCSIid=1494554000000000030326165323530660000000000000000 name-label="Medium iSCSI target" --shared'
}

function add_iscsi_large {
  # iSCSI VM on xrtuk-08-05
  ssh -F $SSH_CONFIG_FILE $1 'xe sr-create type=lvmoiscsi device-config:target=10.71.161.1 device-config:targetIQN=iqn.2009-01.xenrt.test:iscsi07ef2aea device-config:SCSIid=1494554000000000036333730626664620000000000000000 name-label="Large Shared iSCSI" --shared'
}

# First, add a shared iSCSI target to host 1
echo "Adding a shared iSCSI target to host $1"
if [[ "$1" == small* ]]
then
  add_iscsi_small $1
fi

if [[ "$1" == med* ]]
then
  add_iscsi_medium $1
fi

if [[ "$1" == scale* ]]
then
  add_iscsi_large $1
fi

echo "done"


echo "Enabling HA on pool"
ssh -F $SSH_CONFIG_FILE $1 xe pool-ha-enable
echo "Done"

HA_TOLERANCE=$(ssh -F $SSH_CONFIG_FILE $1 xe pool-ha-compute-max-host-failures-to-tolerate)
echo "Setting HA tolerance to $HA_TOLERANCE"
echo "(Skipping for performance)"

#POOL_UUID=$(ssh -F $SSH_CONFIG_FILE $1 xe pool-list --minimal)
#ssh -F $SSH_CONFIG_FILE $1 xe pool-param-set ha-host-failures-to-tolerate=$HA_TOLERANCE uuid=$POOL_UUID

echo "Done" 
