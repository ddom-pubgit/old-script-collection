<# script returns the blocksize of Storages for a Backup and also the Repository Information.
Works for Scaleout Repos and also Local Windows/Linux (should work for XFS)
Not Tested with CloudConnect Repos
Currently breaks with Agent backups (all types) when returning storages, will be fixed in next version
#>

<#Todo:

- Add validation rules for EpAgentBackups (not returned by Get-VBRRestorepoint)
- Add Validation check on SOBR for non-FastClone Possible repositories, and and include Repo field for storages
#>

param (
    [string]$BackupName
    )

Add-PSSnapin VeeamPSSnapin

function Get-WindowsRepositoryInfo {
    param(
        [string[]]$RepositoryID
        )
		$WinRepositoryInfo = [Veeam.Backup.Core.CWindowsRepository]::FindByRepository("$RepositoryID")
		return $WinRepositoryInfo
	}
	
function Get-LinuxRepositoryInfo {
    param(
        [string[]]$RepositoryID
        )
		$LinuxRepositoryInfo = [Veeam.Backup.Core.CLinuxRepository]::FindByRepository("$RepositoryID") 
		return $LinuxRepositoryInfo
	}

function Get-CIFSRepositoryInfo {
	param(
		[string[]]$RepositoryID
		)
		$CIFSRepositoryInfo = [Veeam.Backup.Core.CCifsRepository]::FindByRepository("$RepositoryID") 
		return $CIFSRepositoryInfo
	}

function Get-ExtentFromScaleout {
	param(
		[string[]]$ScaleoutRepoName
		)
		$ScaleoutRepo = Get-VBRBackupRepository -Scaleout -Name $ScaleoutRepoName
		$ScaleOutExtents = $ScaleoutRepo.Extent.Repository 
		return $ScaleOutExtents
	}

function Show-IsFastClonePossibleandClusterSize {
	param(
		[Object[]]$BackupRepositoryInfo
		)
		$return = [ordered]@{
			RepositoryID = $BackupRepositoryInfo.RepositoryID
			FastClonePossible = ($BackupRepositoryInfo.IsVirtualSyntheticEnabled -and $BackupRepositoryInfo.IsVirtualSyntheticAvailable)
			RepoClusterSize = $BackupRepositoryInfo.ClusterSize
			IsDedupEnabledWinOnly = $BackupRepositoryInfo.IsDedupEnabled
		}
		return $return
	}

function Get-RepositoryTypeAndInfo {
	param(
		[Object[]]$RepositoryToCheck
	)
	If($RepositoryToCheck.Type -eq "LinuxLocal"){
		$RepoInfo = Get-LinuxRepositoryInfo -RepositoryID $RepositoryToCheck.id
	} elseif ($RepositoryToCheck.Type -eq "CifsShare") {
		$RepoInfo = Get-CIFSRepositoryInfo -RepositoryID $RepositoryToCheck.id
	} elseif ($RepositoryToCheck.Type -eq "WinLocal"){
		$RepoInfo = Get-WindowsRepositoryInfo -RepositoryID $RepositoryToCheck.id
	}
	$Repositories += (Show-IsFastClonePossibleandClusterSize -BackupRepositoryInfo $RepoInfo)
	return	$Repositories
} 	

$Backup = Get-VBRBackup -Name $BackupName
$RestorePoints = Get-VBRRestorePoint -Backup $Backup
$RepositoryToCheck = $Backup.FindRepository()[0] #Jobs with Offloads in Copy Mode will return multiple entries from FindRepository() but both will be PerformanceTier. Safe to simply set the first
$StoragesStats = $RestorePoints.FindStorage() |Sort-Object -Property CreationTime -Descending |Select-Object -Property Partialpath,BlockAlignmentSize
$Repositories = @()

If($RepositoryToCheck.Type -eq 'ExtendableRepository'){
		$ExtentList = Get-ExtentFromScaleout -ScaleoutRepoName $RepositoryToCheck.Name
		Foreach($RepositoryToCheck in $ExtentList){
			Get-RepositoryTypeAndInfo -RepositoryToCheck $RepositoryToCheck
		}
	$Repositories | Out-Host
	$StoragesStats | Out-Host
} else {
	Get-RepositoryTypeAndInfo -RepositoryToCheck $RepositoryToCheck
	$Repositories | Out-Host
	$StoragesStats | Out-Host
}
	
