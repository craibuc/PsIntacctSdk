[CmdletBinding()]
param()

Import-Module PsIntacctSdk -Force

$SenderCredential= Get-Credential
$UserCredential = Get-Credential
$CompanyId = 'CompanyId'

New-IntacctSdkSession -SenderCredential $SenderCredential -UserCredential $UserCredential -CompanyId $CompanyId

$Result = Find-IntacctSdkObject -ObjectName 'APBILL' -Field 'RECORDNO','RECORDID','VENDORID' -Query "VENDORID='AB10000'"
$Result.apbill | FT
