packer {
  required_version = ">= 1.7.0"
  required_plugins {
    vagrant = {
      version = ">= 1.0.2"
      source  = "github.com/hashicorp/vagrant"
    }
    virtualbox = {
      version = ">= 0.0.1"
      source  = "github.com/hashicorp/virtualbox"
    }
  }
}

variable "iso_checksum" {
  type = string
  description = "Hash for the iso file"
}

variable "iso_url" {
  type = string
  description = "Path for the iso file"
}

variable "guest_os_type" {
  type = string
  description = "Type of the guest OS to be installed in the vm"
}

variable "cpus" { 
  type = string
  description = "Number of CPUs to be assigned to the vm"
  default = "2"
}

variable "memory" {
  type = string
  description = "Amount of RAM to be assigned to the vm"
  default = "2048"
}

variable "ssh_username" {
  type = string
  description = "SSH username"
  default = "vagrant"
}

variable "ssh_password" {
  type = string
  description = "SSH password"
  default = "vagrant"
}

variable "shutdown_command" {
  type = string
  description = "The command to use to gracefully shut down the vm"
}

variable "vrde_address" {
  type = string
  description = "The IP address that should be binded for VRDE for remotely accessing the vm"
}

variable "vrde_port_default" {
  type = string
  description = "Default port for VRDE"
  default = "3389"
}
variable "vrde_port_custom" {
  type = string
  description = "Custom port for VRDE"
}

variable "version" {
  type = string
  description = "Version of the OS distribution"
}

variable "distro" {
  type = string
  description = "Name of the OS distribution"
}

variable "headless" {
  type = bool
  description = "Start vm with no gui"
  default = true
}

variable "virtualbox_version_file" {
  type    = string
  description = "path within the vm to upload a file that contains the VirtualBox version that was used to create the vm"
  default = ".vbox_version"
}

variable "virtualbox_hdd_interface" {
  type = string
}

source "virtualbox-iso" "parrot-os" {
  boot_command = [
    "<down><wait2s><enter>", // install
    "<wait20s><enter>", // langugage
    "<wait2s><enter>", // location
    "<wait2s><enter>", // keyboard
    "<wait1m>", // network config
    "<enter>", // hostname
    "<wait2s><enter>", // domain
    "<wait5s><enter>", // mirror country for parrot archive
    "<wait2s><enter>", // mirror for parrot archive
    "<wait2s><enter>", // proxy for parrot archive
    "<wait5s>vagrant<wait2s><enter>", // full name of user
    "<wait2s><enter>", // username
    "<wait2s>vagrant<wait2s><enter>", // password
    "<wait2s>vagrant<wait2s><enter>", // re-enter password
    "<wait2s><down><down><wait2s><enter>", // time zone
    "<wait20s><down><enter>", // lvm
    "<wait2s><enter>", // use entire disk
    "<wait2s><enter>", // select disk
    "<wait5s><left><enter>", // write changes to disk
    "<wait10s><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs>max<enter>", // disk size
    "<wait5s><left><enter>", // partition disks
    "<wait8m><enter>", // configure package manager
    "<wait2s><enter>", // configure package manager mirror country for parrot archive
    "<wait2s><enter>", // configure package manager mirror for parrot archive
    "<wait2s><enter>", // configure package manager proxy for parrot archive
    "<wait1m>", // software selection
    "<down><down><down><down><down><down><down><down><down><spacebar>", // parrot base system
    "<down><down><spacebar>", // parrot cloud pentest
    "<down><spacebar>", // forensic tools
    "<down><spacebar>", // all parrot security tools
    "<down><spacebar>", // info gathering tools
    "<down><spacebar>", // password tools
    "<down><spacebar>", // post exploitation tools
    "<down><spacebar>", // exploitation tools
    "<down><spacebar>", // reverse eng tools
    "<down><spacebar>", // sniffing and injection tools
    "<down><spacebar>", // vuln assessment tools
    "<down><spacebar>", // web sec tools
    "<wait5s><enter>", // system install; takes 25 mins
    "<wait25m><enter>", // install grub boot loader
    "<down><wait2s><enter>", // device for boot loader
    "<wait2m><enter><wait10s>", // installation complete
  ]
  boot_wait = "10s"
  disk_size = 40000
  guest_additions_path = "VBoxGuestAdditions_{{.Version}}.iso"
  guest_os_type = "${var.guest_os_type}"
  http_directory = "./http"
  iso_checksum = "${var.iso_checksum}"
  iso_url = "${var.iso_url}"
  shutdown_command = "${var.shutdown_command}"
  ssh_username = "${var.ssh_username}"
  ssh_password = "${var.ssh_password}"
  ssh_port = 22
  ssh_wait_timeout = "40m"
  headless = "${var.headless}"
  gfx_vram_size = 128
  hard_drive_interface = "${var.virtualbox_hdd_interface}"
  vboxmanage = [
    ["modifyvm", "{{.Name}}", "--memory", "${var.memory}"],
    ["modifyvm", "{{.Name}}", "--cpus", "${var.cpus}"],
    ["modifyvm", "{{.Name}}", "--vrdeaddress", "${var.vrde_address}"],
    ["modifyvm", "{{.Name}}", "--default-frontend", "headless"],
  ]
}

build {
  sources = ["source.virtualbox-iso.parrot-os"]
  provisioner "shell" {
    execute_command = "echo 'vagrant' | {{.Vars}} sudo -S  sh {{.Path}}"
    scripts = [
      "scripts/base.sh",
      "scripts/vagrant.sh",
      "scripts/ssh.sh",
      "scripts/cleanup.sh",
      "scripts/zerodisk.sh"
    ]
  }

  post-processor "vagrant" {
    output = "${var.distro}-${var.version}-x64-virtualbox.box"
  }
}
