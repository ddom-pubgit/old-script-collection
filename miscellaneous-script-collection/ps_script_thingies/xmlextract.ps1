####################################
##########Select Job File###########
####################################

Add-Type -AssemblyName System.Windows.Forms
$FileBrowser = New-Object System.Windows.Forms.OpenFileDialog -Property @{ InitialDirectory = [Environment]::GetFolderPath('Desktop') }

[void]$FileBrowser.ShowDialog()

$LogFile = $FileBrowser.Filename
$LogName = $FileBrowser.FileName | Split-Path -leaf
$JobName = $LogName.Split(".",3)[1]
$LogPath = $FileBrowser.FileName | Split-Path
$FileName ="FriendlyXML_"+$JobName+".log"
$FriendlyXML = $LogPath+'\' + $FileName

####################################
#######Parse Out Job Options########
####################################

[array]$AllJobOptions = Get-Content $Logfile | Select-String -Pattern 'Job Options:'
[string]$LatestRunOptions = $AllJobOptions[-1]
$ConvertToXml = ($LatestRunOptions.Split("[")[2]) + ($LatestRunOptions.Split("[")[3])
$CleanString = $ConvertToXml.Substring(0,$ConvertToXml.Length-1) #| Format-XML
[xml]$JobSettings = $CleanString

####################################
#######Print out Job Settings#######
####################################

###Detect Full Schedule###
$AFEnable = $JobSettings.JobOptionsRoot.EnableFullBackup
$SFEnable = $JobSettings.JobOptionsRoot.TransformFullToSyntethic

Set-Content -Path $FriendlyXML -Value "Job Settings in Plain Language"


<# Examples of logic combos
if ($AFEnable -eq $True) {
    $AFDay = $JobSettings.JobOptionsRoot.FullBackupDays.DayOfWeek
    $RetentionFi = $true
    Add-Content -Path $FriendlyXML -Value "The job runs Active Fulls on $AFDAy. <EnableFullBackups> and <FullBackupScheduleKind>/<FullBackupDays> demonstrates this"
    }
elseif ($SFEnable -eq $True) {
    $SFDay = $JobSettings.JobOptionsRoot.TransformToSyntethicDays.DayOfWeek
    $RetentionFi = $true
    Add-Content -Path $FriendlyXML -Value "The job is set to make Synthetic Fulls on $SFDay if the job runs that day. <TransformFulltoSynTethic> and <TransformToSytethicDays>/<DayOfWeek> demonstrates this."
    }
elseif ($AFEnable -eq $true -and $SFEnable -eq $True) {
    Add-Content -Path $FriendlyXML -Value "The job is running both Active and Synthetic Fulls. This is spooky, but not too spooky."
    }
else {
    $RetentionFFi = $True
    Add-Content -Path $FriendlyXML -Value "There are no Fulls Scheduled. This is a Forever Forward Incremental Job."
    }

###Listing Retention###
$RetentionValue = $JobSettings.JobOptionsRoot.RetainCycles

if ($RetentionFi -eq $True) {
    Add-Content -Path $FriendlyXML -Value "`n" 
    Add-Content -Path $FriendlyXML -Value "The job Retention is Forward Incremental"
    }
elseif ($RetentionFFi -eq $True) { 
    Add-Content -Path $FriendlyXML -Value "`n" 
    Add-Content -Path $FriendlyXML -Value "The job Retention is Forever Forward Forward Incremental"
    }

Add-Content -Path $FriendlyXML -Value "Retention is set to $RetentionValue points. <RetainCycles> indicates this."

$EnableDeletedVM = $JobSettings.JobOptionsRoot.EnableDeletedVmDataRetention

If ($EnableDeletedVM -eq $True) { 
    [int]$DeletedVMRetention = $JobSettings.JobOptionsRoot.RetainDays
    Add-Content -Path $FriendlyXML -Value "`n" 
        if ($DeletedVMRetention -lt 3) {
            Add-Content -Path $FriendlyXML -Value "Deleted VM Retention is Enabled!! <EnableDeletedVmDataRetention>"
            Add-Content -Path $FriendlyXML -Value "Spooky Setting Warning! Deleted VM Retention is only $DeletedVMRetention Days. If the job doesn't backup VMs for $DeletedVMRetention Days, they will be considered 'Deleted' and removed :( <Retaindays>"
            }
            else { 
                 Add-Content -Path $FriendlyXML -Value "Deleted VM Retention is Enabled and set to $DeletedVMRetention days."
                 }
            }
    elseif ($EnableDeletedVM -eq $False) { 
        Add-Content -Path $FriendlyXML -Value "`r`n"
        Add-Content -Path $FriendlyXML -Value "No Deleted VM Retention"
       }
	   
	   explorer.exe $FriendlyXML
    
#>