#!/bin/bash

# $1 is the host to fix

SSH_CONFIG_FILE='ssh-config-file'

scp -F ssh-config-file /root/testarossa/test-vm/test-vm.xen.gz $1:/boot/guest/test-vm.xen.gz
