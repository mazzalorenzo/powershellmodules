<#
.Synopsis
   Short description
.DESCRIPTION
   Long description
.EXAMPLE
   Example of how to use this cmdlet
.EXAMPLE
   Another example of how to use this cmdlet
#>
function Remove-EnvironmentVariableDuplicates
{
    [CmdletBinding()]
    Param
    (
        # EnvVar help description
        [Parameter(Mandatory=$true)]
        [string]$EnvVar
    )
    $EnvVarValue = [System.Environment]::GetEnvironmentVariable("$EnvVar")
    $EnvVarValue = $EnvVarValue -Split ";"
    $EnvVarValue = ($EnvVarValue | Sort | Get-Unique) -join ";"
    [System.Environment]::SetEnvironmentVariable("$EnvVar","$EnvVarValue",'User')
}

<#
.Synopsis
   Add all the subfolders to the environment variable
.DESCRIPTION
    Add all the subfolders to the environment variable
.NOTES
   Useful for Path Environment Variable
.EXAMPLE
   Example of how to use this cmdlet
.EXAMPLE
   Another example of how to use this cmdlet
#>

$Script:PSDefaultParameterValues = @{
"*:Scope" = "User";
"*:Folder" = "."
}

function Add-EnvironmentVariables
{
    [CmdletBinding()]
    Param
    (
        # EnvVar help description
        [Parameter(Mandatory=$true)]
        [Alias("EnvVar")] 
        [string]$EnvironmentVariable,

        # Folder help description
        [string]
        $Folder,

        # Scope help description
        [ValidateSet("User", "Machine", "Process")]
        [string]
        $Scope
    )
    Process
    {
        [string]$Path = Resolve-Path $Folder
        echo $Path
        $EnvironmentVariableValue = [System.Environment]::GetEnvironmentVariable("$EnvironmentVariable", "$Scope")
        forEach($item in (Get-ChildItem $Folder -Directory))
        {
            $SubFolder = $item.Name
            $SubFolderFullPath = "$Path\$SubFolder"
            $EnvironmentVariableValue += ";$SubFolderFullPath"
        }
        [System.Environment]::SetEnvironmentVariable("$EnvironmentVariable","$EnvironmentVariableValue",$Scope)
    }
}