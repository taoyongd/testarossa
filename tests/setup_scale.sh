#!/bin/bash
set -x
set -e

DIR="$(dirname "$0")"

HOSTS=$(vagrant status |  grep ^scale |cut -f1 -d' '|xargs echo)
vagrant up --provision $HOSTS
echo $HOSTS

# Pool the hosts together
. /root/testarossa/scripts/scale/pool_hosts.sh $HOSTS

# For now, sleep for 15s to ensure the hosts are contactable again
echo "Pausing 15s to allow the hosts to join pool and be reachable"
sleep 15s

# Enable HA
. /root/testarossa/scripts/scale/setup_ha.sh $HOSTS
