#!/bin/bash
#
# Update the box

echo "*** Updating the box"

DEBIAN_FRONTEND=noninteractive apt-get update -qq > /dev/null
DEBIAN_FRONTEND=noninteractive apt-get upgrade -qq -y > /dev/null
