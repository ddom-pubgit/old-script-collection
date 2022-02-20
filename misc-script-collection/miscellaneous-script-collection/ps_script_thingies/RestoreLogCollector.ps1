function Get-VMLogFolder {
        if ((Test-Path "C:\programdata\Veeam\Backup\$VMRestore")){
            mkdir $RestoreLogsFolder\$VMrestore | Out-Null
            Get-ChildItem "C:\programdata\Veeam\Backup\$VMRestore" | Copy-Item -Destination $RestoreLogsFolder\$VMrestore -Container | Out-Null
            }
        }

#Set Required Folders
$LogPath="C:\Temp"
$LogName = "VeeamRestoreLogs" +"_$((Get-Date).ToString("ddMMyyyy"))"
$RestoreLogsFolder = $LogPath+'\'+$LogName



Add-PSSnapin VeeamPSSnapin
$VmInJobs = Get-VBRJob |Get-VBRJobObject
$VmNamesUnique = $VmInJobs.Name | Sort-Object | Get-Unique
$VmRestoreLogsToCollect = $VmNamesUnique | Out-GridView -PassThru -Title "Please select the VMs experiencing difficulties with Restore"
[System.IO.Directory]::CreateDirectory($RestoreLogsFolder) | Out-Null

Foreach ($VMRestore in $VmRestoreLogsToCollect) { 
    Get-VMLogFolder
    }

