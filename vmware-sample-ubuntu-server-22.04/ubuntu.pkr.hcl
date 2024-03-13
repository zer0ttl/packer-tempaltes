/*
    DESCRIPTION:
    Ubuntu Server 22.04 LTS build definition.
*/

packer {
  required_version = ">= 1.10.0"
  required_plugins {
    qemu = {
      source  = "github.com/hashicorp/qemu"
      version = "~> 1"
    }
    vagrant = {
      source  = "github.com/hashicorp/vagrant"
      version = "~> 1"
    }
    ansible = {
      source  = "github.com/hashicorp/ansible"
      version = ">= 1.1.0"
    }
  }
}

locals {
    data_source_content = {
        "/meta-data" = file("${abspath(path.root)}/data/meta-data")
        "/user-data" = templatefile("${abspath(path.root)}/data/user-data.pkrtpl.hcl", {
            vm_guest_os_keyboard = var.vm_guest_os_keyboard
            vm_guest_os_language = var.vm_guest_os_language
        })
    }
}

source "qemu" "ubuntu-server-2204" {

}

build {
  sources = ["source.qemu.ubuntu-server-2204"]
}