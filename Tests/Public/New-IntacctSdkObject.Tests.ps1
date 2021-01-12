BeforeAll {

    # /PsIntacctSdk
    $ProjectDirectory = Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Parent
    $PublicPath = Join-Path $ProjectDirectory "/PsIntacctSdk/Public/"
    $PrivatePath = Join-Path $ProjectDirectory "/PsIntacctSdk/Private/"

    # dependencies
    . (Join-Path $PublicPath "Find-IntacctSdkType.ps1")

    # New-IntacctSdkObject.ps1
    $SUT = (Split-Path -Leaf $PSCommandPath) -replace '\.Tests\.', '.'
    . (Join-Path $PublicPath $SUT)

}

Describe "New-IntacctSdkObject" -tag 'Unit' {

    Context "Parameter validation" {

        BeforeAll {
            $Command = Get-Command 'New-IntacctSdkObject'
        }

        Context "TypeName" {
            BeforeAll { $ParameterName='TypeName' }

            It "is a [string]" {
                $Command | Should -HaveParameter $ParameterName -Type [string]
            }
    
            It "is mandatory" {
                $Command | Should -HaveParameter $ParameterName -Mandatory
            }
        }

    }

    Context "TypeName" {

        Context "when a valid type is supplied" {

            It "returns the expected Type" {

                # arrange
                $TypeName = 'CustomerCreate'
                
                # act
                $Actual = New-IntacctSdkObject -TypeName $TypeName
    
                # assert
                $Actual.GetType().FullName | Should -Be 'Intacct.SDK.Functions.AccountsReceivable.CustomerCreate'
            }
    
        }

        Context "when an invalid type is supplied" {

            It "throws an exception" {

                # arrange
                $TypeName = 'FooBar'
                
                # act/assert
                { New-IntacctSdkObject -TypeName $TypeName } | Should -Throw "Type not found: $TypeName"

            }
    
        }

    }

}