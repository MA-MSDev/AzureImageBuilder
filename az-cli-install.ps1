Invoke-WebRequest -Uri https://aka.ms/installazurecliwindows -OutFile .\AzureCLI.msi
Start-Process msiexec.exe -Wait -ArgumentList '/I AzureCLI.msi /quiet'
Remove-Item .\AzureCLI.msi

Write-Host 'Set NIC'

$nic = Get-AzNetworkInterface -ResourceGroupName 'vz-it-np-h5qv-scs04-eastus2-app-rg' -Name 'vz-it-np-h5qv-scs794'
$nic.DnsSettings.DnsServers.Add('127.0.0.1')
$nic.DnsSettings.DnsServers.Add('159.67.205.1')
$nic | Set-AzNetworkInterface

Write-Host 'Complete NIC setup  + $nic'

winrm enumerate winrm/config/listener


[System.Environment]::SetEnvironmentVariable('HTTP_PROXY', 'http://proxy.ebiz.verizon.com:9290', [System.EnvironmentVariableTarget]::Process)
[System.Environment]::SetEnvironmentVariable('HTTPS_PROXY', 'http://proxy.ebiz.verizon.com:9290', [System.EnvironmentVariableTarget]::Process)
[System.Environment]::SetEnvironmentVariable('NO_PROXY', '169.254.169.254, .verizon.com', [System.EnvironmentVariableTarget]::Process)

dir env:

$URLList = "https://gitlab.verizon.com/scs/azure-acf", "https://oneartifactoryprod.verizon.com/ui/packages"

$result = foreach ($uri in $URLList) {
    try{
        $res = Invoke-WebRequest -Uri $uri -UseDefaultCredentials -UseBasicParsing -Method Head -TimeoutSec 5 -ErrorAction Stop
        $status = [int]$res.StatusCode
    }
    catch {
        $status = [int]$_.Exception.Response.StatusCode.value__
    }
    # output a formatted string to capture in variable $result
    "$status - $uri"
}

# output on screen
$result



#rm .\AzureCLI.msi
