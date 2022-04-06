[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12

# Install PowerShell Az Module

Install-Module -Name Az -Repository PSGallery -AllowClobber -AllowPrerelease -Force -Confirm:$false
