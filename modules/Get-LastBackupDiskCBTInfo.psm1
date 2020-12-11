function Get-LastBackupDiskCBTInfo {
	param (
		[object[]]$Backup
		)
		$MostRecentOibs = $backup.GetOibs()|Where-Object {$_.VMname -eq "$VMname"} | Sort-Object -Property CreationTime -Descending |Select-Object -First 1
		$LastBackupDiskCBTInfo = $MostRecentOibs.AuxData.DisksInfos
		return $LastBackupDiskCBTInfo
		}