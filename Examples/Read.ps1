[CmdletBinding()]
param()

Import-Module PsIntacctSdk -Force

$SenderCredential= Get-Credential
$UserCredential = Get-Credential
$CompanyId = 'CompanyId'

New-IntacctSdkSession -SenderCredential $SenderCredential -UserCredential $UserCredential -CompanyId $CompanyId

$Field = 'VENDORID','VENDORNAME','RECORDNO','RECORDID','STATE'

$Result = Get-IntacctSdkObject -ObjectName 'APBILL' -Field $Field -Key 3054
$Result

$Query = "VENDORID='AB10000'"
$Result = Find-IntacctSdkObject -ObjectName 'APBILL' -Field $Field -Query $Query
$Result
