Invoke-WebRequest -Uri https://aka.ms/installazurecliwindows -OutFile .\AzureCLI.msi
Start-Process msiexec.exe -Wait -ArgumentList '/I AzureCLI.msi /quiet'
Remove-Item .\AzureCLI.msi

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
