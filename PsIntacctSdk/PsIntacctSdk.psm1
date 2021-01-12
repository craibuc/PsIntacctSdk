"$PSScriptRoot\Public\*.ps1","$PSScriptRoot\Private\*.ps1" | Get-ChildItem -ErrorAction 'Continue' | 
    Where-Object { $_.Name -like '*.ps1' -and $_.Name -notlike '__*' -and $_.Name -notlike '*.Tests*' } | ForEach-Object {
        # dot-source script
        . $_
    }

Register-ArgumentCompleter -CommandName 'New-IntacctSdkObject' -ParameterName TypeName -ScriptBlock {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)

    Write-Verbose "CommandName: $CommandName"
    Write-Verbose "ParameterName: $ParameterName"
    Write-Verbose "wordToComplete: $wordToComplete"

    Find-IntacctSdkType -Expression "*$wordToComplete*" | Select-Object -Expand Name

}
    