# Setup and configure Bginfo.exe
#

Invoke-WebRequest -Uri "https://live.sysinternals.com/Bginfo.exe" -OutFile "C:\Windows\Bginfo.exe"

Copy-Item -Path "a:\bginfo.bgi" -Destination "C:\Windows\bginfo.bgi"

Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" -Name BgInfo -Value "C:\Windows\Bginfo.exe C:\Windows\bginfo.bgi /silent /Timer:0 /nolicprompt" -Force

Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" -Name BgInfo