# Setup and configure automatic updates
#

Set-StrictMode -Version Latest
$ProgressPreference = 'SilentlyContinue'
$ErrorActionPreference = 'Stop'

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

net stop wuauserv

reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update" /v EnableFeaturedSoftware /t REG_DWORD /d 1 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update" /v IncludeRecommendedUpdates /t REG_DWORD /d 1 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update" /v NoAutoRebootWithLoggedOnUsers /t REG_DWORD /d 1 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update" /v RebootRelaunchTimeoutEnabled /t REG_DWORD /d 0 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v NoAutoRebootWithLoggedOnUsers /t REG_DWORD /d 1 /f

#0 : Auto updates are enabled and the downloaded updates will be installed immediately.
#1 : Automatic updates feature will be disabled. Windows will not check if there are any new updates for installation. However, users can manually initiate update.
#2 : Check for updates, do not download them until user says so.
#3 : Download the updates but do not install.
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update" /v AUOptions /t REG_DWORD /d 0 /f

#0: Automatic Updates is enabled (default).
#1: Automatic Updates is disabled.
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v NoAutoUpdate /t REG_DWORD /d 0 /f

#1: Keep my computer up to date is disabled in Automatic Updates.
#2: Notify of download and installation.
#3: Automatically download and notify of installation.
#4: Automatically download and scheduled installation.
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v AUOptions /t REG_DWORD /d 4 /f

net start wuauserv

# Change your TLS version to 1.2
# Ref: https://devblogs.microsoft.com/powershell/when-powershellget-v1-fails-to-install-the-nuget-provider/
Write-Verbose -Message 'Configure Tls12 and ssl3'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::'ssl3', 'Tls12'

# Install Powershell module for windows updates
Install-PackageProvider -Name NuGet -Force
Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
Install-Module -Name PSWindowsUpdate -Force

# Check for updates from Microsoft (in addition to Windows updates)
Add-WUServiceManager -ServiceID "7971f918-a847-4430-9279-4a52d1efe18d" -AddServiceFlag 7 -Confirm:$false
