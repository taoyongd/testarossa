#! /bin/bash

# Change the management network on this host to eth1

source /etc/xensource-inventory
pif=`xe pif-list device=eth1 host-uuid=${INSTALLATION_UUID} --minimal`
echo "mypif=$pif" > /tmp/mypif
xe pif-reconfigure-ip uuid=$pif mode=DHCP
is_mgmt=`xe pif-param-get uuid=$pif param-name=management`
echo "is_mgmt=$is_mgmt" > /tmp/is_mgmt
if [ $is_mgmt = "false" ]; then
  xe host-management-reconfigure pif-uuid=$pif
fi
