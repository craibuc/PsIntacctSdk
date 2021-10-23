function New-IntacctSdkSession {

    [CmdletBinding()]
    param (
        [pscredential]$SenderCredential,
        [pscredential]$UserCredential,
        [string]$CompanyId,
        [switch]$PassThru
    )
    
    try 
    {
        [Intacct.SDK.Functions.ApiSessionCreate]$ApiSessionCreate = [Intacct.SDK.Functions.ApiSessionCreate]::new()

        [Intacct.SDK.ClientConfig]$ClientConfig = [Intacct.SDK.ClientConfig]::new()
        $ClientConfig.SenderId = $SenderCredential.UserName
        $ClientConfig.SenderPassword = $SenderCredential.Password | ConvertFrom-SecureString -AsPlainText
        $ClientConfig.UserId = $UserCredential.UserName
        $ClientConfig.UserPassword = $UserCredential.Password | ConvertFrom-SecureString -AsPlainText
        $ClientConfig.CompanyId = $CompanyId
    
        [Intacct.SDK.OnlineClient]$OnlineClient = [Intacct.SDK.OnlineClient]::new($ClientConfig)

        $attempt = 1
        $max_attempts = 3
        $delay = 1

        do 
        {
            try 
            {
                Write-Verbose "Executing..."
                [System.Threading.Tasks.Task[Intacct.SDK.Xml.OnlineResponse]]$task = $OnlineClient.Execute($ApiSessionCreate);
                $task.Wait()

                $success = $true
            }
            catch 
            {
                if ($attempt -eq $max_attempts)
                {
                    Write-Host "WARNING: Attempt $($attempt) failed.  Exiting loop." -ForegroundColor Yellow

                    # exit loop by throwing the error which will be cause by outer catcy
                    throw
                }

                if ( $attempt -lt $max_attempts )
                {
                    Write-Host "WARNING: Attempt $($attempt) failed.  Retrying in $delay seconds." -ForegroundColor Yellow
                    Start-Sleep -Seconds $delay    
                }
                
            }

            $attempt++

        } until ($success)
            
        [Intacct.SDK.Xml.OnlineResponse]$Response = $task.Result
    
        [Intacct.SDK.ClientConfig]$Script:ClientConfig = [Intacct.SDK.ClientConfig]::new()
        $Script:ClientConfig.SenderId = $SenderCredential.UserName
        $Script:ClientConfig.SenderPassword = $SenderCredential.Password | ConvertFrom-SecureString -AsPlainText
        $Script:ClientConfig.SessionId = $Response.Results[0].Data[0].Element('sessionid').Value
        $Script:ClientConfig.EndpointUrl = $Response.Results[0].Data[0].Element('endpoint').Value

        if ( $PassThru ) { Write-Output $Script:ClientConfig }
        # [Newtonsoft.Json.JsonConvert]::SerializeObject( $Response.Results[0].Data ) | ConvertFrom-Json
    
    }
    catch 
    {
        Write-Error $_.Exception.Message
    }
    
}