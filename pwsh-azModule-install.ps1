[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12

# Install PowerShell Az Module

Install-Module -Name Az -Repository PSGallery -AllowClobber -Force

Write-Host 'Completed Az Install'

Get-InstalledModule

Write-Host 'Confirm Az Module Installed'
