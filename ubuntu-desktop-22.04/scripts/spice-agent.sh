#!/bin/bash
#
# Install spice-vdagent on the vm

echo "*** Installing spice-vdagent"

export DEBIAN_FRONTEND="noninteractive"

sudo apt-get update -y > /dev/null
sudo apt-get install -y spice-vdagent > /dev/null
sudo systemctl start spice-vdagent > /dev/null

