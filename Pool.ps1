<#
.Synopsis
   Create a new pool
.DESCRIPTION
   
.EXAMPLE
   New-F5.Pool -PoolName Pool_www_80 -MemberList ('1.2.3.4','1.2.3.5') -MemberPort 80
#>
function New-F5.Pool
{
    #todo: allow method to be set rather than assuming RR
    
    param(
        # Name of the pool to create
        [string]$PoolName,
        # Members to add to that pool
        [string[]]$MemberList,
        # Port for the members to use
        [int]$MemberPort
    )

    $IPPortDefList = New-Object -TypeName iControl.CommonIPPortDefinition[] $MemberList.Length;
    for($i=0; $i-lt$MemberList.Length; $i++)
    {
        $IPPortDefList[$i] = New-Object -TypeName iControl.CommonIPPortDefinition;
        $IPPortDefList[$i].address = $MemberList[$i];
        $IPPortDefList[$i].port = $MemberPort;
    }
    
    $(Get-F5.iControl).LocalLBPool.create(
        (,$PoolName),
        (,"LB_METHOD_ROUND_ROBIN"),
        (,$IPPortDefList)
    )
 
}


<#
.Synopsis
   Tests to see if a pool exists
.DESCRIPTION
   
.EXAMPLE
   Test-F5.Pool -PoolName "Pool_www_80"

#>
function Test-F5.Pool
{
  #todo: have it check for short names (assume /Common/)
  param([string]$PoolName);
  
  $pool_list = $(Get-F5.iControl).LocalLBPool.get_list()
  foreach($poolItem in $pool_list)
  {
    if ( $poolitem.Equals($Pool) )
    {
      $true
      break
    }
  }
  $false
  
}


<#
.Synopsis
   Remove pool by name
.DESCRIPTION
   
.EXAMPLE
   Remove-F5.Pool -PoolName Pool_www_80
#>
function Remove-F5.Pool
{
    [cmdletbinding()]
    #Tod: could use a -whatif and -force
    param(
        # Name of the pool to be removed
        [string]$PoolName
    )
    if ( Test-Pool -PoolName $PoolName )
    {
        $(Get-F5.iControl).LocalLBPool.delete_pool( (,$PoolName) );
        Write-verbose "Removed Pool '$PoolName'";
    }
}


<#
.Synopsis
   This function will associate a monitor template with the specified pool.
.DESCRIPTION
   Tests to see if a pool exists
.EXAMPLE
   Add-F5.PoolMonitor -PoolName Pool_www_80 -MonitorName http-test
#>
function Add-F5.PoolMonitor()
{
  param(
    # The Pool name to target.
    [string]$PoolName,
    # The Monitor Template name to associate with the given pool.
    [string]$MonitorName
  )
  
  $monitor_association = New-Object -TypeName iControl.LocalLBPoolMonitorAssociation
  $monitor_association.pool_name = $PoolName
  $monitor_association.monitor_rule = New-Object -TypeName iControl.LocalLBMonitorRule
  $monitor_association.monitor_rule.type = "MONITOR_RULE_TYPE_SINGLE"
  $monitor_association.monitor_rule.quorum = 0
  $monitor_association.monitor_rule.monitor_templates = (, $MonitorName)
  
  $(Get-F5.iControl).LocalLBPool.set_monitor_association( (, $monitor_association) )
  
  Write-Verbose "Monitor '$MonitorName' Is Associated With Pool '$PoolName'"
}