#!/bin/bash
#
# Install spice-vdagent on the vm

# To allow for automated installs, we disable interactive configuration steps.
export DEBIAN_FRONTEND=noninteractive
export DEBCONF_NONINTERACTIVE_SEEN=true

echo "*** Installing spice-vdagent"

apt-get --assume-yes -qq update > /dev/null
apt-get --assume-yes -qq install spice-vdagent > /dev/null
systemctl start spice-vdagent > /dev/null

echo "*** Finished Installing spice-vdagent"
