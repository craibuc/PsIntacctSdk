function Find-IntacctSdkObject {

    [CmdletBinding()]
    param (
        [Parameter()]
        [Intacct.SDK.ClientConfig]$ClientConfig,

        [Parameter(Mandatory)]
        [string]$ObjectName,

        [Parameter()]
        [string]$Query,

        [Parameter()]
        [string[]]$Field = '*',

        [Parameter()]
        [int]$PageSize = 1000
    )

    try
    {

        if ( $ClientConfig ) { [Intacct.SDK.OnlineClient]$OnlineClient = [Intacct.SDK.OnlineClient]::new($ClientConfig) }
        elseif ( $Script:ClientConfig ) { [Intacct.SDK.OnlineClient]$OnlineClient = [Intacct.SDK.OnlineClient]::new($Script:ClientConfig) }
        else { throw "Credentials not found" }

        [Intacct.SDK.Functions.Common.ReadByQuery]$Reader = [Intacct.SDK.Functions.Common.ReadByQuery]::new()
        $Reader.ObjectName = $ObjectName
        $Reader.Query = [Intacct.SDK.Functions.Common.Query.QueryString]::new($Query)
        $Reader.Fields = $Field
        $Reader.PageSize = $PageSize      

        do 
        {
            [System.Threading.Tasks.Task[Intacct.SDK.Xml.OnlineResponse]]$task = $OnlineClient.Execute($Reader)
            $task.Wait()
        
            # results of query
            [Intacct.SDK.Xml.OnlineResponse]$Response = $task.Result
        
            # return the Data node
            Write-Output ( [Newtonsoft.Json.JsonConvert]::SerializeObject( $Response.Results[0].Data ) | ConvertFrom-Json )

            # redefine $Reader to be a ReadMore, instead of a ReadByQuery
            [Intacct.SDK.Functions.Common.ReadMore]$Reader = [Intacct.SDK.Functions.Common.ReadMore]::new()
            $Reader.ResultId = $Response.Results[0].ResultId

        } while ($Response.Results[0].NumRemaining -gt 0)
    }
    catch 
    {
        Write-Error $_.Exception.Message
    }

}