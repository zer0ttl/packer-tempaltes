# Some fixes
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

Write-Host "Some fixes.."

# set global EULA acceptance for SysInternals tools
$regPath = "HKCU:\Software\Sysinternals"
if (Test-Path -Path $regPath -ErrorAction SilentlyContinue) {
    Set-ItemProperty -Path $regPath -Name "EulaAccepted" -Value 1 -Force -ErrorAction SilentlyContinue
} else {
    New-Item -Path $regPath -Name "EulaAccepted" -Value 1 -Force -ErrorAction SilentlyContinue
}

# New Network Window Off
# %SystemRoot%\System32\reg.exe add "HKLM\System\CurrentControlSet\Control\Network\NewNetworkWindowOff" /f
# New-Item -Path "HKLM\System\CurrentControlSet\Control\Network\NewNetworkWindowOff" -Force
reg.exe add "HKLM\System\CurrentControlSet\Control\Network\NewNetworkWindowOff" /f

# Show file extensions in Explorer
# %SystemRoot%\System32\reg.exe ADD HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\ /v HideFileExt /t REG_DWORD /d 0 /f
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name HideFileExt -Value 0 -Force

# Show Hidden Files in Explorer
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name Hidden -Value 1 -Force

# Enable QuickEdit Mode
# %SystemRoot%\System32\reg.exe ADD HKCU\Console /v QuickEdit /t REG_DWORD /d 1 /f
Set-ItemProperty -Path "HKCU:\Console" -Name QuickEdit -Value 1 -Force

# Allow ICMP ping in firewall
netsh advfirewall firewall add rule name="ICMP Allow incoming V4 echo request" protocol=icmpv4:8,any dir=in action=allow
netsh advfirewall firewall add rule name="ICMP Allow incoming V6 echo request" protocol=icmpv6:8,any dir=in action=allow

# Set Powershell as default line
New-ItemProperty -Path "HKLM:\SOFTWARE\OpenSSH" -Name DefaultShell -Value "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" -PropertyType String -Force

Write-Host "Finished fixes.."
