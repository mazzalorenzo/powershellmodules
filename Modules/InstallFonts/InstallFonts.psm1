<#
.Synopsis
   Install Fonts
.DESCRIPTION
   Install fonts on the current user.
.EXAMPLE
   Install-Fonts -Files "C:\Fonts"
.EXAMPLE
   Install-Fonts -File "C:\Fonts\LeanStatus.ttf"
#>
function Install-Fonts
{
    [CmdletBinding()]
    Param
    (
        [string[]]$Files,
        [string]$File
    )
    $totFiles = Get-ChildItem "$Files\*.ttf" |measure-object| select -ExpandProperty count
    $objShell = New-Object -ComObject Shell.Application
    $Fonts = $objShell.NameSpace(20)
    If (!($Files -eq $null)){  Get-ChildItem "$Files\*.ttf" | ForEach-Object -Begin {
      $i = 0
    } -Process {
      $percent = ($i/$totFiles*100)
      Write-Progress -Activity "Search in Progress" -Status "Progress: $i / $totFiles" -PercentComplete $percent
      $i = $i+1
      $Fonts.CopyHere($_.FullName)}

 }
    ElseIf (!($File -eq $null)){ $Fonts.CopyHere($File) }
  
}