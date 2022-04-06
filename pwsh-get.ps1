[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12

Install-PackageProvider -Name NuGet -Force

Install-Module -Name PowerShellGet -Force

Update-Module -Name PowerShellGet
Exit
