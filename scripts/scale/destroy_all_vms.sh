#!/bin/bash

# First, halt all running VMs
echo "Shutting down running VMs..."
uuids=$(xe vm-list is-control-domain=false power-state=running --minimal | sed 's/,/ /g')
for uuid in $uuids; do echo $uuid; xe vm-suspend uuid=$uuid & done;

# Now, destroy all non-control domain VMs
echo "Destroying VMs..."
uuids=$(xe vm-list is-control-domain=false --minimal | sed 's/,/ /g')
for uuid in $uuids; do echo $uuid; xe vm-destroy uuid=$uuid; done;
