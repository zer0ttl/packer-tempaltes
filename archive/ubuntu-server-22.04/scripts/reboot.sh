#!/bin/bash
#
# Update the box

echo "*** Rebooting the box"

DEBIAN_FRONTEND="noninteractive" sudo shutdown -r now

echo "*** Finished rebooting the box"
