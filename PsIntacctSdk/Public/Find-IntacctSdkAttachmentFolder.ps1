function Find-IntacctSdkAttachmentFolder {

    [CmdletBinding()]
    param (
        [Parameter()]
        [Intacct.SDK.ClientConfig]$ClientConfig,

        [Parameter()]
        [object]$Expression,

        [Parameter()]
        [ValidateSet('createdby','creationdate','description','lastmodified','lastmodifiedby','name','parentfolder','status')]
        [string[]]$Field,

        [Parameter()]
        [object[]]$SortedField,

        [Parameter()]
        [int]$PageSize = 100
    )

    try
    {
        if ( $ClientConfig ) { [Intacct.SDK.OnlineClient]$OnlineClient = [Intacct.SDK.OnlineClient]::new($ClientConfig) }
        elseif ( $Script:ClientConfig ) { [Intacct.SDK.OnlineClient]$OnlineClient = [Intacct.SDK.OnlineClient]::new($Script:ClientConfig) }
        else { throw "Credentials not found" }

        [Intacct.SDK.Functions.Common.List.GetList]$List = [Intacct.SDK.Functions.Common.List.GetList]::new('supdocfolder')
        $List.maxitems = $PageSize

        if ( $null -ne $Expression ) { $List.Expression = [Intacct.SDK.Functions.Common.List.ExpressionFilter]::new($Expression.Field, $Expression.Operator, $Expression.Value) }

        if ( $null -ne $Field ) { $List.Fields = $Field }
        
        foreach ($sort in $SortedField)
        {
            $List.SortedFields.Add( [Intacct.SDK.Functions.Common.List.SortedField]::new($sort.Name, $sort.Order) )
        }
        
        do 
        {
            [System.Threading.Tasks.Task[Intacct.SDK.Xml.OnlineResponse]]$task = $OnlineClient.Execute($List)
            $task.Wait()
        
            # results of query
            [Intacct.SDK.Xml.OnlineResponse]$Response = $task.Result
        
            # return the Data node
            Write-Output ( [Newtonsoft.Json.JsonConvert]::SerializeObject( $Response.Results[0].Data ) | ConvertFrom-Json ).supdocfolder

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