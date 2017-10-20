#!/bin/bash

# $1 is the name of this host

xe host-param-set uuid=$(xe host-list --minimal) name-label=$1
echo "Renamed host $1"
