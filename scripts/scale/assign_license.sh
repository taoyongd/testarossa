#!/bin/bash

uuid=$(xe host-list --minimal)
xe host-apply-edition edition=enterprise-per-socket license-server-address=xenrt-license.xenrt.citrite.net license-server-port=27000 host-uuid=$uuid
