<#simple script to manage the lab automatically. 
Set the variables at the start, then set the job to run as a scheduled task or after the last job on some day.
You will need to add whatever is set as the $safetyflag to your job descriptions to ensure such backups are never parsed by the script.
Should work for everything. This does not interact with imported backups at all. 
The main goal is to clear out no longer needed jobs from the environment to keep the lab clean.
#>

$DeleteLog = "C:\Users\Administrator\Desktop\DeleteLog.log"
$purgetime = "7"
$logentry = "$(Get-Date) ::: "
$safetyflag = "#corebackup"

function Write-Log {
    param(
        [string[]]$LogText
        )
    Add-Content -Path $DeleteLog -Value "$logentry $LogText"
    }

If ((Get-Service VeeamBackupSvc).Status -ne "Running"){
	Write-Log -LogText "Veeam Backup Service is not running. Backups will not be cleared."
	Exit
	}

Add-PSSnapin VeeamPSSnapin

$jobs = Get-VBRJob | ?{$_.Description -notlike "*$safetyflag*"}
$jobs += Get-VBRTapeJob | ?{$_.Description -notlike "*$safetyflag*"}
foreach($job in $jobs){  
    $LastRun = Get-VBRSession -Job $job -Last #$job.LastestrunLocal is not reliable for all jobs, so use Get-VBRSession instead
	$DaysSinceLastRun = ((Get-Date) - ($($LastRun.Endtime))).Days
    if($($LastRun.State -eq "Working")){
       Write-Log -LogText "Job $($job.name) is currently running. Skipping Delete"
        Continue
        }
    if($LastRun -eq $null){
        Write-Log -LogText "Job $($job.name) has never been run. Skipping Delete"
        Continue
        }
    if($DaysSinceLastRun -ge $purgetime) {
		$backup = Get-VBRBackup -Name $($job.Name)
        if($job.Type -notlike "*Tape*"){
		    Remove-VBRBackup -Backup $backup -FromDisk -Confirm:$false | Out-Null
        }
		Remove-VBRJob -Job $job -Confirm:$false | Out-Null
		Write-Log -LogText "Deleted Job $($job.name) and its backups as they were older than $purgetime."
	} else {
	 Write-Log -LogText "Job $($job.name) was run $DaysSinceLastRun days ago, waiting before removing."
    }
}
