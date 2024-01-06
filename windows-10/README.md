# Windows 10

> SSH is the preferred method as it is easy to ssh into the box with vagrant ssh.

## About

- The `http/ssh/Autounattend.xml` contains minimal config for OpenSSH support. The `Autounattend.xml` sets the following configs:
	- user full name: `Vagrant`
	- org name: `Detekt Labs`
	- image name: `Windows 10 Enterprise Evaluation`
	- installs all `virtio` drivers.
	- username: `vagrant` 
	- password: `vagrant`
	- user added to group: `administrators`
	- Runs the following `FirstLogonCommands`:
		- Set Execution Policy for 64 Bit PowerShell to `RemoteSigned`
		- Set Execution Policy for 32 Bit PowerShell to `RemoteSigned` 
		- Disable password expiration for vagrant user
		- Install OpenSSH using `opensshv2.ps1`
- Once the system has been installed, the following files are run:
	- `post-setup.ps1`: Copies the `SetupComplete.cmd` file for execution on first boot.
- The shutdown command is `a:\\sysprep.bat`
	- This configures the windows firewall to block winrm and ssh to avoid vagrant connecting to box before inital boot (post sysprep) is completed.
	- This then runs `sysprep` with `unattend.xml` which does the following:
		- Sets timezone to UTC.
		- Sets up `vagrant` as administrator with `vagrant` password.
		- Sets computer name to `vagrantvm`.
- SSH config has been tested and a working remote management session can be established with the system.
- A powershell *post-provisioner* runs the script `post-setup.ps1` after OS has been installed on the system.
	- This script copies the `SetupComplete.cmd` to `C:\Windows\setup\scripts\` directory. The contents of this script are run after the first boot post sysprep.
	- This script does the following:
		- Enables and allows winrm in firewall rules.
		- Allows ssh in firewall rules.
		- Sets the connection profile to *Private* for all interfaces.
		- Rearms the license using `slmgr`
- The Packer shutdown command runs the `a:\sysprep.bat` script. This syspreps the image using the `a:\unattend.xml` answer file. It also puts the following two firewall rules in *Block* mode.
	- `Windows Remote Management (HTTP-In)`
	- `OpenSSH SSH Server (sshd)`
	- This is in place to block vagrant from connecting to the box immediately after the box has booted and stops it from messing from the first boot post sysprep.

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

