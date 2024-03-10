#!/bin/bash
#
# install ubuntu-desktop-minimal and fix root login error

echo "*** Installing desktop environment"

DEBIAN_FRONTEND=noninteractive apt-get update -y -qq > /dev/null
echo 'gdm3 shared/default-x-display-manager select lightdm' | debconf-set-selections
echo 'lightdm shared/default-x-display-manager select lightdm' | debconf-set-selections
DEBIAN_FRONTEND=noninteractive apt-get install -y ubuntu-desktop-minimal lightdm -qq > /dev/null
# sudo apt-get install -y ubuntu-desktop-minimal

echo "*** Enabling lightdm.service"

# https://unix.stackexchange.com/questions/561797/how-do-i-re-enable-the-lightdm-service
# sudo systemctl enable lightdm.service > /dev/null
# /lib/systemd/systemd-sysv-install enable lightdm

echo "*** Starting lightdm.service"
sudo service lightdm start > /dev/null

sed -i 's/mesg n || true.*/tty -s \&\& mesg n || true/g' /root/.profile

echo "*** Finished Installing desktop environment"
