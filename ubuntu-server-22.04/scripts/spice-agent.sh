#!/bin/bash
#
# Install spice-vdagent on the vm

echo "*** Installing spice-vdagent"

DEBIAN_FRONTEND="noninteractive" apt-get update -qq > /dev/null
DEBIAN_FRONTEND="noninteractive" apt-get install spice-vdagent -qq -y > /dev/null
systemctl start spice-vdagent > /dev/null

echo "*** Finished Installing spice-vdagent"
