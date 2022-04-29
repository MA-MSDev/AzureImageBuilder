# Set env variables
[System.Environment]::SetEnvironmentVariable('HTTP_PROXY', 'http://proxy.ebiz.verizon.com:9290', [System.EnvironmentVariableTarget]::Process)
[System.Environment]::SetEnvironmentVariable('HTTPS_PROXY', 'http://proxy.ebiz.verizon.com:9290', [System.EnvironmentVariableTarget]::Process)
[System.Environment]::SetEnvironmentVariable('NO_PROXY', '.verizon.com', [System.EnvironmentVariableTarget]::Process)

Set-ExecutionPolicy Bypass -Scope Process -Force

Invoke-Expression "& {$(Invoke-RestMethod 'https://aka.ms/install-powershell.ps1')} -Quiet -UseMSI"