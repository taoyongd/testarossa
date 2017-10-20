#!/bin/bash

# Start a number of VMs spread equally across the given pool
# Usage: ./scripts/scale/start_many_vms.sh <medium|large> N

function start_many {
  prefix=$1
  num_hosts=$2
  vms_each=$3

  for i in `seq 1 $vms_each`; do for j in `seq 1 $num_hosts`; do ./scripts/scale/start_vm_on.sh "$prefix$j"; done; done;
  wait;
}

function start_many_medium {
  let vms_each=$1/16
  echo "Starting $1 VMs on medium pool ($vms_each each)..."
  start_many "med" 16 $vms_each
}

function start_many_large {
  let vms_each=$1/64
  echo "Starting $1 VMs on large pool ($vms_each each)..."
  start_many "scale" 64 $vms_each
}

if [ "$1" == "medium" ]; then start_many_medium $2; fi
if [ "$1" == "large" ]; then start_many_large $2; fi
