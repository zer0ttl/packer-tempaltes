#!/bin/bash
#
# Some common fixes

# To allow for automated installs, we disable interactive configuration steps.
export DEBIAN_FRONTEND=noninteractive
export DEBCONF_NONINTERACTIVE_SEEN=true

echo "*** Running fixes.sh"

# https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=751636
apt-get --assume-yes install libpam-systemd

# set GRUB_TIMEOUT to 0
sudo sed -i "s/^GRUB_TIMEOUT=[0-9]*/GRUB_TIMEOUT=0/" /etc/default/grub
sudo update-grub

# disable root login using password
echo "*** Disable root login using password"
passwd -l root
sed -i 's/PermitRootLogin.*/PermitRootLogin no/g' /etc/ssh/sshd_config

# install resolvconf
sudo apt-get -y install resolvconf

# install rsyslog
sudo apt-get -y install rsyslog

# never blank, put to sleep or switch off monitor
# for current user
xfconf-query -c xfce4-power-manager -p /xfce4-power-manager/dpms-enabled -s false
xfconf-query -c xfce4-power-manager -p /xfce4-power-manager/blank-on-ac -s 0


# disable upgrade popup and unattended upgrades
echo "*** Disable upgrade popup and unattended upgrades"
#sed -i 's/Prompt=.*/Prompt=never/' /etc/update-manager/release-upgrades
apt-get --assume-yes --purge remove update-notifier unattended-upgrades  > /dev/null

# disable apt-daily
echo "*** Disable apt-daily"
systemctl --quiet stop apt-daily.timer
systemctl --quiet stop apt-daily-upgrade.timer
systemctl --quiet disable apt-daily.timer
systemctl --quiet disable apt-daily-upgrade.timer
systemctl daemon-reload

# reset the machine-id.
# NB systemd will re-generate it on the next boot.
# NB machine-id is indirectly used in DHCP as Option 61 (Client Identifier), which
#    the DHCP server uses to (re-)assign the same or new client IP address.
# see https://www.freedesktop.org/software/systemd/man/machine-id.html
# see https://www.freedesktop.org/software/systemd/man/systemd-machine-id-setup.html
echo "*** Reset the machine-id"
echo '' > /etc/machine-id
rm -f /var/lib/dbus/machine-id > /dev/null

# Remove the random seed so a unique value is used the first time the box is booted.
systemctl --quiet is-active systemd-random-seed.service && systemctl stop systemd-random-seed.service
[ -f /var/lib/systemd/random-seed ] && rm --force /var/lib/systemd/random-seed

# cleanup
echo "*** Cleanup"
apt-get --assume-yes autoremove > /dev/null
apt-get --assume-yes autoclean > /dev/null
rm -rf /var/log > /dev/null
history -c > /dev/null

echo "*** Finished fixes"
