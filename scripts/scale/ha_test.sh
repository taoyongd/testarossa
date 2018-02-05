#!/bin/bash

# Start a number of VMs spread equally across the given pool
# Usage: ./scripts/scale/start_many_vms.sh <medium|large> N

SSH_CONFIG_FILE='ssh-config-file'

#write_to_set_restart_config=$2
write_to_compute_max_host_failure=$2
TIMEFORMAT="time: %Rs"

function enable_ha_always_run {
  master=$1
  vms=$(ssh -F $SSH_CONFIG_FILE $master sudo xe vm-list params=uuid is-control-domain=false ha-always-run=false --minimal)
  OLD_IFS="$IFS"
  IFS=","
  arr=($vms)
  IFS="$OLD_IFS"
  for s in ${arr[@]}
  do
  ssh -F $SSH_CONFIG_FILE $master sudo xe vm-param-set uuid="$s" ha-always-run=true
  done
  wait;
}
function compute_ha_max_host_failure {
  master=$1
  ssh -F $SSH_CONFIG_FILE $master sudo xe pool-ha-compute-max-host-failures-to-tolerate
  wait;
}

function start_many_medium {
#  { time enable_ha_always_run "med1" 2 >> /dev/null ; } 2>> $write_to_set_restart_config
  { time compute_ha_max_host_failure "med1" 2>> /dev/null ; } 2>> $write_to_compute_max_host_failure
  printf "\n" >> $write_to_compute_max_host_failure
}

function start_many_large {
  #{ time enable_ha_always_run "large" 2 >> /dev/null ; } 2>> $write_to_set_restart_config
  { time xe pool-ha-compute-max-host-failures-to-tolerate 2>> /dev/null ; } 2>> $write_to_compute_max_host_failure
  printf "\n" >> $write_to_compute_max_host_failure
}
if [ "$1" == "small" ]; then start_many_small $2; fi
if [ "$1" == "medium" ]; then start_many_medium $2; fi
if [ "$1" == "large" ]; then start_many_large $2; fi
