#!/bin/sh -eux

echo 'vagrant' | sudo -S -v

VER="`cat /home/vagrant/.vbox_version`";

echo "Packer :: Virtualbox Tools Version: $VER";

ISO_URL="https://download.virtualbox.org/virtualbox/$VER/VBoxGuestAdditions_$VER.iso";

wget $ISO_URL -O /home/vagrant/VBoxGuestAdditions_${VER}.iso;

mkdir -p /tmp/vbox;
sudo mount -o loop /home/vagrant/VBoxGuestAdditions_${VER}.iso /tmp/vbox;
la
sudo sh /tmp/vbox/VBoxLinuxAdditions.run \
        || echo "VBoxLinuxAdditions.run exited $? and is suppressed." \
            "For more read https://www.virtualbox.org/ticket/12479";
umount /tmp/vbox;
rm -rf /tmp/vbox;
rm -f /home/vagrant/VBoxGuestAdditions_${VER}.iso;