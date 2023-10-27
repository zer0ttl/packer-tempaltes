# make sure that OpenSSH is available
$OpenSSHServer = $(Get-WindowsCapability -Online | Where-Object Name -like 'OpenSSH.Server*').Name
$OpenSSHClient = $(Get-WindowsCapability -Online | Where-Object Name -like 'OpenSSH.Client*').Name

# Install the OpenSSH Client
Add-WindowsCapability -Online -Name $OpenSSHClient

# Install the OpenSSH Server
Add-WindowsCapability -Online -Name $OpenSSHServer

# Start the sshd service
Start-Service sshd

# OPTIONAL but recommended:
Set-Service -Name sshd -StartupType 'Automatic'

# Confirm the Firewall rule is configured. It should be created automatically by setup. Run the following to verify
if (!(Get-NetFirewallRule -Name "OpenSSH-Server-In-TCP" -ErrorAction SilentlyContinue | Select-Object Name, Enabled)) {
    Write-Output "Firewall Rule 'OpenSSH-Server-In-TCP' does not exist, creating it..."
    # Do not allow SSH connections as packer will try to provision the box before OS installation is done
    New-NetFirewallRule -Name 'OpenSSH-Server-In-TCP' -DisplayName 'OpenSSH Server (sshd)' -Enabled False -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22
} else {
    Write-Output "Firewall rule 'OpenSSH-Server-In-TCP' has been created and exists."
}

# Set Authentication to public key
((Get-Content -path C:\ProgramData\ssh\sshd_config -Raw) `
-replace '#PubkeyAuthentication yes','PubkeyAuthentication yes' `
-replace '#PasswordAuthentication yes','PasswordAuthentication no' `
-replace 'Match Group administrators','#Match Group administrators' `
-replace 'AuthorizedKeysFile __PROGRAMDATA__/ssh/administrators_authorized_keys','#AuthorizedKeysFile __PROGRAMDATA__/ssh/administrators_authorized_keys') | Set-Content -Path C:\ProgramData\ssh\sshd_config

# Restart after changes
Restart-Service sshd

# force file creation
New-item -Path $env:USERPROFILE -Name .ssh -ItemType Directory -force
# New-item -Path "C:\Users\Administrator" -Name .ssh -ItemType Directory -force

# Copy key
Write-Output "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA6NF8iallvQVp22WDkTkyrtvp9eWW6A8YVr+kz4TjGYe7gHzIw+niNltGEFHzD8+v1I2YJ6oXevct1YeS0o9HZyN1Q9qgCgzUFtdOKLv6IedplqoPkcmF0aYet2PkEDo3MlTBckFXPITAMzF8dJSIFo9D8HfdOV0IAdx4O7PtixWKn5y2hMNG0zQPyUecp4pzC6kivAIhyfHilFR61RGL+GPXQ2MWZWFYbAGjyiYJnAmCP3NOTd0jMZEnDkbUvxhMmBYSdETk1rRgm+R4LOzFUGaHqHDLKLX+FIPKcF96hrucXzcWyLbIbEgE98OHlnVYCzRdK8jlqm8tehUc9c9WhQ== vagrant insecure public key" | Out-File $env:USERPROFILE\.ssh\authorized_keys -Encoding ascii


# Uninstall the OpenSSH Client
# Remove-WindowsCapability -Online -Name $OpenSSHClient

# Uninstall the OpenSSH Server
# Remove-WindowsCapability -Online -Name $OpenSSHServer

# Login Process
# ssh -l administrator@detektlabs.local 192.168.10.150 -v -i ~/.vagrant.d/insecure_private_key