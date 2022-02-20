<#
This script is designed to speed up the process for cleaning out invalid host HyperV Host Components.
It is meant to help avoid issues when we have a Host that is constantly asking for updates to the HV
Integration Components, but the server is not a HyperV server.

The script is mostly a "stop stupid things from happening" thing, there is only one part that matters:

$components = $affectedhost.GetPhysicalHost().GetComponents() |?{$_.Type -eq "Hvintegration"}
$components.Delete()

Feel free to use this if necessary and avoid the script
#>

function Exit-Script {
Write-Host "Script will exit in 5 seconds"
Start-Sleep 5
Exit
}

function Find-BadHost {
    $found = "0"
    $components = $null
    while($found -ne "1"){
        $chosenhost = Get-VBRServer | Select-Object -Property Info, Name, Description  |Out-GridView -PassThru -Title 'Please select the server inappropriately showing HyperV Components'
        $servername = $chosenhost.name
        $affectedhost = Get-VBRServer -Name $servername
        [Object]$components = $affectedhost.GetPhysicalHost().GetComponents() |?{$_.Type -eq "Hvintegration"}
        If(!($components)){
            Write-Host "This server does not appear to have the HyperV Components Enabled. Please Pick a different host or end the script"
            $Title = "No HV Components Found"
            $Prompt = "Try again or stop the script?                       "
            $Choices = [System.Management.Automation.Host.ChoiceDescription[]] @("&Try Again", "&Stop")
            $Default = 1
            $Choice = $host.UI.PromptForChoice($title, $Prompt, $Choices, $Default)
            switch($Choice){
                0 {}
                1 {Exit-Script}
            }
        } else {
            $found = "1"
        }
    }
Return [Object]$components}


#check we're in an admin shell

if (!(New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))
{
  Write-Host -ForegroundColor Yellow "You're running PowerShell without elevated rights. Please open a PowerShell window as an Administrator. Shell will close in 10 seconds automatically."
  Exit-Script
}
else {Write-Host -ForegroundColor Green "You're running PowerShell as an Administrator. Continuing"}

#check we're on the VBR server

If(!(Get-Service -Name 'VeeamBackupSvc')){ Write-host -ForegroundColor Yello 'This command should be run on the Veeam Backup Server directly.'
 Write-Host -ForegroundColor Yello 'This is to avoid difficulties with Remote-Powershell access'
 Exit-Script
}


#finding the host in Veeam
Add-PSSnapin VeeamPSSnapin
$componentstoclear  = Find-BadHost


#Finally clear the components$

$naughtyhost  = $affectedhost.Name
$Title = "Affected Host has been found. Host name: $naughtyhost"
$Prompt = "Ready to clear the components? (This will start a Configuration Backup, and remove the HyperV Components from the database)"
$Choices = [System.Management.Automation.Host.ChoiceDescription[]] @("&Yes", "&Pick Another Host", "&Cancel")
$Default = 1
# Prompt for the choice
$Choice = $host.UI.PromptForChoice($Title, $Prompt, $Choices, $Default)
# Action based on the choice
switch($Choice){
    0 {
        Write-Host "Starting Configuration Backup (just to be safe!)"
        $configjobresult = Start-VBRConfigurationBackupJob
        if($configjobresult.Result -eq "Failed"){
            Write-Host "The Configuration Backup Failed. Please Run it Manually or take a Backup of the Database"
            Exit-Script
            }
        else {
            $componentstoclear.Delete()
             Write-Host "Components have been cleared. Please Close and re-open the console to check if the issue is resolved."
             Exit-Script
            }
        }
    1 { 
        Write-Host "Returning to Host Select"
        Start-Sleep 3
        Find-BadHost
       }

    2 { 
        Write-Host "Script is cancelling"
        Exit-Script
    }
}