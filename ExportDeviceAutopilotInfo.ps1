Param(
    [string]$Loc
)

$Delay = 1

if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(
        [Security.Principal.WindowsBuiltInRole] 'Administrator')
)
{
    Write-Host "Not elevated, restarting in $Delay seconds ..."
    $Loc = Get-Location
    Start-Sleep -Seconds $Delay

    $Arguments =  @(
        '-NoProfile',
        '-ExecutionPolicy Bypass',
        '-NoExit',
        '-File',
        "`"$($MyInvocation.MyCommand.Path)`"",
        "\`"$Loc\`""
    )
    Start-Process -FilePath PowerShell.exe -Verb RunAs -ArgumentList $Arguments
    Break
}
else
{
    Write-Host "Already elevated, exiting in $Delay seconds..."
    Start-Sleep -Seconds $Delay
}
if($Loc.Length -gt 1){
Set-Location $($Loc.Substring(1,$Loc.Length-1)).Trim()
}

Write-Host $(Get-Location)
$SystemInfo = Get-ComputerInfo -Property CsModel, BiosSeralNumber
$FileName = $($SystemInfo.CsModel) + " - " + $($SystemInfo.BiosSeralNumber) + " AutopilotHWID.csv"
$env:Path += ";C:\Program Files\WindowsPowerShell\Scripts"
Set-ExecutionPolicy -Scope Process -ExecutionPolicy RemoteSigned
Install-Script -Name Get-WindowsAutopilotInfo
Get-WindowsAutopilotInfo -OutputFile $FileName