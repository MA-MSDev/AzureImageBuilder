# Confirm Az Module install

Get-InstalledModule

Write-Host 'Confirm Az Module Installed'

Install-Module -Name PSWindowsUpdate -Repository PSGallery -Force -AllowClobber
