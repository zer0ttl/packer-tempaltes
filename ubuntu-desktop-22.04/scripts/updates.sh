#!/bin/bash
#
# Update the box

echo "*** Updating the box"

DEBIAN_FRONTEND="noninteractive" apt-get update -y -qq > /dev/null
DEBIAN_FRONTEND="noninteractive" apt-get upgrade -y -qq > /dev/null
