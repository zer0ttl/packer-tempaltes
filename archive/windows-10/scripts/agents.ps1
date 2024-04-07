# Install Virtio Guest Tools
#

Set-StrictMode -Version Latest
$ProgressPreference = 'SilentlyContinue'
$ErrorActionPreference = 'SilentlyContinue'

trap {
    Write-Host
    Write-Host "ERROR: $_"
    ($_.ScriptStackTrace -split '\r?\n') -replace '^(.*)$','ERROR: $1' | Write-Host
    ($_.Exception.ToString() -split '\r?\n') -replace '^(.*)$','ERROR EXCEPTION: $1' | Write-Host
    Write-Host
    Write-Host 'Sleeping for 60m to give you time to look around the virtual machine before self-destruction...'
    Start-Sleep -Seconds (60*60)
    Exit 1
}

# Virtio Windows Guest Tools
# %systemroot%\system32\msiexec.exe /i e:\guest-agent\qemu-ga-x86_64.msi /qn /passive
# %SystemRoot%\System32\cmd.exe /c start /wait e:\virtio-win-guest-tools.exe /q
Write-Host "Installing Virtio Windows Guest Tools"
$Arguments = @(
    "/install"
    "/passive"
    "/norestart"
)
if (Test-Path -Path "e:\virtio-win-guest-tools.exe") {
    Start-Process -FilePath "e:\virtio-win-guest-tools.exe" -Wait -ArgumentList $Arguments -ErrorAction SilentlyContinue
} else {
    Start-Process -FilePath "d:\virtio-win-guest-tools.exe" -Wait -ArgumentList $Arguments -ErrorAction SilentlyContinue
}
# Start-Process -FilePath "e:\virtio-win-guest-tools.exe" -Wait -ArgumentList $Arguments

Write-Host "Starting service QEMU-GA"
Start-Service -Name "QEMU-GA"

# Spice Tools
# https://www.spice-space.org/download/windows/spice-guest-tools/spice-guest-tools-latest.exe
Write-Host "Installing Spice Tools"
$SpiceAgentURL = "https://www.spice-space.org/download/windows/spice-guest-tools/spice-guest-tools-latest.exe"
Invoke-WebRequest -Uri $SpiceAgentURL -OutFile "$env:temp\spice-guest-tools-latest.exe"
#Write-Verbose "SPICE TOOLS" "Installing..."
#Write-Verbose "SPICE TOOLS" "Importing Red Hat Certificate..."
$cert = Import-Certificate "a:\redhat.cer" -CertStoreLocation "Cert:\LocalMachine\TrustedPublisher" -ErrorAction SilentlyContinue
Start-Process -FilePath "$env:temp\spice-guest-tools-latest.exe" -ArgumentList "/S" -Wait -ErrorAction SilentlyContinue
#Write-Verbose "SPICE TOOLS" "Removing Red Hat Certificate..."
Get-childitem "Cert:\LocalMachine\TrustedPublisher" -ErrorAction SilentlyContinue | Where-Object -Property Thumbprint -eq $cert.Thumbprint -ErrorAction SilentlyContinue | Remove-Item -ErrorAction SilentlyContinue
#Write-Verbose "SPICE TOOLS" "Successfully Installed."

Write-Host "Starting service spice-agent"
Start-Service -Name "vdservice"

Write-Host "Installation of virtio and spice agents complete"