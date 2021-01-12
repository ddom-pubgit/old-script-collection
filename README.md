# IsFastclonePossibleForBackup

A Quick Powershell Script to run on VBR to check if FastClone is possible for a Backup


## Syntax

IsFastclonePossibleForBackup.ps1 -BackupName 'name of backup in UI'

output will be in the terminal

## Files

IsFastclonePossibleForBackup.ps1 -> script you want to run. Send this to clients

modules-isfastclonepossible.psm1 -> list of modules you can import for your own use. Might be useful in some cases (see Cloud Connect repositories note)


## Note for Cloud Connect Repositories

Blocksize data for the backups will be returned, but when run on the tenant side, we cannot retrieve:

- Extent Repository Info (cluster size, dedup, fast-clone avaialble, etc)
- Storage placement across extents

This data is not exposed to Tenants

You can import the modules on the Provider side and use Get-ExtentFromScaleOut and Get-RepositoryTypeAndInfo to check the extents.

1. Save the Scaleout repository to $repo with `$repo = Get-VBRBackupRepository -Scaleout -Name 'name of the repository backing this tenant's backups'`
2. Use Get-ExtentFromScaleOut and save it to $extents: `$extentlist = Get-ExtentFromScaleout -ScaleoutRepoName $repo.Name`
3. Loop over extents:  `foreach($extent in $extents){Get-RepositoryTypeAndInfo -RepositoryToCheck $Extent}`

