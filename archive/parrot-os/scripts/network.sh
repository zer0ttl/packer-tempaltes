#!/bin/bash
#
# Some network config

# Disable IPv6 for the current boot.
sysctl net.ipv6.conf.all.disable_ipv6=1 > /dev/null

# Ensure IPv6 stays disabled.
printf "\nnet.ipv6.conf.all.disable_ipv6 = 1\n" >> /etc/sysctl.conf

cat <<-EOF > /etc/netplan/01-netcfg.yaml
network:
  version: 2
  renderer: networkd
  ethernets:
    eth0:
      dhcp4: true
      dhcp6: false
      optional: true
      nameservers:
        addresses: [1.1.1.1, 1.0.0.1]
EOF

truncate -s 0 /etc/netplan/00-installer-config.yaml > /dev/null
cat <<-EOF > /etc/netplan/00-installer-config.yaml
network:
  ethernets:
    all:
      dhcp4: true
      match:
        name: 'eth*'
  version: 2
EOF

# Apply the network plan configuration.
netplan generate > /dev/null

# Ensure a nameserver is being used that won't return an IP for non-existent domain names.
sed -i -e "s/#DNS=.*/DNS=1.1.1.1 1.0.0.1/g" /etc/systemd/resolved.conf > /dev/null
sed -i -e "s/#FallbackDNS=.*/FallbackDNS=/g" /etc/systemd/resolved.conf > /dev/null
sed -i -e "s/#Domains=.*/Domains=/g" /etc/systemd/resolved.conf > /dev/null
sed -i -e "s/#DNSSEC=.*/DNSSEC=yes/g" /etc/systemd/resolved.conf > /dev/null
sed -i -e "s/#Cache=.*/Cache=yes/g" /etc/systemd/resolved.conf > /dev/null
sed -i -e "s/#DNSStubListener=.*/DNSStubListener=yes/g" /etc/systemd/resolved.conf > /dev/null

# Install ifplugd so we can monitor and auto-configure nics.
apt-get --assume-yes install ifplugd > /dev/null

# Configure ifplugd to monitor the eth0 interface.
sed -i -e 's/INTERFACES=.*/INTERFACES="eth0"/g' /etc/default/ifplugd > /dev/null

# Ensure the networking interfaces get configured on boot.
systemctl --quiet enable systemd-networkd.service > /dev/null

# Ensure ifplugd also gets started, so the ethernet interface is monitored.
systemctl --quiet enable ifplugd.service > /dev/null

# Ref: https://github.com/chef/bento/blob/main/packer_templates/scripts/ubuntu/networking_ubuntu.sh
# Ref: https://github.com/lavabit/robox/blob/master/scripts/ubuntu2204/network.sh