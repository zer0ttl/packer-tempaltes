:: REG ADD HKLM\Software\Microsoft\Windows\CurrentVersion\WSMAN\Service /v allow_unencrypted /t REG_DWORD /d 1 /f
:: REG ADD HKLM\Software\Microsoft\Windows\CurrentVersion\WSMAN\Service /v auth_basic /t REG_DWORD /d 1 /f
:: REG ADD HKLM\Software\Microsoft\Windows\CurrentVersion\WSMAN\Client /v auth_basic /t REG_DWORD /d 1 /f

:: File and Printer Sharing
:: netsh advfirewall firewall set rule group="File and Printer Sharing" new enable=yes

:: Winrm: Windows Remote Management (HTTP-In)
netsh advfirewall firewall set rule name="Windows Remote Management (HTTP-In)" new enable=yes
netsh advfirewall firewall set rule name="Windows Remote Management (HTTP-In)" new action=allow

:: OpenSSH: OpenSSH SSH Server (sshd)
netsh advfirewall firewall set rule name="OpenSSH SSH Server (sshd)" new action=allow

:: wmic useraccount where "name='vagrant'" set PasswordExpires=FALSE

:: Set Connection Profile to Private for WinRM
%windir%\System32\WindowsPowerShell\v1.0\powershell.exe -Command Set-NetConnectionProfile -Name "Network" -NetworkCategory "Private"

:: slmgr.vbs will run silently to rearm the 90 days evaluation period
%windir%\System32\wscript.exe /b "%windir%\System32\slmgr.vbs" /rearm