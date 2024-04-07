d-i debian-installer/locale string en_US.UTF-8
d-i console-keymaps-at/keymap select us
d-i mirror/country string enter information manually
d-i mirror/http/hostname string http.kali.org
d-i mirror/http/directory string /kali
d-i keyboard-configuration/xkb-keymap select us
d-i mirror/http/proxy string
d-i mirror/suite string kali-last-snapshot
d-i mirror/codename string kali-last-snapshot

d-i clock-setup/utc boolean true
d-i time/zone string GMT

# Disable security, volatile and backports
d-i apt-setup/services-select multiselect 

# Enable contrib and non-free
d-i apt-setup/non-free boolean true
d-i apt-setup/contrib boolean true

# Disable source repositories too
d-i apt-setup/enable-source-repositories boolean false

### Partitioning
d-i partman-auto/method string lvm
d-i partman-auto-lvm/guided_size string max
d-i partman-lvm/device_remove_lvm boolean true
d-i partman-lvm/confirm boolean true
d-i partman-lvm/confirm_nooverwrite boolean true
d-i partman-auto/choose_recipe select atomic
d-i partman-md/confirm boolean true
d-i partman-partitioning/confirm_write_new_label boolean true
d-i partman/choose_partition select finish
d-i partman/confirm boolean true
d-i partman/confirm_nooverwrite boolean true

# remove the following line if swap is needed:
d-i partman-basicfilesystems/no_swap boolean false

# Disable CDROM entries after install
d-i apt-setup/disable-cdrom-entries boolean true

# Upgrade installed packages
#d-i pkgsel/include string openssh-server openvas metasploit-framework metasploit nano openvpn ntpupdate
d-i pkgsel/upgrade select full-upgrade

d-i tasksel/first multiselect ... Xfce (Kali's default desktop environment), ... top 10 -- the 10 most popular tools, ... default -- recommended tools (available in the live system)

# Change default hostname
d-i netcfg/get_hostname string kali
d-i netcfg/get_domain string unassigned-domain

d-i hw-detect/load_firmware boolean false

# User Configuration
d-i passwd/root-login boolean false
d-i passwd/user-fullname string ${build_username}
d-i passwd/username string ${build_username}
d-i passwd/user-password-crypted password ${build_password_encrypted}

d-i apt-setup/use_mirror boolean true
d-i finish-install/reboot_in_progress note
d-i libraries/restart-without-asking boolean true
d-i libpam0g/restart-services string cron

### Boot loader installation
d-i grub-installer/bootdev string default

# Disable popularity-contest
popularity-contest popularity-contest/participate boolean false

kismet kismet/install-setuid boolean false
kismet kismet/install-users string

sslh sslh/inetd_or_standalone select standalone

mysql-server-5.5 mysql-server/root_password_again password
mysql-server-5.5 mysql-server/root_password password
mysql-server-5.5 mysql-server/error_setting_password error
mysql-server-5.5 mysql-server-5.5/postrm_remove_databases boolean false
mysql-server-5.5 mysql-server-5.5/start_on_boot boolean true
mysql-server-5.5 mysql-server-5.5/nis_warning note
mysql-server-5.5 mysql-server-5.5/really_downgrade boolean false
mysql-server-5.5 mysql-server/password_mismatch error
mysql-server-5.5 mysql-server/no_upgrade_when_using_ndb error

d-i preseed/late_command string \
    in-target systemctl start ssh ; \
    in-target systemctl enable ssh ; \
    echo '${build_username} ALL=(ALL) NOPASSWD: ALL' > /target/etc/sudoers.d/${build_username} ; \
    in-target chmod 440 /etc/sudoers.d/${build_username} ; \
    in-target /bin/sh -c "mkdir -p /home/${build_username}/.ssh" ; \
    %{ for key in build_authorized_keys ~}
    in-target /bin/sh -c "echo '${key}' >> /home/${build_username}/.ssh/authorized_keys" ; \
    %{ endfor ~}
    in-target /bin/sh -c "chown -R ${build_username}:${build_username} /home/vagrant/.ssh/" ; \
    in-target /bin/sh -c "chmod 644 /home/vagrant/.ssh/authorized_keys" ; \
    in-target /bin/sh -c "chmod 700 /home/vagrant/.ssh/" ;
