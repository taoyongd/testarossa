#!/bin/bash

# For simplicity take all hosts as args again. We only care about $1 here though. 

# First, add a shared NFS SR to host 1
SERVER='10.71.160.15'
SERVER_PATH='/vol/xenrtnfs/1885284-BgLZmT'

echo "Adding the shared NFS SR to host $1"
vagrant ssh $1 -c "xe sr-create name-label='Shared NFS' type='NFS' device-config:server=$SERVER device-config:serverpath=$SERVER_PATH --shared"
echo "done"

echo "Pausing 5s to allow the SR to connect"
sleep 5s

echo "Enabling HA on pool"
vagrant ssh $1 -c 'xe pool-ha-enable'
echo "Done"

HA_TOLERANCE=$(vagrant ssh $1 -c 'xe pool-ha-compute-max-host-failures-to-tolerate')
echo "Setting HA tolerance to $HA_TOLERANCE"

POOL_UUID=$(vagrant ssh "$1" -c 'xe pool-list --minimal')
vagrant ssh $1 -c "xe pool-param-set ha-host-failures-to-tolerate=$HA_TOLERANCE uuid=$POOL_UUID"

echo "Done"

 
