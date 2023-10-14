#!/bin/bash
#
# Install qemu-guest-agent on the vm

sudo apt-get update -y
sudo apt-get install -y qemu-guest-agent
sudo systemctl start qemu-quest-agent