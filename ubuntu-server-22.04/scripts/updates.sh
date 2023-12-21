#!/bin/bash
#
# Update the box

# To allow for automated installs, we disable interactive configuration steps.
export DEBIAN_FRONTEND=noninteractive
export DEBCONF_NONINTERACTIVE_SEEN=true

echo "*** Updating the box"

apt-get --assume-yes -qq update > /dev/null
apt-get --assume-yes -qq upgrade > /dev/null

echo "*** Finished updating the box"
