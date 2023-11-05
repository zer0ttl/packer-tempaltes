:: Disable WinRM so Vagrant doesnt trip over on first reboot post sysprep

:: Uncomment below if you dont need basic and unencrypted WinRM, as more secure
:: call winrm set winrm/config/service/auth @{Basic="false"}
:: call winrm set winrm/config/service @{AllowUnencrypted="false"}

:: Disable firewall rule
netsh advfirewall firewall set rule name="OpenSSH SSH Server (sshd)" new action=block

:: %WINDIR%\System32\WindowsPowerShell\v1.0\powershell.exe -Command Set-NetFirewallRule -Name "*ssh*" -Enabled False

%WINDIR%\System32\Sysprep\sysprep.exe /generalize /oobe /shutdown /unattend:A:\unattend.xml