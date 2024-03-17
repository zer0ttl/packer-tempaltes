# Install Spice Tools
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

# Spice Tools
$SpiceAgentURL = "https://www.spice-space.org/download/windows/spice-guest-tools/spice-guest-tools-latest.exe"
Invoke-WebRequest -Uri $SpiceAgentURL -OutFile "$env:temp\spice-guest-tools-latest.exe"

Write-Host "Importing Red Hat Certificate..."
$cert = (Get-AuthenticodeSignature "F:\Balloon\2k22\amd64\blnsvr.exe").SignerCertificate
[System.IO.File]::WriteAllBytes("${env:TEMP}\redhat.cer", $cert.Export([System.Security.Cryptography.X509Certificates.X509ContentType]::Cert))
certutil.exe -f -addstore "TrustedPublisher" "${env:TEMP}\redhat.cer"

Write-Host "Installing Spice Tools"
Start-Process -FilePath "$env:temp\spice-guest-tools-latest.exe" -ArgumentList "/S" -Wait

Write-Host "Starting service spice-agent"
Start-Service -Name "vdservice"

Write-Host "Installation of Spice Tools complete"
