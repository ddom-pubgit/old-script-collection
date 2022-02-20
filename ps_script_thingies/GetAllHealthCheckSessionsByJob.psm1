function Get-ListOfHealthCheckResults {
	param(
		[string[]]$JobName,
		[switch]$Allsessions = $false
		)
	$job = Get-VBRJob -name $JobName
	$Sessions = Get-VBRBackupSession |Where {$_.jobID -eq $job.id.Guid} |sort EndTimeUTC -Descending
	$HealthCheckSessions = @()
	$i = 0
	Foreach($session in $Sessions){
     $hcSession = $Session.Logger.GetLog().GetRecordsSortedByOrdinalId() | Where {$_.Title -like "*health check*"}
     if($hcSession){
          $HealthCheckSessions += $hcSession
		  if(!$Allsessions){Break}
      }
	  Write-Progress -Activity "Checking Job Sessions" -CurrentOperation "Parsing Sessions" -Status "Progress:" -PercentComplete (($i/$Sessions.Count) * 100)
	  $i++
	}
	Return $HealthCheckSessions
}