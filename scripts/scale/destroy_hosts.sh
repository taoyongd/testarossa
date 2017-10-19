#!/bin/bash
set -x
set -e

# Usage: ./scripts/scale/destroy_hosts.sh <small> <medium> <large>

function destroy_small {
  HOSTS=$(vagrant status |  grep ^small |cut -f1 -d' '|xargs echo)
  vagrant destroy $HOSTS
}

function destroy_medium { 
  HOSTS=$(vagrant status |  grep ^med |cut -f1 -d' '|xargs echo)
  vagrant destroy $HOSTS
}

function destroy_large {
  HOSTS=$(vagrant status |  grep ^scale |cut -f1 -d' '|xargs echo)
  vagrant destroy $HOSTS
}

for arg in "$@"
do
  if [ "$arg" == "small" ]; then destroy_small; fi
  if [ "$arg" == "medium" ]; then destroy_medium; fi
  if [ "$arg" == "large" ]; then destroy_large; fi
done

echo "done"
