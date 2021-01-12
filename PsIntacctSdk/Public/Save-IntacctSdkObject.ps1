<#
.SYNOPSIS
Save an object to Intacct.

.PARAMETER ClientConfig

.PARAMETER InputObject

.EXAMPLE
@{
    CustomerName = 'Acme Anvils'
    FirstName = 'Wile E.'
    LastName = 'Coyote'
    Active = $true
} | New-IntacctSdkObject -TypeName CustomerCreate | Save-IntacctSdkObject

#>
function Save-IntacctSdkObject {

    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter()]
        [Intacct.SDK.ClientConfig]$ClientConfig,

        [Parameter(Mandatory,ValueFromPipeline)]
        [object]$InputObject
    )

    begin 
    {   
        if ( $ClientConfig ) { [Intacct.SDK.OnlineClient]$OnlineClient = [Intacct.SDK.OnlineClient]::new($ClientConfig) }
        elseif ( $Script:ClientConfig ) { [Intacct.SDK.OnlineClient]$OnlineClient = [Intacct.SDK.OnlineClient]::new($Script:ClientConfig) }
        else { throw "Credentials not found" }

        [Intacct.SDK.OnlineClient] $OnlineClient = [Intacct.SDK.OnlineClient]::new($Script:ClientConfig)    
    }

    process {

        if ($PSCmdlet.ShouldProcess($InputObject.GetType().Name, 'OnlineClient.Execute'))
        {
            try 
            {
                [System.Threading.Tasks.Task[Intacct.SDK.Xml.OnlineResponse]]$task = $OnlineClient.Execute($InputObject)
                $task.Wait()
            
                [Intacct.SDK.Xml.OnlineResponse]$Response = $task.Result

                [Newtonsoft.Json.JsonConvert]::SerializeObject( $Response.Results[0].Data ) | ConvertFrom-Json   
            }
            catch 
            {
                Write-Error $_.Exception.Message
            }
        }
    
    }

    end {}

}