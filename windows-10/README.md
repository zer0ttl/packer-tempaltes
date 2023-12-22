# Windows 10

## Usage

- Validate the packer templates.

```bash
packer validate windows-10-ent-ssh.pkr.hcl
packer validate windows-10-ent-minimal-ssh.pkr.hcl
packer validate windows-10-ent-winrm.pkr.hcl
packer validate windows-10-ent-minimal-winrm.pkr.hcl
packer validate windows-10-ent.pkr.hcl
```

- Buil the required packer template.

```bash
packer buid -on-error=ask windows-10-ent-ssh.pkr.hcl
packer buid -on-error=ask windows-10-ent-minimal-ssh.pkr.hcl
packer buid -on-error=ask windows-10-ent-winrm.pkr.hcl
packer buid -on-error=ask windows-10-ent-minimal-winrm.pkr.hcl
packer buid -on-error=ask windows-10-ent.pkr.hcl
```

- Generate the `metadata.json` files to be used with `vagrant box add`.

```bash
./box-metadata.sh windows-10-ssh.box
./box-metadata.sh windows-10-minimal-ssh.box
./box-metadata.sh windows-10-winrm.box
./box-metadata.sh windows-10-minimal-winrm.box
./box-metadata.sh windows-10-ent.box
```

- Add the required vagrant boxes.

```bash
vagrant box add metadata-windows-10-ssh.json
vagrant box add metadata-windows-10-minimal-ssh.json
vagrant box add metadata-windows-10-winrm.json
vagrant box add metadata-windows-10-minimal-winrm.json
vagrant box add metadata-windows-10-ent.json
```

- Use the provided `Vagrantfile` to run a vm.

```bash
mkdir windows10vm && cd $_
touch Vagrantfile
#copy contents to the Vagrantfile
vagrant up
```

![Alt text](<screenshot-vagrant-up.png>)

![Alt text](<screenshot-vm.png>)

## Packer Templates

| Template Name | Description |
| -- | -- |
| `windows-10-ent-ssh.pkr.hcl` | Uses SSH as communicator, installs qemu & spice agents, runs fixes. |
| `windows-10-ent-minimal-ssh.pkr.hcl` | Minimal SSH config for communication. No additional software or config installed |
| `windows-10-ent-winrm.pkr.hcl` | Uses winrm as communicator, installs qemu & spice agents, runs fixes. |
| `windows-10-ent-minimal-winrm.pkr.hcl` | Minimal winrm config for communication. No additional software or config installed |
| `windows-10-ent.pkr.hcl` | Uses SSH and winrm as communicator, installs qemu & spice agents, runs fixes. |

## Vagrantfiles

| File | Description |
| -- | -- |
| `Vagrantfile` | Uses winrm or ssh as communicator |
| `Vagrantfile-ssh` | Uses ssh as communicator |
| `Vagrantfile-winrm` | Uses winrm as communicator |

