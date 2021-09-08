<# A courtesy script to help gracefully resolve Task sessions which are running for eternity. Instead of hunting in the DB/Session lists in powershell, it just produces simple to use UI 
Pickers. Right now, can only fix one job at a time, but I doubt there will be a situation where we need many of these.#>

param(
	[Veeam.Backup.PowerShell.Infos.VBRBackupToTapeJob[]]$TapeJob,
	[Veeam.Backup.Core.CBackupJob[]]$BackupJob
	)

$date = Get-Date

if(!(Get-Service VeeamBackupSvc -ErrorAction SilentlyContinue)){
	Write-Host -ForegroundColor Red "Veeam Backup Service not found. Script must be run on the Veeam Server. Run the script on the VBR server itself"
	Write-Host -ForegroundColor Red "Script will end in 5 seconds"
	start-sleep 5
	Break
} 

if (!(New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))
{
  Write-Host -ForegroundColor Yellow "You're running PowerShell without elevated rights. Please open a PowerShell window as an Administrator. Script will stop in 5 seconds automatically."
  Start-Sleep 5
  Break
}

Write-Host -ForegroundColor Green "This script is meant to assist with resolving an issue where a Task Session for a completed job shows as Running, even though the job has long since stopped."
Write-Host -ForegroundColor Green "You will see the timer for a given task continually increasing, even though the Job is not running."
Write-Host -ForegroundColor Green "This is purely a cosmetic issue, no data is actually being transferred."
Write-Host -ForegroundColor Green "This script should only be run at the request of Veeam Support and with Veeam Support Supervision."
Write-Host -ForegroundColor Green "If this description does not match the issue you're facing, please stop the script with ctrl+C"

Add-PSSNapin VeeamPSSnapin -ErrorAction SilentlyContinue

if(-not($TapeJob -or $BackupJob)){
	$alljobs = Get-VBRJob
	$alljobs += Get-VBRTapeJob
	Write-Host -ForegroundColor Yellow "Select the job with the continually running Task."
	$affectedjob = $alljobs | select-Object -Property Name, JobType, Type | Out-GridView -PassThru -Title "Select the affected Job (Choose only one!)"
} elseif($TapeJob){
	$affectedjob = $TapeJob
} else { $affectedjob = $BackupJob }

if($affectedjob.JobType -eq $null){
		$ajob = Get-VBRTapeJob -Name $affectedjob.Name
		$jsess = Get-VBRSession -Job $ajob | Sort-Object -Property CreationTime -Descending
} else {
		$ajob = Get-VBRJob -name $affectedjob.Name
		$jsess = Get-VBRBackupSession |Where-Object {$_.jobId -eq $ajob.Id.Guid} | Sort-Object -Property CreationTime -Descending
}

Write-Host -ForegroundColor Yellow "Select the Job Session (Run) which has the continually running Task. It is recommended to sort by the Creation Date"
$affectedSession = $jsess | Out-GridView -PassThru -Title "Select the affected Job Session. Choose one based on the Creation Date (Hint - likely the progress will be < 100)"

$TaskSessions = Get-VBRTaskSession -Session $affectedSession

Write-Host -ForegroundColor Yellow "Select the Task from ths Job Session which is continually running. Likely, it will show as 'InProgress'"
$taskSessionToCorrect = $TaskSessions | Out-GridView -PassThru -Title "Select the Task session which is running eternally. Choose only one. (Hint - likely it will show as 'InProgress'"
$taskSessionToCorrect.Fail("Error","Manually failed by Veeam support on $date","Manually Failed")

Write-Host -ForegroundColor Green "The Task has been stopped. Please check in the UI to confirm. If it was not successful, please close and open the Job statistics window and check again."
Write-Host -ForegroundColor Green "If it continues to tick, please collect a backup of the Veeam Database as per https://veeam.com/kb1471 and provide it to the case. Veeam Support should contact the script author for assistance."
Write-Host -ForegroundColor Green "The script will now exit"