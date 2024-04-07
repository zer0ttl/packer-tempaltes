%windir%\System32\WindowsPowerShell\v1.0\powershell.exe -Command Set-NetFirewallRule -Name "WINRM-HTTP-In-TCP" -RemoteAddress Any

%windir%\System32\cmd.exe /c winrm quickconfig -q

%windir%\System32\cmd.exe /c winrm quickconfig -transport:http

%windir%\System32\cmd.exe /c winrm set winrm/config @{MaxTimeoutms="1800000"}

%windir%\System32\cmd.exe /c winrm set winrm/config/winrs @{MaxMemoryPerShellMB="2048"}

%windir%\System32\cmd.exe /c winrm set winrm/config/service @{AllowUnencrypted="true"}

%windir%\System32\cmd.exe /c winrm set winrm/config/service/auth @{Basic="true"}

%windir%\System32\cmd.exe /c winrm set winrm/config/client/auth @{Basic="true"}

%windir%\System32\cmd.exe /c winrm set winrm/config/listener?Address=*+Transport=HTTP @{Port="5985"}

%windir%\System32\cmd.exe /c netsh firewall add portopening TCP 5985 "Port 5985"

%windir%\System32\cmd.exe /c net stop winrm

%windir%\System32\cmd.exe /c sc config winrm start= auto

%windir%\System32\cmd.exe /c net start winrm

