:: Disable firewall rules to avoid vagrant connecting to box before inital boot (post sysprep) is completed

:: Winrm
netsh advfirewall firewall set rule name="Windows Remote Management (HTTP-In)" new action=block
:: OpenSSH
netsh advfirewall firewall set rule name="OpenSSH SSH Server (sshd)" new action=block

@REM Run Sysprep
%WINDIR%\System32\Sysprep\sysprep.exe /generalize /oobe /shutdown /unattend:A:\unattend.xml