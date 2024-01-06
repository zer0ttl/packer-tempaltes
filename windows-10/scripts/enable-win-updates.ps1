# Setup and configure Bginfo.exe
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

$Logfile = "C:\Windows\Temp\win-updates.log"
$RegistryKey = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"
$RegistryEntry = "InstallWindowsUpdates"
$ScriptPath = $MyInvocation.MyCommand.Path

function LogWrite {
   Param ([string]$logstring)
   $now = Get-Date -format s
   Add-Content $Logfile -value "$now $logstring"
   Write-Host $logstring
}

Do {
    LogWrite "Looking For Updates"
	$updates = Get-WUInstall -MicrosoftUpdate -IgnoreReboot
	LogWrite $updates
	if (!$updates) {
		LogWrite "No More Updates"
		break
	}
	if (!(Compare-Object $updates $prevUpdates)) {
	    LogWrite "Updates Did Not Install - Aborting"
	    break
	}
	LogWrite "Installing Updates"
	Install-WindowsUpdate -MicrosoftUpdate -IgnoreUserInput -AcceptAll -IgnoreReboot
	LogWrite "Updates Installed, Checking Reboot Status"
	$rebootRequired = Get-WURebootStatus -Silent
	if ($rebootRequired) {
        Set-ItemProperty -Path $RegistryKey -Name $RegistryEntry -Value "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -File $($ScriptPath)"
		LogWrite "Restart Required - Restarting..."
		Restart-Computer
		sleep 5
	}
	$prevUpdates = $updates
} While ($true)

$prop = (Get-ItemProperty $RegistryKey).$RegistryEntry
if ($prop) {
    LogWrite "Restart Registry Entry Exists - Removing It"
    Remove-ItemProperty -Path $RegistryKey -Name $RegistryEntry -ErrorAction SilentlyContinue
}
