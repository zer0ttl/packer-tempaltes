# Check if C:\temp exists
if(!(Test-Path -Path "C:\temp"))
{
    New-Item -Path c:\ -Name temp -ItemType Directory
}

# Check if cloudbase-init is installed
if (Test-Path -Path "C:\Program Files\Cloudbase Solutions\Cloudbase-Init\conf") {
    cd "C:\Program Files\Cloudbase Solutions\Cloudbase-Init\conf"
} else {
    cd "C:\temp"
    Remove-Item -Path c:\temp\Unattend.xml -ErrorAction SilentlyContinue
    New-Item -Path c:\temp\ -Name Unattend.xml -ItemType File
    Set-Content C:\temp\Unattend.xml '
<?xml version="1.0" encoding="utf-8"?>
<unattend xmlns="urn:schemas-microsoft-com:unattend">
  <settings pass="generalize">
    <component name="Microsoft-Windows-PnpSysprep" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
      <PersistAllDeviceInstalls>true</PersistAllDeviceInstalls>
    </component>
  </settings>
  <settings pass="oobeSystem">
    <component name="Microsoft-Windows-Shell-Setup" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State">
      <OOBE>
        <HideEULAPage>true</HideEULAPage>
        <NetworkLocation>Work</NetworkLocation>
        <ProtectYourPC>1</ProtectYourPC>
        <SkipMachineOOBE>true</SkipMachineOOBE>
        <SkipUserOOBE>true</SkipUserOOBE>
      </OOBE>
    </component>
  </settings>
</unattend>
'
}

Start-Process -FilePath "C:\Windows\System32\sysprep\sysprep.exe" -ArgumentList '/generalize /oobe /shutdown /unattend:C:\Temp\Unattend.xml'

# wait for sysprep to finish
while ($true) { 
    $imageState = Get-ItemProperty HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Setup\State | Select ImageState; 
    if ($imageState.ImageState -ne 'IMAGE_STATE_GENERALIZE_RESEAL_TO_OOBE') { 
        Write-Output $imageState.ImageState; Start-Sleep -s 10  
    } else { 
        break
    } 
}
