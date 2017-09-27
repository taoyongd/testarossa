#!/bin/bash
set -x
set -e

HOSTS=$(vagrant status |  grep ^scale |cut -f1 -d' '|xargs echo)
echo "Destroying scale* hosts..."
vagrant destroy $HOSTS
echo "done"

echo "Removing ssh-config-file"
rm ssh-config-file || true
echo "done"
