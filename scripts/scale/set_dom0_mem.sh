#!/bin/bash

# Usage: ./scripts/scale/set_dom0_me.sh <small>|<medium>|<large> <N>
# Set the pool dom0 memory to N mb

SSH_CONFIG_FILE=ssh-config-file

function set_mem_all {
  prefix=$1 # small, med, scale
  num_hosts=$2 
  new_mem=$3
  for i in `seq 1 $num_hosts`; do echo "$prefix$i"; ssh -F $SSH_CONFIG_FILE "$prefix$i" sudo /opt/xensource/libexec/xen-cmdline --set-xen dom0_mem=${new_mem}M,max:${new_mem}M; done;
}

function reboot_slaves {
  prefix=$1 # small, med, scale
  num_hosts=$2 

  echo "Rebooting slaves"
  # Reboot all except the pool master, so we can monitor in XC
  for i in `seq 2 $num_hosts`; do echo "$prefix$i"; ssh -F $SSH_CONFIG_FILE "$prefix$i" sudo reboot; done;
  echo "When ready, reboot "${prefix}1" to finish."
}

function set_mem_small {
  echo "Set dom0 memory for small pool to ${1}MB"
  set_mem_all "small" 3 $1
  reboot_slaves "small" 3
}

function set_mem_medium {
  echo "Set dom0 memory for medium pool to ${1}MB"
  set_mem_all "med" 16 $1
  reboot_slaves "med" 16
}

function set_mem_large {
  echo "Set dom0 memory for large pool to ${1}MB"
  set_mem_all "scale" 64 $1
  reboot_slaves "scale" 64
}

if [ "$1" == "small" ]; then set_mem_small $2; fi
if [ "$1" == "medium" ]; then set_mem_medium $2; fi
if [ "$1" == "large" ]; then set_mem_large $2; fi

