# Confirm Az Module install

pwsh -Command {Get-InstalledModule

Write-Host 'Confirm Az Module Installed'

Install-Module -Name PSWindowsUpdate -Repository PSGallery -Force -AllowClobber

Get-InstalledModule}
