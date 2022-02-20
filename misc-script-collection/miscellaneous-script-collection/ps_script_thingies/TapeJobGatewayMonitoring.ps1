<# Example script for fetching tape data and exproting to CSV. Note the functions are written out manually here and not imported #>

param (
    [string]$TapeJobName
    )

Add-PSSnapin VeeamPSSnapin -ErrorAction SilentlyContinue
$LogPath = "C:\temp"
$LogName = "Gateway_monitoring_Report_"+$TapeJobName+".csv"



function Get-TapeSessionTapeServerInfo {
	param(
		$Session
		)
	$taskSession = Get-VBRTaskSession -Session $Session
	$SessionServerData = @()
	foreach($tSess in $taskSession){
		$data = "" | select TaskName,LibraryUsed
		[xml]$LoggerServerData = $tSess.Jobsess.AuxData
		$data.TaskName = $tSess.Name
		$data.LibraryUsed = $LoggerServerData.TapeAuxData.TapeLibrary.Name
		$SessionServerData += $data
		
	}
	Return $SessionServerData
}

function Write-LogData {
    param(
        [string[]]$LogText
        )
    Add-Content -Path $LogPath\$LogName -Value "$logentry,$LogText"
    }


$job = Get-VBRTapeJob -Name $TapeJobName
$sessions = Get-VBRSession -Job $job | Sort-Object -Property CreationTime -Descending
Write-LogData -LogText "SessionTime,TaskName,Server used"
$ServerUsed = @()

foreach($sess in $sessions){
	$ServerUsed = Get-TapeSessionTapeServerInfo -Session $sess
	$logentry = "Session Run Date $($sess.CreationTime)"
	foreach($item in $ServerUsed){
	Write-LogData -LogText "$($Item.TaskName),$($Item.LibraryUsed)"
	}
}
