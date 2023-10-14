#!/bin/bash
#
# Update the box

export DEBIAN_FRONTEND="noninteractive"

apt-get update -qq > /dev/null
apt-get dist-upgrade -qq -y > /dev/null
