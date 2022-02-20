<# Script to print a list of VMs in Backups, the Job Name, and Repository Name.
Should work for all backup types native to VBR. Not tested with Nutanix or other Plugin backups
Run from Veeam Server
$bkp can be plumbed to get more info (storages info for example)
$repo will give you more information on the repository itself
Simply add more entries to $entries as per the example and define what you want to add.
#>

Add-PSsnapin VeeamPSSnapin

$repos = Get-VBRBackupRepository
$repos += Get-VBRBackupRepository -ScaleOut
$bkps = Get-VBRBackup
$data = @()

Foreach($bkp in $bkps){
	$repo = $repos |?{$_.id -eq "$($bkp[0].RepositoryID)"}
	$vmnames = $bkp.GetObjects().DisplayName
    foreach($vm in $vmnames){
		$entries = "" | select Backup,Job,Repository
	    $entries.Backup = $vm
	    $entries.Job = $bkp.JobName
	    $entries.Repository = $repo.Name
	    $data += $entries
	}
}	
#probably just export-CSV this data
$data