#!/bin/bash

# Start a number of VMs spread equally across the given hosts
# Usage: ./scripts/scale/start_many_vms_hosts.sh N out-file HOSTS...

SSH_CONFIG_FILE=ssh-config-file

N=$1
shift

write_to=$1
shift

echo "Writing to $write_to"

HOSTS=$@
NUM_HOSTS=$#

let vms_each=$N/$NUM_HOSTS
master=${HOSTS%% *} # bash magic to get first word in the list
echo "Pool master is $master"

function start_vms {
  for i in `seq 1 $vms_each`; do for host in $HOSTS; do ./scripts/scale/start_vm_on.sh $host $master; done; done;
  wait;
}

TIMEFORMAT="time: %Rs"
printf "\n\nStarting $N VMs" >> $write_to
{ time start_vms 2>> /dev/null ; } 2>> $write_to
printf "\n" >> $write_to
ssh -F $SSH_CONFIG_FILE $master "free" >> $write_to
ssh -F $SSH_CONFIG_FILE $master "top -b -n1 | grep 'KiB Swap'" >> $write_to
