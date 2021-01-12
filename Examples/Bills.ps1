[CmdletBinding()]
param()

Import-Module PsIntacctSdk -Force

$SenderCredential= Get-Credential
$UserCredential = Get-Credential
$CompanyId = 'CompanyId'

New-IntacctSdkSession -SenderCredential $SenderCredential -UserCredential $UserCredential -CompanyId $CompanyId

$BillCreate = @{
    VendorId = 'V1234'
    TransactionDate = '01/06/2021'
    GlPostingDate = '01/06/2021'
    DueDate = '01/16/2021'
    Description = 'lorem ipsum'
    BillNumber = 'INV-ABCD'
    ReferenceNumber = 'P/O 1234'    
} | New-IntacctSdkObject -TypeName BillCreate

$BillLineCreate = @{
    GlAccountNumber = '12345678'
    TransactionAmount = 99.99
    Memo ='1 x Foobar'
} | New-IntacctSdkObject -TypeName BillLineCreate

$BillCreate.Lines.Add($BillLineCreate)

$Response = $BillCreate | Save-IntacctSdkObject
$Response
