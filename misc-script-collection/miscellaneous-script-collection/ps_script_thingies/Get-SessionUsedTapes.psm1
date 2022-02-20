<# 
Two Functions for returning tapes used by a session. 
First is just a total count of tapes used by a Backup Session; we sort by Unique to avoid redundancy in the output.
Second will create a object with the Task name and the tapes used for that task. To the best of my knowledge, the AuxData 
output should align with the Task order returned from the Tape Task Session.

Accepts CBackupTaskSessions as we need this as a basis for getting the JobSess property; else we need to go
via .NET methods which are unsupported and difficult to manage between releases. Fetch a Task Session by first using

$Tjob = Get-VBRTapeJob -name 'name of job'
$TJobSess = Get-VBRSession -Job $Sjob | Sort-Object -Property CreationTime -Descending
$TTasksess = Get-VBRTaskSession -Session $TJobSess[N]

Then you can pass $TTaskSess to the desired function



<# Don't use, unreliable as the SQL Connector is too annoying.
function Get-SesssionUsedTapes {
    param(
        [string[]]$SessionID
        )
	if(!$DBServer){
		Write-Host -ForegroundColor red '$DBServer value not found. Define $DBServer, $DBInstance, and $DBName to use this function'
		Return
	}
    $aux_data = invoke-sqlcmd -ServerInstance "$DBServer\$DBInstance" -Query "use [$DBName]; select aux_data from [backup.model.jobsessions] where id = '$SessionID'"
    [xml]$tapesxml = $aux_data.aux_data
    if($tapesxml.TapeAuxData.TapeMediums){
        $tapeNames = $tapesxml.TapeAuxData.TapeMediums.TapeMedium.Name
        }
    Return $tapeNames
    }
#>
	
function Get-TapesUsedInBackupSession {
	param(
		[Veeam.Backup.Core.CBackupTaskSession[]]$TapeTaskSession
		)
	$SessionAuxData = $TapeTaskSession.JobSess.AuxData
	$UsedTapes = @()
	Foreach($auxdata in $SessionAuxData){
		[xml]$xml = $auxdata
		$UsedTapes += $xml.TapeAuxData.TapeMediums.TapeMedium
	}
	$UsedTapes = $UsedTapes | Sort -Unique
	return $UsedTapes
}

function Get-TapesUsedPerTask {
	param(
		[Veeam.Backup.Core.CBackupTaskSession[]]$TapeTaskSession
		)
	$SessionAuxData = $TapeTaskSession.JobSess.AuxData
	$TapesUsedPerTask = @()
	$i = 0
	Foreach($auxdata in $SessionAuxData){
		[xml]$xml = $auxdata
		$UsedTapes = $xml.TapeAuxData.TapeMediums.TapeMedium
		$TaskAndTapes = "" | Select TaskName, UsedTapes
		$TaskAndTapes.TaskName = $TapeTaskSession[$i].Name
		$TaskAndTapes.UsedTapes = $UsedTapes
		$TapesUsedPerTask += $TaskAndTapes
		$i++
	}
	Return $TapesUsedPerTask
}