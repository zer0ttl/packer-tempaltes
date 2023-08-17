# packer-tempaltes

This repo contains code to build Vagrant box images for VirtualBox provider using Packer.

Vagrant boxes built with these packer templates are available at: https://app.vagrantup.com/zer0ttl/

## Prerequisites

* Packer - www.packer.io
* Vagrant - www.vagrantup.com
* Virtualbox - https://www.virtualbox.org

## Usage

`git clone https://github.com/zer0ttl/packer-templates.git`

```bash
cd parrot-os
packer build -var-file=variables.pkvars.hcl parrotos.pkr.hcl
```

This will output a `parrotos-5.3-Electro-Ara-x64-virtualbox.box` file in your current directory.

Add this box to Vagrant using the following:

```bash
vagrant box add --name parrot-5.3 parrotos-5.3-Electro-Ara-x64-virtualbox.box
```

Create a new Vagrant file using `touch Vagrantfile` or `vagrant init parrotos-5.3`.

You can then use the newly added box to spin up a vm with VirtualBox using `vagrant up`.

## Vagrantfiles

```ruby
Vagrant.configure("2") do |config|
  config.vm.box = "parrotos-5.3"
  config.vm.guest = "debian"
end
```

## Changelog

## Contributing

1. Fork it!
2. Create your feature branch: `git checkout -b my-new-feature`
3. Commit your changes: `git commit -am 'Add some feature'`
4. Push to the branch: `git push origin my-new-feature`
5. Submit a pull request :D


