# You can list the available cmdlets in the module installed using Get-Command:
Get-Command -Module WindowsUpdateProvider

# The command below scans the device for updates that are not already applied to installed software:
$Updates = Start-WUScan -SearchCriteria "Type='Software' AND IsInstalled=0"

# Once you’ve performed a scan, you can use the object we created ($Updates) to install the updates with Install-WUUpdates:
Install-WUUpdates -Updates $Updates