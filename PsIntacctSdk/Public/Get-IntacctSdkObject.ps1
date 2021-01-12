function Get-IntacctSdkObject {

    [CmdletBinding()]
    param (
        [Parameter()]
        [Intacct.SDK.ClientConfig]$ClientConfig,

        [Parameter(Mandatory)]
        [string]$ObjectName,

        [Parameter(ParameterSetName='ByKey',Mandatory)]
        [int[]]$Key,

        [Parameter(ParameterSetName='ByName',Mandatory)]
        [string[]]$Name,

        [Parameter()]
        [string[]]$Field = '*'
    )
            
    switch ( $PSCmdlet.ParameterSetName)
    {
        'ByKey' {
            [Intacct.SDK.Functions.Common.Read]$Reader = [Intacct.SDK.Functions.Common.Read]::new()
            $Reader.ObjectName = $ObjectName
            $Reader.Keys = $Key    
            $Reader.Fields = $Field
        }
        'ByName' {
            [Intacct.SDK.Functions.Common.ReadByName]$Reader = [Intacct.SDK.Functions.Common.ReadByName]::new()
            $Reader.ObjectName = $ObjectName
            $Reader.Names = $Name
            $Reader.Fields = $Field
            $Reader.PageSize
        }
    }

    try 
    {

        if ( $ClientConfig ) { [Intacct.SDK.OnlineClient]$OnlineClient = [Intacct.SDK.OnlineClient]::new($ClientConfig) }
        elseif ( $Script:ClientConfig ) { [Intacct.SDK.OnlineClient]$OnlineClient = [Intacct.SDK.OnlineClient]::new($Script:ClientConfig) }
        else { throw "Credentials not found" }

        [Intacct.SDK.OnlineClient]$OnlineClient = [Intacct.SDK.OnlineClient]::new($ClientConfig)

        [System.Threading.Tasks.Task[Intacct.SDK.Xml.OnlineResponse]]$task = $OnlineClient.Execute($Reader)
        $task.Wait()
    
        [Intacct.SDK.Xml.OnlineResponse]$Response = $task.Result
    
        [Newtonsoft.Json.JsonConvert]::SerializeObject( $Response.Results[0].Data ) | ConvertFrom-Json

    }
    catch 
    {
        Write-Error $_.Exception.Message
    }

}