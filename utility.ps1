<#
.Synopsis
   This function will flush the running high level configuration to the 
   /config/bigip.conf file.
.DESCRIPTION
   
.EXAMPLE
   Save-F5.Configuration
#>
function Save-F5.Configuration
{
  $(Get-F5.iControl).SystemConfigSync.save_configuration(
    "/config/bigip.conf",
    "SAVE_HIGH_LEVEL_CONFIG"
  )
  Write-Verbose "Configuration Changes Successfully Saved"
}
