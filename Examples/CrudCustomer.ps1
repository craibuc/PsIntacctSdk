[CmdletBinding()]
param()

Import-Module PsIntacctSdk -Force

$SenderCredential= Get-Credential
$UserCredential = Get-Credential
$CompanyId = 'CompanyId'

New-IntacctSdkSession -SenderCredential $SenderCredential -UserCredential $UserCredential -CompanyId $CompanyId

$CreateCustomer = @{
    CustomerName = 'Acme Anvils'
    FirstName = 'Wile E.'
    LastName = 'Coyote'
    Active = $true
} | New-IntacctSdkObject -TypeName CustomerCreate

$Result = $CreateCustomer | Save-IntacctSdkObject

$customerId = $Result.customer.CUSTOMERID
$recordNo = $Result.customer.RECORDNO

Write-Verbose ("Created CUSTOMER: {0} [{1}]" -f $customerId, $recordNo)

@{
    CustomerId = $customerId
    Active = $false
} | New-IntacctSdkObject -TypeName CustomerUpdate | Save-IntacctSdkObject

Write-Verbose ("Updated CUSTOMER: {0}" -f $customerId)

@{
    CustomerId = $customerId
} | New-IntacctSdkObject -TypeName CustomerDelete | Save-IntacctSdkObject

Write-Verbose ("Deleted CUSTOMER: {0}" -f $customerId)
