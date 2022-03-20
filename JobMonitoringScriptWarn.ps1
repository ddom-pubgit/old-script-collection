param(
	[string[]]$DBPath,
	[switch]$NewDatabase = $false,
	[switch]$Monitor = $false
	[switch]$AddJobs = $false
)

#Variables you must define

$AcceptableVariancePercent = ".1" #Percent value converted to decimal
$smtp = "Some SMTP Server"
$from = "Some Email"
$to = "Anothe Email"
$creds = "Some secure creds if required"


function Find-AverageJobDuration {
	param(
		[Veeam.Backup.Core.CBackupJob[]]$Job,
		[int[]]$TimeRangeMonths
		)
	$TimeRangeMonths = "3"
	$date = Get-Date
	$LastSessions = [Veeam.Backup.Core.CBackupSession]::GetByJobAndTimeRangeWithLog($job.id,$Date.AddMonths("-$TimeRangeMonths"))|sort -Property CreationTime -Descending 
	$AvgDurationSec = $LastSessions.Progress.Duration.Seconds | Measure-Object -Average
	return $AvgDurationSec.Average
}

function Get-JobExecutingScript {
	$ScriptPID = Get-WMIObject win32_process | Where-Object {$_.ProcessID -eq $PID}
	$ParentProc = Get-WMIObject win32_process | Where-Object {$_.ProcessID -eq $ScriptPID.ParentProcessId}
	$JobID = $ParentProc.CommandLine.Split()[7].Trim('"')
	$Job = Get-VBRJob | Where-Object {$_.id -eq $JobID}
	return $job
}

function Create-JobDurationsDatabase {
	$NewDB = [PSCustomObject]@{
		JobID = ""
		AvgJobDurationSec = ""
		LastUpdateTime = ""
	}
	$NewDB | Export-CSV -NoTypeInformation -Path $DBPath\JobDurationMonitorDatabase.csv
}

function Get-AvgJobDurationSec {
	param(
		[Veeam.Backup.Core.CBackupJob[]]$Job
		)
	$JobStats = $JobDurationsDatabase | Where-Object {$JobDurationsDatabase.id -eq $Job.id}
	return $JobStats.AvgDurationSec
}

function Import-JobDurationsDatabase {
	$i = 0
	While(Get-ChildItem "$DBPath/*_lock.lckfile") {
		if($i -gt 10){
			$LockingFile = Get-ChildItem "$DBPath/*_lock.lckfile"
			#Add-Log -Value "Databse is locked by $LockingFile.Name. Check the log for further details"
			Break
		}
		$i++
		Start-Sleep 5
	}
	$GUID = New-GUID
	$lockfile = New-Item -ItemType File -Path $DBPath -Name "$($GUID)_lock.lckfile"
	$JobDurationsDatabase = Import-CSV -Path $DBPath\JobDurationMonitorDatabase.csv
	Remove-Item -Path $lockfile.FullName
	return $JobDurationsDatabase
}
		
function Send-WarningEmail {
[System.Net.ServicePointManager]::SecurityProtocol = 'TLS12' #Allowed values Ssl3, Tls, Tls11, Tls12
$body= "Job $($RunningJob.Name) is taking longer than its average time. Check its status on the VBR Server"
Send-MailMessage -SmtpServer $smtp  -To $to -From $from -Subject "$($RunningJob.Name) Unusual Run Time" -Body $body
}

function Add-JobToDatabase {
	param(
		[Veeam.Backup.Core.CBackupJob[]]$Job
		)
	$JobToAdd = [PSCustomObject]@{
		JobID = $Job.id
		AvgJobDurationSec = [math]::Round((Find-AverageJobDuration -Job $Job))
		LastUpdateTime = (Get-Date)
	}
	"$($jobtoadd.Jobid),$($jobtoadd.AvgJobDurationSec),$($jobtoadd.LastUpdateTime)" | Add-Content -Path $DBPath\JobDurationMonitorDatabase.csv
}

# Core Logic

if($Monitor){
	Start-Job -ScriptBlock {
		$RunningJob = Get-JobExecutingScript
		$JobDurationsDatabase = Import-JobDurationsDatabase 
		If(-Not($JobDurationsDatabase.JobId -contains $RunningJob.id)){
			Add-JobToDatabase -Job $RunningJob
			$JobDurationsDatabase = Import-JobDurationsDatabase
		}
		$RunningJobAverage = $JobDurationsDatabase.AvgJobDurationSec | Where-Object {$_.JobID -eq $RunningJob.id}
		$SafeMargin = ([int]$RunningJobAverage * $AcceptableVariancePercent)
		Start-Sleep $RunningJobAverage
		If(Get-VBRJob -Name $RunningJob.Name).IsRunning){
			Start-Sleep ([math]::Round($SafeMargin))
			If(Get-VBRJob -Name $RunningJob.Name).IsRunning){
				Send-WarningEmail
			}
		}
	}
}

#Add Jobs to Database

if($AddJobs){
		if(-Not(Test-Path -Path $DBPath\JobDurationMonitorDatabase.csv)){
			Write-Host "Job Duration Monitor Database does not exist at the path $($DBPath)."
			Write-Host "Please run the script from an Administrative Powershell Prompt on the Veeam Server and use the -NewDatabase flag with a proper -DBPath"
		$jobs = Get-VBRJob | Out-Gridview -Passthru -Title "Pick Jobs to Add"
		foreach($j in $jobs){
			If(-Not($JobDurationsDatabase.JobId -contains $j.id)){
			Add-JobToDatabase -Job $j
		}
	}	
}	

#Create new Database

if($NewDatabase){
	Create-JobDurationsDatabase -Path $DBPath
}

