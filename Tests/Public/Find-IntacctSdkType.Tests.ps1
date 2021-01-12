BeforeAll {

    # /PsIntacctSdk
    $ProjectDirectory = Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Parent
    $PublicPath = Join-Path $ProjectDirectory "/PsIntacctSdk/Public/"
    $PrivatePath = Join-Path $ProjectDirectory "/PsIntacctSdk/Private/"

    # Find-IntacctSdkType.ps1
    $SUT = (Split-Path -Leaf $PSCommandPath) -replace '\.Tests\.', '.'

    . (Join-Path $PublicPath $SUT)

}

Describe "Find-IntacctSdkType" -tag 'Unit' {

    Context "Parameter validation" {

        BeforeAll {
            $Command = Get-Command 'Find-IntacctSdkType'
        }

        Context "Expression" {
            BeforeAll { $ParameterName='Expression' }

            It "is a [string]" {
                $Command | Should -HaveParameter $ParameterName -Type [string]
            }
    
            It "is mandatory" {
                $Command | Should -HaveParameter $ParameterName -Mandatory
            }
        }

    }

    Context "Expression" {

        It "returns the expected Type" {

            # arrange
            $Expression = 'CustomerCreate'
            
            # act
            $Actual = Find-IntacctSdkType -Expression $Expression

            # assert
            $Actual.FullName | Should -Be 'Intacct.SDK.Functions.AccountsReceivable.CustomerCreate'
        }

    }

}