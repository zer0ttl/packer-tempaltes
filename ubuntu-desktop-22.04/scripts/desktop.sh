#!/bin/sh -x

# install ubuntu-desktop-minimal and fix root login error
apt-get update
DEBIAN_FRONTEND=noninteractive apt-get upgrade -y
echo 'gdm3 shared/default-x-display-manager select lightdm' | debconf-set-selections
echo 'lightdm shared/default-x-display-manager select lightdm' | debconf-set-selections
DEBIAN_FRONTEND=noninteractive apt-get install -y ubuntu-desktop-minimal lightdm
systemctl enable lightdm.service
systemctl start lightdm.service

sed -i 's/mesg n || true.*/tty -s \&\& mesg n || true/g' /root/.profile

snap install firefox
