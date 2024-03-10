#!/bin/bash
#
# Some common fixes

echo "*** Running fixes.sh"

# disable root login using password
echo "*** Disable root login using password"
sudo passwd -l root
sudo sed -i 's/PermitRootLogin.*/PermitRootLogin no/g' /etc/ssh/sshd_config

# disable upgrade popup and unattended upgrades
echo "*** Disable upgrade popup and unattended upgrades"
sudo sed -i 's/Prompt=.*/Prompt=never/' /etc/update-manager/release-upgrades
DEBIAN_FRONTEND="noninteractive" sudo apt-get remove update-notifier unattended-upgrades -y --purge > /dev/null

# disable apt-daily
echo "*** Disable apt-daily"
sudo systemctl stop apt-daily.timer > /dev/null
sudo systemctl stop apt-daily-upgrade.timer > /dev/null
sudo systemctl disable apt-daily.timer > /dev/null
sudo systemctl disable apt-daily-upgrade.timer > /dev/null
sudo systemctl daemon-reload > /dev/null

# reset the machine-id.
# NB systemd will re-generate it on the next boot.
# NB machine-id is indirectly used in DHCP as Option 61 (Client Identifier), which
#    the DHCP server uses to (re-)assign the same or new client IP address.
# see https://www.freedesktop.org/software/systemd/man/machine-id.html
# see https://www.freedesktop.org/software/systemd/man/systemd-machine-id-setup.html
echo "*** Reset the machine-id"
sudo echo '' > /etc/machine-id
sudo rm -f /var/lib/dbus/machine-id > /dev/null

# cleanup
echo "*** Cleanup"
DEBIAN_FRONTEND="noninteractive" sudo apt-get -y autoremove > /dev/null
DEBIAN_FRONTEND="noninteractive" sudo apt-get -y autoclean > /dev/null
sudo rm -rf /var/log > /dev/null
history -c

echo "*** Finished fixes"
