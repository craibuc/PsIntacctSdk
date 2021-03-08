[CmdletBinding()]
param()

Import-Module PsIntacctSdk -Force

$SenderCredential= Get-Credential
$UserCredential = Get-Credential
$CompanyId = 'CompanyId'

New-IntacctSdkSession -SenderCredential $SenderCredential -UserCredential $UserCredential -CompanyId $CompanyId

# folder
$Folder = Find-IntacctSdkAttachmentFolder -Field 'name','description' -SortedField @{Name='name';Order='desc'} -Expression @{Field='name';Operator='=';Value='Lorem'}
$Folder

# attachments
$Attachment = Find-IntacctSdkAttachment -PageSize 10 -Field 'recordno','supdocname','supdocid','folder' -SortedField @{Name='supdocname';Order='desc'} -Expression @{Field='supdocid';Operator='=';Value='ATT-000000'}
$Attachment
