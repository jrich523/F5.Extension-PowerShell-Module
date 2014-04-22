<#
.Synopsis
   Short description
.DESCRIPTION
   Long description
.EXAMPLE
   Example of how to use this cmdlet
.EXAMPLE
   Another example of how to use this cmdlet
#>
function New-F5.LTMNode
{
    [CmdletBinding()]
    [OutputType([int])]
    Param
    (
        # Name of the node
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        $Name,

        # IP of the node
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=1)]
        [string]
        $Address,
        # max number of connections. Default is 0 (no limit)
        [Parameter(ValueFromPipelineByPropertyName=$true,
                   Position=2)]
        [int]
        $ConnectionLimit = 0,
        # description of the node
        [Parameter(ValueFromPipelineByPropertyName=$true,
                   Position=3)]
        [string]
        $Description

    )
    #test address first?
    $(Get-F5.iControl).LocalLBNodeAddressV2.create($Name,$Address,$ConnectionLimit)
    if($Description)
    {
        $(Get-F5.iControl).LocalLBNodeAddressV2.set_description($name,$Description)
    }

    
}