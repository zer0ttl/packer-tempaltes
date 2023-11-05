:: REG ADD HKLM\Software\Microsoft\Windows\CurrentVersion\WSMAN\Service /v allow_unencrypted /t REG_DWORD /d 1 /f
:: REG ADD HKLM\Software\Microsoft\Windows\CurrentVersion\WSMAN\Service /v auth_basic /t REG_DWORD /d 1 /f
:: REG ADD HKLM\Software\Microsoft\Windows\CurrentVersion\WSMAN\Client /v auth_basic /t REG_DWORD /d 1 /f

:: netsh advfirewall firewall set rule group="File and Printer Sharing" new enable=yes
:: netsh advfirewall firewall set rule name="OpenSSH Server (sshd)" new action=allow

netsh advfirewall firewall set rule name="OpenSSH SSH Server (sshd)" new action=allow

:: wmic useraccount where "name='vagrant'" set PasswordExpires=FALSE

:: %windir%\System32\WindowsPowerShell\v1.0\powershell.exe -Command Set-NetFirewallRule -Name "*ssh*" -Enabled True

%windir%\System32\WindowsPowerShell\v1.0\powershell.exe -Command Set-NetConnectionProfile -Name "Network" -NetworkCategory "Private"

:: slmgr.vbs will run silently
%windir%\System32\wscript.exe /b "%windir%\System32\slmgr.vbs" /rearm