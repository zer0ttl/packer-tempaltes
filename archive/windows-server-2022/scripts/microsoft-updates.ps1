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

# Install Powershell module for windows updates
Install-PackageProvider -Name NuGet -Force
Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
Install-Module -Name PSWindowsUpdate

# Check for updates from Microsoft (in addition to Windows updates)
Add-WUServiceManager -ServiceID "7971f918-a847-4430-9279-4a52d1efe18d" -AddServiceFlag 7 -Confirm:$false
