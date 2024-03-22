:: Winrm: Windows Remote Management (HTTP-In)
netsh advfirewall firewall set rule group="Windows Remote Management" new enable=yes
netsh advfirewall firewall set rule name="Windows Remote Management (HTTP-In)" new enable=yes action=allow

:: OpenSSH: OpenSSH SSH Server (sshd)
netsh advfirewall firewall set rule name="OpenSSH SSH Server (sshd)" new action=allow

:: slmgr.vbs will run silently to rearm the 90 days evaluation period
%windir%\System32\wscript.exe /b "%windir%\System32\slmgr.vbs" /rearm