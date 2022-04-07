Get-InstalledModule

Write-Host 'Did PowerShellGet install?'

# Install PowerShell Az Module

Install-Module -Name Az -Repository PSGallery -AllowClobber -Force

Write-Host 'Completed Az Install'
