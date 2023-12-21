#!/bin/bash
#
# Install qemu-guest-agent on the vm

# To allow for automated installs, we disable interactive configuration steps.
export DEBIAN_FRONTEND=noninteractive
export DEBCONF_NONINTERACTIVE_SEEN=true

echo "*** Installing qemu-guest-agent"

apt-get --assume-yes -qq update > /dev/null
apt-get --assume-yes -qq install qemu-guest-agent > /dev/null
#systemctl start qemu-guest-agent

echo "*** Finished qemu-guest-agent"
