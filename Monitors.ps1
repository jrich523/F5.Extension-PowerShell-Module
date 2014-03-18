
<#
.Synopsis
   Test to see if monitor template exists
.DESCRIPTION
   
.EXAMPLE
   Test-F5.MonitorTemplate -MonitorName http
#>
function Test-F5.MonitorTemplate
{
    param(
        # Monitor name to check for
        [string]$MonitorName
    )
  

    $template_list = $(Get-F5.iControl).LocalLBMonitor.get_template_list();
    foreach($template in $template_list)
    {
        if ( $template.template_name.Equals($MonitorName) )
        {
            $true
            break
        }
    }
    $false
}

<#
.Synopsis
   This function will create a new HTTP or HTTPS monitor template with the
   specified Send and Receive strings.
.DESCRIPTION
   
.EXAMPLE
   
#>
function New-F5.MonitorTemplate
{
    param(
        # The Name of the monitor template you wish to create.
        [string]$MonitorName,
        #The HTTP Send String.
        [string]$Send,
        #The HTTP Receive String.
        [string]$Receive,
        #The MonitorTemplateType for this template (ie. TTYPE_HTTP, etc).
        [string]$Type
    )
  
    if ( Test-F5.MonitorTemplate -MonitorName $MonitorName )
    {
        Write-Error "Monitor Template '$MonitorName' Already Exists"
    }
    else
    {
        $template = New-Object -TypeName iControl.LocalLBMonitorMonitorTemplate
        $template.template_name = $MonitorName
        $template.template_type = $Type

        $template_attribute = New-Object -TypeName iControl.LocalLBMonitorCommonAttributes
        $template_attribute.parent_template = ""
        $template_attribute.interval = 5
        $template_attribute.timeout = 16
        $template_attribute.dest_ipport = New-Object -TypeName iControl.LocalLBMonitorIPPort
        $template_attribute.dest_ipport.address_type = "ATYPE_STAR_ADDRESS_STAR_PORT"
        $template_attribute.dest_ipport.ipport = New-Object -TypeName iControl.CommonIPPortDefinition
        $template_attribute.dest_ipport.ipport.address = "0.0.0.0"
        $template_attribute.dest_ipport.ipport.port = 0
        $template_attribute.is_read_only = $false
        $template_attribute.is_directly_usable = $true
    
        $(Get-F5.iControl).LocalLBMonitor.create_template(
            (, $template),
            (, $template_attribute)
        )
    
        $StringValues = New-Object -TypeName iControl.LocalLBMonitorStringValue[] 2
        $StringValues[0] = New-Object -TypeName iControl.LocalLBMonitorStringValue
        $StringValues[0].type = "STYPE_SEND"
        $StringValues[0].value = $Send
        $StringValues[1] = New-Object -TypeName iControl.LocalLBMonitorStringValue
        $StringValues[1].type = "STYPE_RECEIVE"
        $StringValues[1].value = $Receive
    
        # Set HTTP Specific attributes
        $(Get-F5.iControl).LocalLBMonitor.set_template_string_property(
            ($MonitorName,$MonitorName),
            $StringValues
        )
    
        Write-Verbose "Monitor '$MonitorName' Succesffully Created"
    }
}


<#
.Synopsis
   This function deletes the specified monitor template.
.DESCRIPTION
   
.EXAMPLE
   Remove-F5.MonitorTemplate http-test
#>
function Remove-F5.MonitorTemplate
{
    #todo: support whatif/force
    param( 
        # The Name of the monitor template you wish to search for.
        [string]$MonitorName 
    )
  
    if ( Test-MonitorTemplate -MonitorName $MonitorName )
    {
        $(Get-F5.iControl).LocalLBMonitor.delete_template( (,$MonitorName) )
        Write-Verbose "Removed Monitor Template '$MonitorName'"
    }
}