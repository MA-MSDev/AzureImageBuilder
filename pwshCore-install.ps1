# Run this Chocolatey install first before the rest of the installs

Set-ExecutionPolicy Bypass -Scope Process -Force; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1')) 

# Powershell Core install

choco install powershell-core -y