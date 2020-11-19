<# script returns the blocksize of Storages for a Backup and also the Repository Information.
Works for Scaleout Repos and also Local Windows/Linux (should work for XFS)
Not Tested with CIFS or CloudConnect Repos
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

$Backup = Get-VBRBackup -Name $BackupName
$RestorePoints = Get-VBRRestorePoint -Backup $Backup
$TargetRepository = $Backup.FindRepository()[0] #Jobs with Offloads will return multiple Repository Objects from FindRepository() but both will be PerformanceTier. Safe to simply set the first
$StoragesStats = $RestorePoints.FindStorage() |Sort-Object -Property CreationTime -Descending |Select-Object -Property Partialpath,BlockAlignmentSize
$Repositories = @()

If($TargetRepository.Type -eq 'ExtendableRepository'){
		$ExtentList = Get-ExtentFromScaleout -ScaleoutRepoName $TargetRepository.Name
		Foreach($Extent in $ExtentList){
			If($Extent.Type -eq "LinuxLocal"){
				$LinuxRepo = Get-LinuxRepositoryInfo -RepositoryID $Extent.id
				$RepositoryResult = Show-IsFastClonePossibleandClusterSize -BackupRepositoryInfo $LinuxRepo
				$Repositories += $RepositoryResult
			} else  {
				$WindowsRepo = Get-WindowsRepositoryInfo -RepositoryID $Extent.id
				$RepositoryResult = Show-IsFastClonePossibleandClusterSize -BackupRepositoryInfo $WindowsRepo
				$Repositories += $RepositoryResult
			}
		}
	$Repositories | Out-Host
	$StoragesStats | Out-Host
}

If($TargetRepository.Type -eq "WinLocal" -or $TargetRepository.Type -eq "LinuxLocal"){
	If($TargetRepository.Type -eq "LinuxLocal"){
		$LinuxRepo = Get-LinuxRepositoryInfo -RepositoryID $TargetRepository.id
		$RepositoryResult = Show-IsFastClonePossibleandClusterSize -BackupRepositoryInfo $LinuxRepo
		$Repositories += $RepositoryResult
	} else  {
		$WindowsRepo = Get-WindowsRepositoryInfo -RepositoryID $TargetRepository.id
		$RepositoryResult = Show-IsFastClonePossibleandClusterSize -BackupRepositoryInfo $WindowsRepo
		$Repositories += $RepositoryResult
	}
	$Repositories | Out-Host
	$StoragesStats | Out-Host
}
