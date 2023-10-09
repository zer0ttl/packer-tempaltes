
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

# LogWrite "Calling openssh"
# Invoke-Expression "f:\openssh.ps1 -AutoStart"
