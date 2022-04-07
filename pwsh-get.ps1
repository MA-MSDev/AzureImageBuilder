[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12

Install-Module -Name PackageManagement -Repository PSGallery -Force -AllowClobber

Install-Module -Name PowerShellGet -Repository PSGallery -Force -AllowClobber

Update-Module -Name PowerShellGet

Exit
