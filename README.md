# PsIntacctSdk
PowerShell wrapper of the Sage Intacct SDK for .NET

## Installation

### Git
```powershell
PS> cd ~/Documents/WindowsPowerShell/Modules

PS> git clone git@github.com:craibuc/PsIntacctSdk.git
```

## Configuration

### Enable the Sender ID

Add the `Sender ID` (provided by Intacct) to the environment:

`Company > Company > Setup > Configuration > Company > Security`:

- Click <kbd>Edit</kbd>, then <kbd>Add</kbd> to display the dialog:
- Supply the `Sender ID`
- Click <kbd>Save</kbd> to exit the window
- Click <kbd>Save</kbd> to save the changes

## Usage

### Create a session

```powershell
# save the sender id credentials to a variable
$SenderCredential = Get-Credential

# save the user credentials to a variable
$UserCredential = Get-Credential

# create the session object
$Session = New-IntacctSdkSession -SenderCredential $SenderCredential -UserCredential $UserCredential -CompanyId 'my_company_id' -PassThru
```

## Contributors
- [Craig Buchanan](https://github.com/craibuc/)
