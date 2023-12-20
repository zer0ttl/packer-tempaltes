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

# Variables
variable "accelerator" {
  type    = string
  default = "kvm"
}

variable "cpus" {
  type    = string
  default = "4"
}

variable "disk_size" {
  type    = string
  default = "25600"
}

variable "headless" {
  type    = string
  default = "true"
}

variable "memory" {
  type    = string
  default = "4096"
}

variable "name" {
  type    = string
  default = "ubuntu-server-22.04"
}

variable "packer_images_output_dir" {
  type    = string
  default = "/tmp/output"
}

variable "packer_templates_logs" {
  type    = string
  default = "/tmp/"
}

variable "ssh_password" {
  type    = string
  default = "toor"
}

variable "ssh_username" {
  type    = string
  default = "root"
}

variable "ubuntu_checksum_url" {
  type    = string
  default = "https://releases.ubuntu.com/22.04.3/SHA256SUMS"
}

variable "ubuntu_iso_url" {
  type    = string
   default = "https://releases.ubuntu.com/22.04.3/ubuntu-22.04.3-live-server-amd64.iso"
}

variable "local_iso_path" {
  type    = string
  default = "/path/to/your/local/iso/repository"
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

source "qemu" "ubuntu-server-2204" {
  accelerator      = "${var.accelerator}"
  boot_command     = [
        "<wait>c<wait>set gfxpayload=keep<enter><wait>linux /casper/vmlinuz quiet autoinstall ds=nocloud-net\\;s=http://{{.HTTPIP}}:{{.HTTPPort}}/ ---<enter><wait>initrd /casper/initrd<wait><enter><wait>boot<enter>"
                     ]
  boot_wait        = "10s"
  cpus             = "${var.cpus}"
  disk_size        = "${var.disk_size}"
  headless         = "${var.headless}"
  http_directory   = "http"
  iso_checksum     = "file:${var.ubuntu_checksum_url}"
  iso_urls         = ["${var.ubuntu_iso_url}"]
  memory           = "${var.memory}"
  output_directory = "${var.name}-qemu"
  shutdown_command = "echo 'vagrant' | sudo -S shutdown -P now"
  ssh_password     = "${var.ssh_password}"
  ssh_timeout      = "1h"
  ssh_username     = "${var.ssh_username}"
  vm_name          = "${var.name}"
  vnc_bind_address = "${var.vnc_vrdp_bind_address}"
  vnc_port_max     = "${var.vnc_port_max}"
  vnc_port_min     = "${var.vnc_port_min}"
}

build {
  sources = ["source.qemu.ubuntu-server-2204"]

#  provisioner "file" {
#    destination = "/tmp/cloud.cfg"
#    source      = "scripts/cloud.cfg"
#  }
#

#  provisioner "breakpoint" {}

  provisioner "shell" {
    scripts = [
      "scripts/setup-vagrant-user.sh",
      "scripts/spice-agent.sh",
      "scripts/qemu-agent.sh",
      "scripts/updates.sh"
    ]
    expect_disconnect = true
  }


#  provisioner "breakpoint" {}

  provisioner "shell" {
    scripts = [
      "scripts/fixes.sh"
    ]
    expect_disconnect = true
  }

  post-processor "vagrant" {
    compression_level    = 9
    output               = "${var.name}-{{ .Provider }}.box"
    vagrantfile_template = "Vagrantfile"
  }
}
