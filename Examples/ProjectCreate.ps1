import-module PsIntacctSdk -Force

$SenderCredential= Get-Credential
$UserCredential = Get-Credential
$CompanyId = 'CompanyId'

New-IntacctSdkSession -SenderCredential $SenderCredential -UserCredential $UserCredential -CompanyId $CompanyId

$ProjectCreate = @{
    ProjectId = 'ProjectA'
    ProjectName = 'My project'
    Active = $true       
    ProjectCategory = 'Internal'
    Locationid = 'Location A'
} | New-IntacctSdkObject -TypeName ProjectCreate

# smart-rule referenced department
$ProjectCreate.CustomFields.Add('RDEPARTMENT',2)

$ProjectCreate | Save-IntacctSdkObject
