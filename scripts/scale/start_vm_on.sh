#!/bin/bash
set -e
set -x


# Start a VM on the given host ($1)
echo "Starting a VM on $1..."

if [[ $2 != "" ]]; then master=$2; fi;

for arg in "$@"
do
  if [[ "$arg" == small* ]]; then master="small1"; fi
  if [[ "$arg" == med* ]]; then master="med1"; fi
  if [[ "$arg" == scale* ]]; then master="scale1"; fi
done
echo "Using pool master $master"

SSH_CONFIG_FILE='ssh-config-file'
MEMORY='16MiB'

host_uuid=$(ssh -F $SSH_CONFIG_FILE $master sudo xe host-list name-label=$1 --minimal)

vm_uuid=$(ssh -F $SSH_CONFIG_FILE $master sudo xe vm-create name-label="mirage-$1-$MEMORY")
ssh -F $SSH_CONFIG_FILE $master sudo xe vm-param-set PV-kernel=/boot/guest/test-vm.xen.gz uuid=$vm_uuid
ssh -F $SSH_CONFIG_FILE $master sudo xe vm-memory-limits-set uuid=$vm_uuid static-min=$MEMORY dynamic-min=$MEMORY dynamic-max=$MEMORY static-max=$MEMORY
ssh -F $SSH_CONFIG_FILE $master sudo xe vm-start uuid=$vm_uuid on=$1 &

echo "VM started"

