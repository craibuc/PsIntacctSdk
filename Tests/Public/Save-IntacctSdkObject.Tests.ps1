BeforeAll {

    # /PsIntacctSdk
    $ProjectDirectory = Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Parent
    $PublicPath = Join-Path $ProjectDirectory "/PsIntacctSdk/Public/"
    $PrivatePath = Join-Path $ProjectDirectory "/PsIntacctSdk/Private/"

    # Save-IntacctSdkObject.ps1
    $SUT = (Split-Path -Leaf $PSCommandPath) -replace '\.Tests\.', '.'
    . (Join-Path $PublicPath $SUT)

}

Describe "Save-IntacctSdkObject" -tag 'Unit' {

    Context "Parameter validation" {

        BeforeAll {
            $Command = Get-Command 'Save-IntacctSdkObject'
        }

    }

}