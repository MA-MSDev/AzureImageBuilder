# First, validate that option to provision Azure VMAgent was not set on VM deployment. You can do that by using PowerShell commands below;

 $vm = Get-AzureRmVM -ResourceGroupName Repro -Name Repro-VMD-VM4
 $vm.OSProfile.WindowsConfiguration.ProvisionVMAgent
 $vm.OSProfile.AllowExtensionOperations

#  Next is to enable extensions operation. Since the Azure VMAgent was not provisioned on deployment and the Azure VMAgent is needed for extensions, the option to allow extension operations is not enable. You can enable this option by using PowerShell commands below;

 $vm.OSProfile.AllowExtensionOperations = $true
 $vm | Update-AzureRmVM