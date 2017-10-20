#!/bin/bash

# $1 is the host to copy scripts to

SSH_CONFIG_FILE='ssh-config-file'

scp -F $SSH_CONFIG_FILE -r -q /root/testarossa/scripts $1:/
