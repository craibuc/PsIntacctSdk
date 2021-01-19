import-module PsIntacctSdk -Force

$SenderCredential= Get-Credential
$UserCredential = Get-Credential
$CompanyId = 'CompanyId'

New-IntacctSdkSession -SenderCredential $SenderCredential -UserCredential $UserCredential -CompanyId $CompanyId

$CreateCustomer = @{
    CustomerName = 'Acme Anvils'
    FirstName = 'Wile E.'
    LastName = 'Coyote'
    Active = $true
} | New-IntacctSdkObject -TypeName CustomerCreate | Save-IntacctSdkObject -ErrorAction Stop | Select-Object -ExpandProperty customer

$RECORDNO = $CreateCustomer.RECORDNO
