# Set env variables
[System.Environment]::SetEnvironmentVariable('HTTP_PROXY', 'http://proxy.ebiz.verizon.com:9290', [System.EnvironmentVariableTarget]::Process)
[System.Environment]::SetEnvironmentVariable('HTTPS_PROXY', 'http://proxy.ebiz.verizon.com:9290', [System.EnvironmentVariableTarget]::Process)
[System.Environment]::SetEnvironmentVariable('NO_PROXY', '169.254.169.254, .verizon.com', [System.EnvironmentVariableTarget]::Process)

dir env:

# Get VM Name
$string=$env:USERNAME
$ResourceGroupName = 'vz-it-np-h5qv-scs04-eastus2-acg-rg'
Write-Host 'Longbow $($string)'

$vmName = $string.Substring(0,$string.Length-1)

Write-Host 'LongbowName $($vmName)'

# Login to PS on build vm

Add-AzAccount -identity

# Call Azure Resource Manager to get the service principal ID for the VM's managed identity for Azure resources. 
$vmInfoPs = Get-AzVM -ResourceGroupName $ResourceGroupName -Name $vmName
$spID = $vmInfoPs.Identity.PrincipalId
echo "The managed identity for Azure resources service principal ID is $spID"


# DNS servers
Write-Host 'Set NIC'

$nic = Get-AzNetworkInterface -ResourceGroupName 'vz-it-np-h5qv-scs04-eastus2-app-rg' -Name 'vz-it-np-h5qv-scs794'
$nic.DnsSettings.DnsServers.Add('127.0.0.1')
$nic.DnsSettings.DnsServers.Add('159.67.205.1')
$nic | Set-AzNetworkInterface

Write-Host 'Complete NIC setup  + $($nic)'

# Check WinRM certificates
winrm enumerate winrm/config/listener

# Check URL Access
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
