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
Write-Host "Installing Virtio Windows Guest Tools"
$Arguments = @(
    "/install"
    "/passive"
    "/norestart"
)
if (Test-Path -Path "f:\virtio-win-guest-tools.exe") {
    Start-Process -FilePath "f:\virtio-win-guest-tools.exe" -Wait -ArgumentList $Arguments
} else {
    Start-Process -FilePath "d:\virtio-win-guest-tools.exe" -Wait -ArgumentList $Arguments
}

Write-Host "Starting service QEMU-GA"
Start-Service -Name "QEMU-GA"

Write-Host "Installation of virtio complete"