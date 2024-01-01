packer {
  required_plugins {
    qemu = {
      source  = "github.com/hashicorp/qemu"
      version = "~> 1"
    }
    vagrant = {
      source  = "github.com/hashicorp/vagrant"
      version = "~> 1"
    }
  }
}

variable "accelerator" {
  type    = string
  default = "kvm"
}

variable "cpus" { 
  type = string
  description = "Number of CPUs to be assigned to the vm"
  default = "2"
}

variable "disk_size" {
  type    = string
  default = "128000"
}

variable "distro" {
  type          = string
  description   = "Name of the OS distribution"
  default       = "parrotos"
}

variable "headless" {
  type = bool
  description = "Start vm with no gui"
  default = true
}

variable "memory" {
  type = string
  description = "Amount of RAM to be assigned to the vm"
  default = "4096"
}

variable "name" {
  type    = string
  default = "parrotos-5.3"
}

variable "packer_images_output_dir" {
  type    = string
  default = "/tmp/output"
}

variable "packer_templates_logs" {
  type    = string
  default = "/tmp/"
}

variable "parrotos_checksum_url" {
  type    = string
  default = "https://deb.parrot.sh/parrot/iso/5.3/signed-hashes.txt"
  #default = "https://mirror.0xem.ma/parrot/iso/5.3/signed-hashes.txt"
}

variable "parrotos_iso_url" {
  type    = string
  default = "https://deb.parrot.sh/parrot/iso/5.3/Parrot-architect-5.3_amd64.iso"
  #default = "https://mirror.0xem.ma/parrot/iso/5.3/Parrot-architect-5.3_amd64.iso"
}

variable "local_iso_path" {
  type    = string
  default = "/home/sudhir/isos/Parrot-architect-5.3_amd64.iso"
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
  type          = string
  description   = "The command to use to gracefully shut down the vm"
  default       = "echo 'vagrant' | sudo -S /sbin/shutdown -P now"
}

variable "version" {
  type          = string
  description   = "Version of the OS distribution"
  default       = "5.3-Electro-Ara"
}

variable "vnc_vrdp_bind_address" {
  type    = string
  default = "0.0.0.0"
}

variable "vnc_port_max" {
  type    = string
  default = "5959"
  # default is 6000
}

variable "vnc_port_min" {
  type    = string
  default = "5959"
  # default is 5900
}

source "qemu" "parrotos" {
  accelerator             = "${var.accelerator}"
  boot_command            = [
                           "<esc><wait>",
                           "install",
                           " auto=true",
                           " priority=critical",
                           " locale=en_US.UTF-8",
                           " keyboard-configuration/xkb-keymap=us",
                           " preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed.cfg",
                           "<enter>"
                           ]
  boot_wait               = "10s"
  cpus                    = "${var.cpus}"
  disk_size               = "${var.disk_size}"
  headless                = "${var.headless}"
  http_directory          = "./http"
  iso_checksum            = "file:${var.parrotos_checksum_url}"
  iso_urls                = ["${var.parrotos_iso_url}","${var.local_iso_path}"]
  memory                  = "${var.memory}"
  output_directory        = "${var.name}-qemu"
  shutdown_command        = "${var.shutdown_command}"
  ssh_username            = "${var.ssh_username}"
  ssh_password            = "${var.ssh_password}"
  ssh_port                = 22
  ssh_wait_timeout        = "40m"
  vm_name                 = "${var.name}"
  vnc_bind_address        = "${var.vnc_vrdp_bind_address}"
  vnc_port_max            = "${var.vnc_port_max}"
  vnc_port_min            = "${var.vnc_port_min}"
}

build {
  sources = ["source.qemu.parrotos"]

  provisioner "shell" {
    execute_command = "echo 'vagrant' | {{.Vars}} sudo -S  sh {{.Path}}"
    scripts = [
      "scripts/setup-vagrant-user.sh",
      "scripts/spice-agent.sh",
      "scripts/qemu-agent.sh",
      "scripts/network.sh",
      "scripts/fixes.sh",
      "scripts/updates.sh"
    ]
  }

#  provisioner "breakpoint" {}

  post-processor "vagrant" {
    compression_level    = 9
    output               = "${var.name}-{{ .Provider }}.box"
    vagrantfile_template = "Vagrantfile"
  }
}
