<# used to get drive used, average task speed, and Library used for all tape job tasks. 
Get Job with Get-VBRTapeJob save as $Job
Get Job Session with Get-VBRSession -Job $Job save as $jSess
Get Task Sessions with Get-VBRTaskSession -Session $jSess[N] where N is the job run you want. Save as $tSess
#>


$SessResults = @()
foreach($t in $tSess){
	$LogEntries = $t.Logger.GetLog().UpdatedRecords |?{$_.Title -like "*locked successfully*"}
	$LogEntryStartTime = $t.Logger.GetLog().UpdatedRecords |?{$_.Title -like "*New tape backup session started*"}    
	$LogEntryEndTime = $t.Logger.GetLog().UpdatedRecords |?{$_.Title -like "*Processing finished at*"}
	$TaskDuration = ($LogEntryEndTime.StartTime - $LogEntryStartTime.StartTime).TotalHours
	$TaskAndSpeed = "TaskName: $($t.name) StartTime: $($LogEntryStartTime.StartTime) EndTime: $($LogEntryEndTime.StartTime) TaskSize(GiB): $($t.Progress.Totalsize/1024/1024/1024) Duration (Hours): $TaskDuration Average Speed: $($t.Progress.AvgSpeed/1024/1024)"
	$LibraryAndDrives = @()
	foreach($d in $LogEntries){
		$LibraryAndDrives += "StartTime: $($d.StartTime) Library used: $($d.Title.Split("(")[1].Split(":")[2].Split(",")[0])) DriveUsed: $($d.Title.Split("(")[0]))"
		}
	$SessResults += $TaskAndSpeed
	$SessResults += $LibraryAndDrives
}