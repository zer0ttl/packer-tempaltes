#!/bin/sh -x

# install xubuntu-desktop and fix root login error
apt-get update
echo 'gdm3 shared/default-x-display-manager select lightdm' | debconf-set-selections
echo 'lightdm shared/default-x-display-manager select lightdm' | debconf-set-selections
DEBIAN_FRONTEND=noninteractive apt-get install -y xubuntu-desktop
sed -i 's/mesg n || true.*/tty -s \&\& mesg n || true/g' /root/.profile

snap install firefox
