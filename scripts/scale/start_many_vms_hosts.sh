#!/bin/bash

# Start a number of VMs spread equally across the given hosts
# Usage: ./scripts/scale/start_many_vms_hosts.sh N HOSTS...

N=$1
shift

HOSTS=$@
NUM_HOSTS=$#

let vms_each=$N/$NUM_HOSTS
master=${HOSTS%% *} # bash magic to get first word in the list
echo "Pool master is $master"

for i in `seq 1 $vms_each`; do for host in $HOSTS; do ./scripts/scale/start_vm_on.sh $host $master; done; done;
wait;
