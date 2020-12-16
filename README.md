# Check VMware CBT for most recent Veeam Backup

A series of Powershell modules that will check the CBT data from VMware production against Veeam Backups


## Requirements

The cmdlets must be used from a machine that meets the following requirementst

- Has VMware PowerCLI Module Installed
- Has Veeam Console Installed __and__ is connected to a Veeam Backup Server with the Backup in question
- Account used for connection  to VMware environment must have sufficient privileges for Backup Operations (just use Administrator@vsphere.local)

## Considerations

- QueryDiskChangedAreas() requires a Snapshot as an argument, so the machine will need to temporarily be on snapshot. This is called by the Coommand New-VMwareSnapshotDiskInfo
- None of the Modules currently clean up the snapshot so be sure to remove the snapshot
- There will be some margin of error between the output of the commands and the data read during backup. This is due to the time between checking, and probably the influence of snapshots. Some difference depending on the workload of the machine. (Maybe 1 GB, Could be more or less) Precise measurements under 1 MB will not be feasible based on how QueryDiskChangedAreas() works.
- Be sure you are using the exact backup there are conerns about -- different backups will record different ChangeIDs, and the results will be invalid. This testing is best done live.

### Small note

Get-LastBackupDiskCBTInfo works for HyperV as well to retrieve RCT information. Will add an HV module once I've worked it out. 


## Workflow

1. Set $VMName to the name of the VM in question
2. Set $Backup to the Backup that is in question with Get-VBRBackup
3. Use Get-LastBackupDiskCBTInfo to fetch the most recent ChangeID information for the VM in $VMName and save it to some Variable ($BackupDisks)
4. Use New-VMwareSnapshotDiskInfo to Snapshot the VM and get the current disk information, save it to some Variable ($SnapshotData). This cmdlet returns four values in a hashtable: VMView, SnapView, SnapDisk, Snapshot.
5. Loop over all disks obtained from Get-LastBackupDiskCBTInfo and perform Compare-BackupAndProducionDiskCBTInfo on them. Compare-BackupAndProducionDiskCBTInfo requires 2 Parameters sourced from New-VMwareSnapshotDiskInfo and Get-LastBackupDiskCBTInfo:

- BackupDisk: Disk information from backup. Provides the Disk key and the ChangeID
- SnapshotData: Should be the object returned by New-VMwareSnapshotDiskInfo. 

You will need to pass these from the values you stored in step 4.

6. Compare-BackupAndProducionDiskCBTInfo will print the value to console for the given disk.

### Example workflow

```
PS C:\Users\Administrator> $vmname = 'ddom_sql_test'
PS C:\Users\Administrator> $backup = Get-VBRBackup -Name 'ddom-sql'
PS C:\Users\Administrator> $backupdisks = Get-LastBackupDiskCBTInfo -Backup  $backup
PS C:\Users\Administrator> $SnapShotData = New-VMwareSnapshotDiskInfo -VMName $vmname
PS C:\Users\Administrator> foreach($Disk in $BackupDisks){
Compare-BackupAndProducionDiskCBTInfo -BackupDisk $Disk -SnapshotData $SnapShotData
}
ddom_sql_test [shared-spbsupstg04-ds06] DDom_SQL_test/DDom_SQL_test-000001.vmdk 1.359375 GB changed since last backup on 12/10/2020 00:22:15
ddom_sql_test [shared-spbsupstg04-ds06] DDom_SQL_test/DDom_SQL_test_1-000001.vmdk 0 GB changed since last backup on 12/10/2020 00:22:15
```
