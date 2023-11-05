@REM Allows winrm over public profile interfaces
%windir%\System32\WindowsPowerShell\v1.0\powershell.exe -Command Set-NetFirewallRule -Name "WINRM-HTTP-In-TCP" -RemoteAddress Any

@REM winrm quickconfig -q
%windir%\System32\cmd.exe /c winrm quickconfig -q

@REM winrm quickconfig -transport:http
%windir%\System32\cmd.exe /c winrm quickconfig -transport:http

@REM Win RM MaxTimoutms
%windir%\System32\cmd.exe /c winrm set winrm/config @{MaxTimeoutms="1800000"}

@REM Win RM MaxMemoryPerShellMB
%windir%\System32\cmd.exe /c winrm set winrm/config/winrs @{MaxMemoryPerShellMB="2048"}

@REM Win RM AllowUnencrypted
%windir%\System32\cmd.exe /c winrm set winrm/config/service @{AllowUnencrypted="true"}

@REM Win RM auth Basic
%windir%\System32\cmd.exe /c winrm set winrm/config/service/auth @{Basic="true"}

@REM Win RM client auth Basic
%windir%\System32\cmd.exe /c winrm set winrm/config/client/auth @{Basic="true"}

@REM Win RM listener Address/Port
%windir%\System32\cmd.exe /c winrm set winrm/config/listener?Address=*+Transport=HTTP @{Port="5985"}

@REM Win RM port open
%windir%\System32\cmd.exe /c netsh firewall add portopening TCP 5985 "Port 5985"

@REM Stop Win RM Service
%windir%\System32\cmd.exe /c net stop winrm

@REM Win RM Autostart
%windir%\System32\cmd.exe /c sc config winrm start= auto

@REM Start Win RM Service
%windir%\System32\cmd.exe /c net start winrm