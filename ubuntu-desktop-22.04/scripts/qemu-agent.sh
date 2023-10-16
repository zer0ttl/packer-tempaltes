#!/bin/bash
#
# Install qemu-guest-agent on the vm

echo "*** Installing qemu-guest-agent"

DEBIAN_FRONTEND="noninteractive" apt-get update -y -qq > /dev/null
DEBIAN_FRONTEND="noninteractive" apt-get install qemu-guest-agent -y -qq > /dev/null
#systemctl start qemu-guest-agent

echo "*** Finished qemu-guest-agent"
