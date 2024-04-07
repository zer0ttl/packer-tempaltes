# #!/bin/sh -eux

echo 'vagrant' | sudo -S -v

date > /etc/vagrant_box_build_time

mkdir /home/vagrant/.ssh
wget --no-check-certificate \
    'https://raw.githubusercontent.com/hashicorp/vagrant/main/keys/vagrant.pub' \
    -O /home/vagrant/.ssh/authorized_keys
chown -R vagrant /home/vagrant/.ssh
chmod -R go-rwsx /home/vagrant/.ssh

echo 'vagrant ALL=(ALL) NOPASSWD:ALL' >/etc/sudoers.d/99_vagrant
chmod 440 /etc/sudoers.d/99_vagrant