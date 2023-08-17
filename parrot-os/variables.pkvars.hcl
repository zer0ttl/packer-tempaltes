iso_checksum = "sha256:93b2d751a4ca4aaf162ce400b66ec3e1b2aaf7cd258909009119323e584f8d46" // architect-edition
iso_url = "https://deb.parrot.sh/parrot/iso/5.3/Parrot-architect-5.3_amd64.iso" // architect-edition

guest_os_type = "Linux_64"
cpus = "4"
memory = "8192"
ssh_username = "vagrant"
ssh_password = "vagrant"
shutdown_command = "echo 'vagrant' | sudo -S /sbin/shutdown -P now"

version = "5.3-Electro-Ara"
distro = "parrotos"

vrde_address = "0.0.0.0"
vrde_port_custom = "5959"
vrde_port_default = "3389"
headless = true

virtualbox_version_file = ".vbox_version"
virtualbox_hdd_interface = "sata"