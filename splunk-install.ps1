## PRODUCTION ENVIRONMENT WITH SSL ENABLED
 
## msilocation using SystemDrive fails during AMI build process if surrounded by single quotes.
$msilocation = "$env:SystemDrive\X86.Orchestration\Splunk\splunkforwarder-8.0.5-a1a6394cc5ae-x64-release.msi"
$currentversion = "8.0.5"
$install_dir = "C:\Program Files\SplunkUniversalForwarder\"
$Logpath = "$env:SystemDrive\X86.Orchestration\InstallLogs"
$Logfile = "Splunk_Forwarder_Install.log"

####################################################################################################################################################################
# Logging Function
####################################################################################################################################################################
Function Write-Log {
   Param (
    [string]$Level,
    [string]$Message
    )
   $Stamp = (Get-Date).toString("MM/dd/yyyy HH:mm:ss.ff")
   $Line = "$Stamp $Level $Message"
   $Line | Out-File $LogPath\$Logfile -append

}


####################################################################################################################################################################
# Environment Check
# Set Proxy
####################################################################################################################################################################

$token = Invoke-RestMethod -Headers @{"X-aws-ec2-metadata-token-ttl-seconds" = "21600"} -Method PUT -Uri http://169.254.169.254/latest/api/token

$domain = Invoke-RestMethod -Headers @{"X-aws-ec2-metadata-token" = $token} -Method GET -Uri http://169.254.169.254/latest/meta-data/hostname

$domain
If($domain -match ('^' + [regex]::('.ebiz.verizon.com'))){
Set-AWSProxy -Hostname http://proxy.ebiz.verizon.com -Port 80
$env:HTTPS_PROXY="http://proxy.ebiz.verizon.com:80"
Write-Log "Set Proxy to proxy.ebiz.verizon.com"
Write-Host "Set Proxy to proxy.ebiz.verizon.com" -ForegroundColor yellow
}
else{
Set-AWSProxy -Hostname http://vzproxy.verizon.com -Port 80
$env:HTTPS_PROXY="http://vzproxy.verizon.com:80"
Write-Log "Set Proxy to vzproxy.verizon.com"
Write-Host "Set Proxy to vzproxy.verizon.com" -ForegroundColor yellow
}

#Get Splunk Forwarder Status

$service = Get-Service splunkforwarder -ErrorAction SilentlyContinue
if($service.Name -eq 'splunkforwarder'){
Write-Host $service.Name "was found" -ForegroundColor Yellow
Write-Log $service.Name "was found"
}
else{
Write-Host $service.Name "Splunk was not found" -ForegroundColor Yellow
Write-Log $service.Name "Splunk was not found"}


#Splunk Version Check 
if($service.Status -eq 'Running'){
$Version = Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* |  Select-Object DisplayName, DisplayVersion, Publisher, InstallDate | Where-Object {$_.DisplayName -eq 'UniversalForwarder'}
Write-Host $Version.DisplayVersion "Splunk was running" -ForegroundColor Yellow
Write-Log $Version.DisplayVersion "Splunk was running, nothing to install"
}
elseif($service.Status -ne 'Running'){
Get-Service splunk* | Start-Service -ErrorAction SilentlyContinue
Start-Sleep -Seconds 5
$Version = Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* |  Select-Object DisplayName, DisplayVersion, Publisher, InstallDate | Where-Object {$_.DisplayName -eq 'UniversalForwarder'}
Write-Host $Version.DisplayVersion "Splunk was not running" -ForegroundColor Yellow
Write-Log $Version.DisplayVersion "Splunk was not running"
}


if($Version.DisplayVersion -lt $currentversion){
Write-Host $Version.DisplayVersion "Splunk is out of date or not installed, installing latest version" -ForegroundColor Yellow
Write-Log $Version.DisplayVersion "Splunk is out of date or not installed, installing latest version"

$arguments="/qn /norestart /l* $Logpath\$Logfile AGREETOLICENSE=Yes SPLUNKUSERNAME=admin SPLUNKPASSWORD=s7Z683JV5CMH97O3DC!"
Start-Process  -FilePath "$msilocation" -ArgumentList $arguments -Wait

}

Get-Service splunk* | Stop-Service
Stop-Process -name splunkd -Force
Get-Service splunk* | Start-Service


####################################################################################################################################################################
### Sterilization
####################################################################################################################################################################

    Get-Service splunk* | Stop-Service -Force -ErrorAction SilentlyContinue
    Remove-Item "$env:ProgramFiles\SplunkUniversalForwarder\etc\instance.cfg"-ErrorAction SilentlyContinue
    Remove-Item "$env:ProgramFiles\SplunkUniversalForwarder\etc\system\local\server.conf" -ErrorAction SilentlyContinue
    Remove-Item "$env:ProgramFiles\SplunkUniversalForwarder\etc\system\local\inputs.conf" -ErrorAction SilentlyContinue
    Remove-Item "$env:ProgramFiles\SplunkUniversalForwarder\etc\system\local\outputs.conf" -ErrorAction SilentlyContinue
	Remove-Item "$env:ProgramFiles\SplunkUniversalForwarder\etc\system\local\deploymentclient.conf" -ErrorAction SilentlyContinue
    Get-Service splunk* | Start-Service -WarningVariable wv -WarningAction SilentlyContinue
    

$Service = Get-Service splunkforwarder -ErrorAction SilentlyContinue
if ($Service.Status -eq 'Running')
{
#####################################################################################################################################################################
### Get File Length/Size##
#####################################################################################################################################################################

$filelength = (Get-item "$env:SystemRoot\Windows\InstallLogs\Splunk_Forwarder_Install.log" -ErrorAction SilentlyContinue).Length
if($filelength -lt '5'){
Write-Log 'Install File Length too Small'
Exit 0
}
Else{
Write-Host  "Install File Length correct" -ForegroundColor Yellow
write-log 'Install File Length correct'
}

###################################################################################################################################################################### 
##Check HKEY##
######################################################################################################################################################################

$key = (Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*  |  Select-Object PSChildName, DisplayName, DisplayVersion, Publisher, InstallDate | Where-Object {$_.DisplayName -like "UniversalForwarder"}).DisplayName
if($key -like "UniversalForwarder"){
Write-Host  "Found Key" -ForegroundColor Yellow
Write-Log 'Found Key'

}
else{
Write-Host  "Could not find uninstall key in registry" -ForegroundColor Yellow
Write-Log 'Could not find uninstall key in registry'
Exit 1
}
  
  
  Write-Host  "0" -ForegroundColor Yellow
  Exit 0
}
else
{
  Write-Host  "1" -ForegroundColor Yellow
  Exit 1
}
