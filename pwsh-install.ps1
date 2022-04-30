Set-ExecutionPolicy Bypass -Scope Process -Force

[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12

Invoke-Expression "& {$(Invoke-RestMethod 'https://aka.ms/install-powershell.ps1' -Proxy 'http://proxy.ebiz.verizon.com:9290')} -Quiet -UseMSI"