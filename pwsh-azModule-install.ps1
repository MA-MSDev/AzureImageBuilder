Get-InstalledModule

Write-Host 'Did PowerShellGet install?'

# Install PowerShell Az Module

Install-Module -Name Az -Repository PSGallery -Force -AllowClobber

Write-Host 'Completed Az Install'
