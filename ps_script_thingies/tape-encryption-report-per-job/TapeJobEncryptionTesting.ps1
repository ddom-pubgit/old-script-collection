<# Example script for fetching tape data and exproting to CSV. Note the functions are written out manually here and not imported #>

param (
    [string]$TapeJobName
    )

Add-PSSnapin VeeamPSSnapin
$LogPath = "C:\temp"
$LogName = "EncryptionStatusReport_"+$TapeJobName+".csv"
$DBserver = (Get-ItemProperty -path 'registry::HKEY_Local_machine\SOFTWARE\Veeam\Veeam Backup and Replication' -Name 'SQLSERVERNAME').SqlserverName
$DBInstance = (Get-ItemProperty -path 'registry::HKEY_Local_machine\SOFTWARE\Veeam\Veeam Backup and Replication' -Name 'SQLInstanceName').SQLInstanceName
$DBName = (Get-ItemProperty -path 'registry::HKEY_Local_machine\SOFTWARE\Veeam\Veeam Backup and Replication' -Name 'SQLDatabaseName').SqlDatabaseName

function Get-TapeSesssionUsedTapes {
    param(
        [string[]]$SessionID
        )
	if(!$DBServer){
		Write-Host -ForegroundColor red '$DBServer value not found. Define $DBServer, $DBInstance, and $DBName beforehand to use this function'
		Write-Host -ForegroundColor red 'See comments on function for details'
		Return
	}
    $aux_data = invoke-sqlcmd -ServerInstance "$DBServer\$DBInstance" -Query "use [$DBName]; select aux_data from [backup.model.jobsessions] where id = '$SessionID'"
    [xml]$tapesxml = $aux_data.aux_data
    if($tapesxml.TapeAuxData.TapeMediums){
        $tapeNames = $tapesxml.TapeAuxData.TapeMediums.TapeMedium.Name
        }
    Return $tapeNames
}

function Get-TapeSessionEncryptionStatus {
    param(
        $Session
        )
    $taskSession = Get-VBRTaskSession -Session $Session
    $EncryptionData = @()
    foreach($tSess in $taskSession){
	    $datem = "" | select TaskName, Encryption
	    $LoggerEncryptionTitle = $tSess.Logger.GetLog().GetRecordsSortedByOrdinalId() | ?{$_.Title -like '*encryption*'}
        if($LoggerEncryptionTitle){
	        $status = $LoggerEncryptionTitle.Title.ToString().Split(",")[1]
	        $datem.Encryption = $status
	        $datem.TaskName = $tSess.Name
	        $EncryptionData += $datem
            }
	    }
    return $EncryptionData
    }

function Write-LogData {
    param(
        [string[]]$LogText
        )
    Add-Content -Path $LogPath\$LogName -Value "$logentry,$LogText"
    }


$job = Get-VBRTapeJob -Name $TapeJobName
$sessions = Get-VBRSession -Job $job | Sort-Object -Property CreationTime -Descending
Write-LogData -LogText "SessionTime,SessionID,EncryptionStatus,UsedTapes"
$encryptionDisabled = @()


foreach($sess in $sessions){
	$UsedTapes = Get-TapeSesssionUsedTapes -SessionID $sess.Id
	$EncryptStat = Get-TapeSessionEncryptionStatus -Session $sess
	$logentry = "Session Run Date $($sess.CreationTime)"
	$encryptionDisabled = @()
	foreach($item in $EncryptStat){ #Check to see if any sessions were not encrypted by parsing $EncryptStat entries for disabled
		if($item.Encryption -like "*disabled"){
			$encryptionDisabled += $item.TaskName+$item.Encryption
			}
		}
	if(($encryptionDisabled.Count -eq "0") -and ($UsedTapes.Count -ne "0")){
		$encryptionDisabled += "All Tasks Encrypted"
		}
  Write-LogData -LogText "$($sess.id),$encryptionDisabled,$UsedTapes"
  Write-LogData -LogText ""
}

explorer.exe $LogPath