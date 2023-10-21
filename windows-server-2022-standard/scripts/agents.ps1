# Install Virtio Guest Tools
#

# Virtio Windows Guest Tools
# %systemroot%\system32\msiexec.exe /i e:\guest-agent\qemu-ga-x86_64.msi /qn /passive
# %SystemRoot%\System32\cmd.exe /c start /wait e:\virtio-win-guest-tools.exe /q
$Arguments = @(
    "/install"
    "/passive"
    "/norestart"
)
Start-Process -FilePath "e:\virtio-win-guest-tools.exe" -Wait -ArgumentList $Arguments

Start-Service -Name "spice-agent"
Start-Service -Name "QEMU-GA"

# Spice Tools
# https://www.spice-space.org/download/windows/spice-guest-tools/spice-guest-tools-latest.exe
$SpiceAgentURL = "https://www.spice-space.org/download/windows/spice-guest-tools/spice-guest-tools-latest.exe"
Invoke-WebRequest -Uri $SpiceAgentURL -OutFile "$env:temp\spice-guest-tools-latest.exe"
#Write-Verbose "SPICE TOOLS" "Installing..."
#Write-Verbose "SPICE TOOLS" "Importing Red Hat Certificate..."
$cert = Import-Certificate "a:\redhat.cer" -CertStoreLocation "Cert:\LocalMachine\TrustedPublisher" -ErrorAction SilentlyContinue
Start-Process -FilePath "$env:temp\spice-guest-tools-latest.exe" -ArgumentList "/S" -Wait -ErrorAction SilentlyContinue
#Write-Verbose "SPICE TOOLS" "Removing Red Hat Certificate..."
Get-childitem "Cert:\LocalMachine\TrustedPublisher" -ErrorAction SilentlyContinue | Where-Object -Property Thumbprint -eq $cert.Thumbprint -ErrorAction SilentlyContinue | Remove-Item -ErrorAction SilentlyContinue
#Write-Verbose "SPICE TOOLS" "Successfully Installed."
