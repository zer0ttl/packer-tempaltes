# packer setup
packer {
  required_plugins {
    ansible = {
      source  = "github.com/hashicorp/ansible"
      version = "~> 1"
    }
    qemu = {
      source  = "github.com/hashicorp/qemu"
      version = "~> 1"
    }
    vagrant = {
      source  = "github.com/hashicorp/vagrant"
      version = "~> 1"
    }
    windows-update = {
      version = "0.15.0"
      source = "github.com/rgl/windows-update"
    }
  }
}

# variables
variable "accelerator" {
  type    = string
  default = "kvm"
}

variable "autounattend" {
  type    = string
  default = "http/Autounattend.xml"
}

variable "boot_wait" {
  type    = string
  default = "60s"
}

variable "cpus" {
  type    = string
  default = "2"
}

variable "disk_size" {
  type    = string
  default = "128000"
}

variable "headless" {
  type    = string
  default = "true"
}

variable "iso_checksum" {
  type    = string
  default = "iso.sha256"
}

variable "iso_url" {
  type    = string
  default = "/home/sudhir/isos/19045.2006.220908-0225.22h2_release_svc_refresh_CLIENTENTERPRISEEVAL_OEMRET_x64FRE_en-us.iso"
}

variable "memory" {
  type    = string
  default = "8192"
}

variable "name" {
  type    = string
  default = "windows-10-ent"
}

variable "packer_images_output_dir" {
  type    = string
  default = "output-ent"
}

variable "ssh_private_key_file" {
  type    = string
  default = "vagrant-key"
}

variable "shutdown_wait_timeout" {
  type    = string
  default = "15m"
}

variable "ssh_username" {
  type    = string
  default = "vagrant"
}

variable "ssh_password" {
  type    = string
  default = "vagrant"
}

variable "ssh_wait_timeout" {
  type    = string
  default = "5h"
}

variable "unattend" {
  type    = string
  default = "scripts/unattend.xml"
}

variable "virtio_win_iso" {
  type    = string
  default = "https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/archive-virtio/virtio-win-0.1.240-1/virtio-win.iso"
}

variable "winrm_password" {
  type    = string
  default = "vagrant"
}

variable "winrm_timeout" {
  type    = string
  default = "30m"
}

variable "winrm_username" {
  type    = string
  default = "vagrant"
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

# sources
source "qemu" "windows-10-ent" {
  accelerator         = "${var.accelerator}"
  boot_wait           = "${var.boot_wait}"
  communicator        = "ssh"
  cpus                = "${var.cpus}"
  disk_interface      = "virtio"
  disk_size           = "${var.disk_size}"
  floppy_files        = [
                           "${var.autounattend}",
                           "${var.unattend}",
                           "scripts/post-setup.ps1",
                           "scripts/opensshv2.ps1",
                           "scripts/SetupComplete.cmd",
                           "scripts/sysprep.bat",
                           "scripts/configure-power.ps1",
                           "scripts/disable-uac.ps1",
                           "scripts/enable-file-sharing.ps1",
                           "scripts/enable-remote-desktop.ps1",
                           "scripts/enable-win-updates.ps1",
                           "scripts/update-windows.ps1",
                           "scripts/bginfo.bgi",
                           "scripts/bginfo.ps1",
                           "scripts/agents.ps1",
                           "scripts/redhat.cer",
                           "scripts/fixes.ps1"
                        ]
  format              = "qcow2"
  headless            = "${var.headless}"
  iso_checksum        = "file:${var.iso_checksum}"
  iso_urls            = ["${var.iso_url}"]
  net_device          = "virtio-net"
  qemuargs            = [
                           ["-cdrom", "${var.virtio_win_iso}"]
                        ]
  memory              = "${var.memory}"
  output_directory    = "${var.packer_images_output_dir}"
  shutdown_command    = "a:\\sysprep.bat"
  shutdown_timeout    = "${var.shutdown_wait_timeout}"
  ssh_private_key_file = "${var.ssh_private_key_file}"
  ssh_username        = "${var.ssh_username}"
  ssh_wait_timeout    = "${var.ssh_wait_timeout}"
  vm_name             = "${var.name}"
  vnc_bind_address    = "${var.vnc_vrdp_bind_address}"
  vnc_port_max        = "${var.vnc_port_max}"
  vnc_port_min        = "${var.vnc_port_min}"
  winrm_password      = "${var.winrm_password}"
  winrm_timeout       = "${var.winrm_timeout}"
  winrm_username      = "${var.winrm_username}"
}

# builds
build {
  sources = [
    "source.qemu.windows-10-ent"
  ]

  provisioner "powershell" {
    elevated_user        = "${var.ssh_username}"
    elevated_password    = "${var.ssh_password}"
    scripts = [
      "scripts/bginfo.ps1",
      "scripts/agents.ps1",
      "scripts/fixes.ps1",
      "scripts/configure-power.ps1",
      "scripts/disable-uac.ps1",
      "scripts/enable-file-sharing.ps1",
      "scripts/enable-remote-desktop.ps1",
      "scripts/post-setup.ps1"
    ]
  }
  
  post-processor "vagrant" {
    keep_input_artifact  = false
    compression_level    = 9
    output               = "${var.name}-{{.Provider}}.box"
    # vagrantfile_template = "Vagrantfile"
  }

}
