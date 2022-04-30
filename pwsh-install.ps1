Set-ExecutionPolicy Bypass -Scope Process -Force

Invoke-Expression "& {$(Invoke-RestMethod 'https://aka.ms/install-powershell.ps1')} -Quiet -UseMSI"