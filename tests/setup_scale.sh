#!/bin/bash
set -x
set -e

# Usage: ./tests/setup_scale.sh <small> <medium> <large>

SSH_CONFIG_FILE='ssh-config-file'

function update_ssh_config {
  echo "Updating SSH config..."
  # Errors here are expected, not all VMs are up - still useful to get the partial config though
  vagrant ssh-config > $SSH_CONFIG_FILE 2> /dev/null || true
}

function setup_small {
  HOSTS=$(vagrant status |  grep ^small |cut -f1 -d' '|xargs echo)
  vagrant up --provision $HOSTS
  echo $HOSTS

  update_ssh_config

  # Pool the hosts together
  . /root/testarossa/scripts/scale/pool_hosts.sh $HOSTS

  # For now, sleep for 15s to ensure the hosts are contactable again
  echo "Pausing 15s to allow the hosts to join pool and be reachable"
  sleep 15s

  # Enable HA
  . /root/testarossa/scripts/scale/setup_ha.sh $HOSTS
}

function setup_medium {
  HOSTS=$(vagrant status |  grep ^med |cut -f1 -d' '|xargs echo)
  vagrant up --provision $HOSTS
  echo $HOSTS

  update_ssh_config

  # Pool the hosts together
  . /root/testarossa/scripts/scale/pool_hosts.sh $HOSTS

  # For now, sleep for 15s to ensure the hosts are contactable again
  echo "Pausing 15s to allow the hosts to join pool and be reachable"
  sleep 15s

  # Enable HA
  . /root/testarossa/scripts/scale/setup_ha.sh $HOSTS
}

function setup_large {
  HOSTS=$(vagrant status |  grep ^scale |cut -f1 -d' '|xargs echo)
  vagrant up --provision-with shell --parallel $HOSTS
  vagrant provision --provision-with ansible $HOSTS
  echo $HOSTS

  update_ssh_config

  # Pool the hosts together
  . /root/testarossa/scripts/scale/pool_hosts.sh $HOSTS

  # For now, sleep for 15s to ensure the hosts are contactable again
  echo "Pausing 15s to allow the hosts to join pool and be reachable"
  sleep 15s

  # Enable HA
  . /root/testarossa/scripts/scale/setup_ha.sh $HOSTS
}

for arg in "$@"
do
  if [ "$arg" == "small" ]; then setup_small; fi
  if [ "$arg" == "medium" ]; then setup_medium; fi
  if [ "$arg" == "large" ]; then setup_large; fi
done

