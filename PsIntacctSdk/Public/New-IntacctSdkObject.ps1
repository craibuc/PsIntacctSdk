<#
.SYNOPSIS

.PARAMETER Name

.EXAMPLE
New-IntacctSdkObject -TypeName 'CustomerCreate'

#>
function New-IntacctSdkObject {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$TypeName,

        [Parameter(ValueFromPipeline)]
        [object]$InputObject
    )
    
    $Type = Find-IntacctSdkType -Expression $TypeName

    if (-Not $Type) { throw "Type not found: $TypeName" } 
    
    # constructor
    $Object = $Type::New()

    # attempt to populate fields and properties
    if ($InputObject)
    {
        foreach ($item in $InputObject.GetEnumerator()) {
        
            # try field
            if ( $null -ne $Object.GetType().GetField($item.Key) )
            {
                $Object.GetType().GetField($item.Key).SetValue($Object, $item.Value)
            }
            # try property
            elseif ( $null -ne $Object.GetType().GetProperty($item.Key) ) 
            {
                $Object.GetType().GetProperty($item.Key).SetValue($Object, $item.Value, $null)        
            }
    
        }
    }


    # return it
    $Object

}