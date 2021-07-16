Add-PSSnapin VeeamPSSNaapin -ErrorAction SilentlyContinue
$run = $true
$i = 0
$WaitTime = 3600 #value in seconds
$WaitForNextRun = "12" #Defines how long from last run we will consider reasonable for retries. If the time between "now" and the last job run is greater than this value, we assume it makes more sense to just try again next run
#$ClearTime = "4"
[System.Collections.ArrayList]$JobsToRetry = @()
$logpath = "C:\temp\Surebackup_Retry_Watcher.Log"

function Write-Log {
    param(
        [string[]]$LogText
        )
	$logentry = "$(Get-Date) ::: "	
    Add-Content -Path $logpath -Value "$logentry $LogText"
    }

While($run){
    $Date = Get-Date
	[System.Collections.ArrayList]$JobsToRetry = @()
    $SBJobs = Get-VBRSurebackupJob
    foreach($job in $SBJobs){
        if($job.LastResult -eq "Failed"){
            $JobsToRetry += $job
            Write-Log -LogText "The following SureBackup jobs need to be retried:"
            Write-Log -LogText "Jobs: $($JobsToRetry.Name -join ", ")"
        }
    }


    if($JobsToRetry.Count -eq 0){
        Write-Log -LogText "No Surebackup jobs need retry, begining wait for 60 minutes"
    } else {
        foreach($retryjob in $JobsToRetry){
           if(($Date - $retryjob.LastRun).Hours -le "$WaitForNextRun"){
               Write-Log -LogText "Starting Job: $($retryjob.name)"
               Start-VBRSurebackupJob -Job $retryjob | out-null
               $result = (Get-VBRSureBackupJob -name $retryjob).LastResult
               Write-Log -LogText "Result of Surebackup Job $($retryjob.name): $result"
           } 
        }
    } 
    $i++
    Write-Log -LogText "Beginning wait for $WaitTime Minutes"
    start-sleep $WaitTime
}
