for($i=0;$i-lt $($RepoTest.Count)-1;$i++){
Write-Host "Count = $i  Value = $($RepoTest[$i])"
 }
 
 
foreach($p in $REPOSITORIESLIST){
$Split = $p.Split(",")
Write-Host "$($Split.Count) $($Split[15])"
}

For Repositories need to split on commas and write logic.
Do not try to split on : cause it adds spaces so more string parsing

Sample output:

Count = 0  Value = [08.10.2021 12:07:16] <01> Info         RepositoryID: e363ecf2-e5e6-4eaa-9c6d-e011d9f5c680
Count = 1  Value =  Type: LinuxLocal
Count = 2  Value =  TotalSpace: 42007232512
Count = 3  Value =  FreeSpace: 888541184
Count = 4  Value =  ConcurrentTaskLimit: {Enabled: False
Count = 5  Value =  Number: "-1"}
Count = 6  Value =  RWrateLimit: {Enabled: False
Count = 7  Value =  MBs: "0"}
Count = 8  Value =  OnRotatedDrive: False
Count = 9  Value =  AlignFileBlocks: True
Count = 10  Value =  DecompressBeforeStoring: False
Count = 11  Value =  PerVMbackup: False
Count = 12  Value =  vPowerNFS: True
Count = 13  Value =  ProxyAffinitySet: False
Count = 14  Value =  ServerID: d65fa4cc-5ffe-4232-ac8c-4554081d74a7
Count = 15  Value =  OS Name: Debian x64
Count = 16  Value =  OS version: 4.9.189
Count = 17  Value =  CoresCount: 2
Count = 18  Value =  CPUCount: 2
Count = 19  Value =  RAMTotalSize: 4147994624
Count = 20  Value =  RepositoryGroupType: BackupRepository
Count = 21  Value =  XFSFastCloneEnabled: False
Count = 22  Value =  ImmutabilitySettings: { Enabled: False

1
25  Type: WinLocal
25  Type: WinLocal
25  Type: WinLocal
25  Type: WinLocal
25  Type: WinLocal
25  Type: WinLocal
25  Type: WinLocal
25  Type: WinLocal
25  Type: WinLocal
25  Type: WinLocal
25  Type: WinLocal
25  Type: WinLocal
24  Type: LinuxLocal
24  Type: LinuxLocal
24  Type: LinuxLocal
24  Type: LinuxLocal
24  Type: LinuxLocal
24  Type: LinuxLocal
21  Type: DDBoost
16  Type: Cloud
15  Type: ExaGrid
15  Type: SanSnapshotOnly
21  Type: HPStoreOnceIntegration
21  Type: HPStoreOnceIntegration
21  Type: HPStoreOnceIntegration
21  Type: HPStoreOnceIntegration
15  Type: Nfs
15  Type: S3CompatibleObjStg
15  Type: IBMCloudObjStg
9  Type: AmazonS3External
18  Type: AmazonS3ObjStg
15  Type: S3CompatibleObjStg
15  Type: S3CompatibleObjStg
15  Type: IBMCloudObjStg
15  Type: S3CompatibleObjStg
15  Type: S3CompatibleObjStg
18  Type: AmazonS3ObjStg
15  Type: S3CompatibleObjStg
15  Type: S3CompatibleObjStg
16  Type: AmazonGlacierObjStg
18  Type: AmazonS3ObjStg
13  Type: AzureObjStg
9  Type: AmazonS3External
9  Type: AzureStorageExternal
15  Type: S3CompatibleObjStg
199  Type: ExtendableRepository
198  Type: ExtendableRepository
198  Type: ExtendableRepository
196  Type: ExtendableRepository
29  Type: ExtendableRepository
197  Type: ExtendableRepository
200  Type: ExtendableRepository
29  Type: ExtendableRepository
199  Type: ExtendableRepository
2  Collection time: 00:00:22

"$($DataSplit[0].Split()[1].Substring(0,$($DataSplit[0].Split()[1].Length-1)))"=$DataSplit[0].Split()[2]
"$($DataSplit[1].Split()[1].Substring(0,$($DataSplit[1].Split()[1].Length-1)))"=$DataSplit[1].Split()[2]
"$($DataSplit[2].Split()[1].Substring(0,$($DataSplit[2].Split()[1].Length-1)))"=$DataSplit[2].Split()[2]
"$($DataSplit[3].Split()[1].Substring(0,$($DataSplit[3].Split()[1].Length-1)))"=$DataSplit[3].Split()[2]
"$($DataSplit[4].Split()[1].Substring(0,$($DataSplit[4].Split()[1].Length-1)))"=$DataSplit[4].Split()[2]
"$($DataSplit[5].Split()[1].Substring(0,$($DataSplit[5].Split()[1].Length-1)))"=$DataSplit[5].Split()[2]
"$($DataSplit[6].Split()[1].Substring(0,$($DataSplit[6].Split()[1].Length-1)))"=$DataSplit[6].Split()[2]
"$($DataSplit[7].Split()[1].Substring(0,$($DataSplit[7].Split()[1].Length-1)))"=$DataSplit[7].Split()[2]
"$($DataSplit[8].Split()[1].Substring(0,$($DataSplit[8].Split()[1].Length-1)))"=$DataSplit[8].Split()[2]
"$($DataSplit[9].Split()[1].Substring(0,$($DataSplit[9].Split()[1].Length-1)))"=$DataSplit[9].Split()[2]
"$($DataSplit[10].Split()[1].Substring(0,$($DataSplit[10].Split()[1].Length-1)))"=$DataSplit[10].Split()[2]
"$($DataSplit[11].Split()[1].Substring(0,$($DataSplit[11].Split()[1].Length-1)))"=$DataSplit[11].Split()[2]
"$($DataSplit[12].Split()[1].Substring(0,$($DataSplit[12].Split()[1].Length-1)))"=$DataSplit[12].Split()[2]
"$($DataSplit[13].Split()[1].Substring(0,$($DataSplit[13].Split()[1].Length-1)))"=$DataSplit[13].Split()[2]
"$($DataSplit[14].Split()[1].Substring(0,$($DataSplit[14].Split()[1].Length-1)))"=$DataSplit[14].Split()[2]
"$($DataSplit[15].Split()[1].Substring(0,$($DataSplit[15].Split()[1].Length-1)))"=$DataSplit[15].Split()[2]
"$($DataSplit[16].Split()[1].Substring(0,$($DataSplit[16].Split()[1].Length-1)))"=$DataSplit[16].Split()[2]
"$($DataSplit[17].Split()[1].Substring(0,$($DataSplit[17].Split()[1].Length-1)))"=$DataSplit[17].Split()[2]
"$($DataSplit[18].Split()[1].Substring(0,$($DataSplit[18].Split()[1].Length-1)))"=$DataSplit[18].Split()[2]
"$($DataSplit[19].Split()[1].Substring(0,$($DataSplit[19].Split()[1].Length-1)))"=$DataSplit[19].Split()[2]
"$($DataSplit[20].Split()[1].Substring(0,$($DataSplit[20].Split()[1].Length-1)))"=$DataSplit[20].Split()[2]
"$($DataSplit[21].Split()[1].Substring(0,$($DataSplit[21].Split()[1].Length-1)))"=$DataSplit[21].Split()[2]
"$($DataSplit[22].Split()[1].Substring(0,$($DataSplit[22].Split()[1].Length-1)))"=$DataSplit[22].Split()[2]
"$($DataSplit[23].Split()[1].Substring(0,$($DataSplit[23].Split()[1].Length-1)))"=$DataSplit[23].Split()[2]
"$($DataSplit[24].Split()[1].Substring(0,$($DataSplit[24].Split()[1].Length-1)))"=$DataSplit[24].Split()[2]
"$($DataSplit[25].Split()[1].Substring(0,$($DataSplit[25].Split()[1].Length-1)))"=$DataSplit[25].Split()[2]
"$($DataSplit[26].Split()[1].Substring(0,$($DataSplit[26].Split()[1].Length-1)))"=$DataSplit[26].Split()[2]
"$($DataSplit[27].Split()[1].Substring(0,$($DataSplit[27].Split()[1].Length-1)))"=$DataSplit[27].Split()[2]
"$($DataSplit[28].Split()[1].Substring(0,$($DataSplit[28].Split()[1].Length-1)))"=$DataSplit[28].Split()[2]
"$($DataSplit[29].Split()[1].Substring(0,$($DataSplit[29].Split()[1].Length-1)))"=$DataSplit[29].Split()[2]


"$($DataSplit[0].Substring(0,$($DataSplit[0].Length-1)))"=$DataSplit[1].Substring(0,$($DataSplit[1].Length-1))
"$($DataSplit[2].Substring(0,$($DataSplit[2].Length-1)))"=$DataSplit[3].Substring(0,$($DataSplit[3].Length-1))
"$($DataSplit[4].Substring(0,$($DataSplit[4].Length-1)))"=$DataSplit[5].Substring(0,$($DataSplit[5].Length-1))
"$($DataSplit[6].Substring(0,$($DataSplit[6].Length-1)))"=$DataSplit[7].Substring(0,$($DataSplit[7].Length-1))
"$($DataSplit[8].Substring(0,$($DataSplit[8].Length-1)))"=$DataSplit[9].Substring(0,$($DataSplit[9].Length-1))
"$($DataSplit[10].Substring(0,$($DataSplit[10].Length-1)))"=$DataSplit[11].Substring(0,$($DataSplit[11].Length-1))
"$($DataSplit[12].Substring(0,$($DataSplit[12].Length-1)))"=$DataSplit[13].Substring(0,$($DataSplit[13].Length-1))
"$($DataSplit[14].Substring(0,$($DataSplit[14].Length-1)))"=$DataSplit[15].Substring(0,$($DataSplit[15].Length-1))
"$($DataSplit[16].Substring(0,$($DataSplit[16].Length-1)))"=$DataSplit[17].Substring(0,$($DataSplit[17].Length-1))
"$($DataSplit[18].Substring(0,$($DataSplit[18].Length-1)))"=$DataSplit[19].Substring(0,$($DataSplit[19].Length-1))
"$($DataSplit[20].Substring(0,$($DataSplit[20].Length-1)))"=$DataSplit[21].Substring(0,$($DataSplit[21].Length-1))
"$($DataSplit[22].Substring(0,$($DataSplit[22].Length-1)))"=$DataSplit[23].Substring(0,$($DataSplit[23].Length-1))
"$($DataSplit[24].Substring(0,$($DataSplit[24].Length-1)))"=$DataSplit[25].Substring(0,$($DataSplit[25].Length-1))
"$($DataSplit[26].Substring(0,$($DataSplit[26].Length-1)))"=$DataSplit[27].Substring(0,$($DataSplit[27].Length-1))
"$($DataSplit[28].Substring(0,$($DataSplit[28].Length-1)))"=$DataSplit[29].Substring(0,$($DataSplit[29].Length-1))
"$($DataSplit[30].Substring(0,$($DataSplit[30].Length-1)))"=$DataSplit[31].Substring(0,$($DataSplit[31].Length-1))
"$($DataSplit[32].Substring(0,$($DataSplit[32].Length-1)))"=$DataSplit[33].Substring(0,$($DataSplit[33].Length-1))
"$($DataSplit[34].Substring(0,$($DataSplit[34].Length-1)))"=$DataSplit[35].Substring(0,$($DataSplit[35].Length-1))
"$($DataSplit[36].Substring(0,$($DataSplit[36].Length-1)))"=$DataSplit[37].Substring(0,$($DataSplit[37].Length-1))
"$($DataSplit[38].Substring(0,$($DataSplit[38].Length-1)))"=$DataSplit[39].Substring(0,$($DataSplit[39].Length-1))
"$($DataSplit[40].Substring(0,$($DataSplit[40].Length-1)))"=$DataSplit[41].Substring(0,$($DataSplit[41].Length-1))
"$($DataSplit[42].Substring(0,$($DataSplit[42].Length-1)))"=$DataSplit[43].Substring(0,$($DataSplit[43].Length-1))
"$($DataSplit[44].Substring(0,$($DataSplit[44].Length-1)))"=$DataSplit[45].Substring(0,$($DataSplit[45].Length-1))
"$($DataSplit[46].Substring(0,$($DataSplit[46].Length-1)))"=$DataSplit[47].Substring(0,$($DataSplit[47].Length-1))
"$($DataSplit[48].Substring(0,$($DataSplit[48].Length-1)))"=$DataSplit[49].Substring(0,$($DataSplit[49].Length-1))
"$($DataSplit[50].Substring(0,$($DataSplit[50].Length-1)))"=$DataSplit[51].Substring(0,$($DataSplit[51].Length-1))
"$($DataSplit[52].Substring(0,$($DataSplit[52].Length-1)))"=$DataSplit[53].Substring(0,$($DataSplit[53].Length-1))
"$($DataSplit[54].Substring(0,$($DataSplit[54].Length-1)))"=$DataSplit[55].Substring(0,$($DataSplit[55].Length-1))
"$($DataSplit[56].Substring(0,$($DataSplit[56].Length-1)))"=$DataSplit[57].Substring(0,$($DataSplit[57].Length-1))
"$($DataSplit[58].Substring(0,$($DataSplit[58].Length-1)))"=$DataSplit[59].Substring(0,$($DataSplit[59].Length-1))
"$($DataSplit[60].Substring(0,$($DataSplit[60].Length-1)))"=$DataSplit[61].Substring(0,$($DataSplit[61].Length-1))
"$($DataSplit[62].Substring(0,$($DataSplit[62].Length-1)))"=$DataSplit[63].Substring(0,$($DataSplit[63].Length-1))
"$($DataSplit[64].Substring(0,$($DataSplit[64].Length-1)))"=$DataSplit[65].Substring(0,$($DataSplit[65].Length-1))
"$($DataSplit[66].Substring(0,$($DataSplit[66].Length-1)))"=$DataSplit[67].Substring(0,$($DataSplit[67].Length-1))
"$($DataSplit[68].Substring(0,$($DataSplit[68].Length-1)))"=$DataSplit[69].Substring(0,$($DataSplit[69].Length-1))
"$($DataSplit[70].Substring(0,$($DataSplit[70].Length-1)))"=$DataSplit[71].Substring(0,$($DataSplit[71].Length-1))
"$($DataSplit[72].Substring(0,$($DataSplit[72].Length-1)))"=$DataSplit[73].Substring(0,$($DataSplit[73].Length-1))
"$($DataSplit[74].Substring(0,$($DataSplit[74].Length-1)))"=$DataSplit[75].Substring(0,$($DataSplit[75].Length-1))
"$($DataSplit[76].Substring(0,$($DataSplit[76].Length-1)))"=$DataSplit[77].Substring(0,$($DataSplit[77].Length-1))
"$($DataSplit[78].Substring(0,$($DataSplit[78].Length-1)))"=$DataSplit[79].Substring(0,$($DataSplit[79].Length-1))
"$($DataSplit[80].Substring(0,$($DataSplit[80].Length-1)))"=$DataSplit[81].Substring(0,$($DataSplit[81].Length-1))
"$($DataSplit[82].Substring(0,$($DataSplit[82].Length-1)))"=$DataSplit[83].Substring(0,$($DataSplit[83].Length-1))
"$($DataSplit[84].Substring(0,$($DataSplit[84].Length-1)))"=$DataSplit[85].Substring(0,$($DataSplit[85].Length-1))
"$($DataSplit[86].Substring(0,$($DataSplit[86].Length-1)))"=$DataSplit[87].Substring(0,$($DataSplit[87].Length-1))
"$($DataSplit[88].Substring(0,$($DataSplit[88].Length-1)))"=$DataSplit[89].Substring(0,$($DataSplit[89].Length-1))
"$($DataSplit[90].Substring(0,$($DataSplit[90].Length-1)))"=$DataSplit[91].Substring(0,$($DataSplit[91].Length-1))
"$($DataSplit[92].Substring(0,$($DataSplit[92].Length-1)))"=$DataSplit[93].Substring(0,$($DataSplit[93].Length-1))
"$($DataSplit[94].Substring(0,$($DataSplit[94].Length-1)))"=$DataSplit[95].Substring(0,$($DataSplit[95].Length-1))
"$($DataSplit[96].Substring(0,$($DataSplit[96].Length-1)))"=$DataSplit[97].Substring(0,$($DataSplit[97].Length-1))
"$($DataSplit[98].Substring(0,$($DataSplit[98].Length-1)))"=$DataSplit[99].Substring(0,$($DataSplit[99].Length-1))
"$($DataSplit[100].Substring(0,$($DataSplit[100].Length-1)))"=$DataSplit[101].Substring(0,$($DataSplit[101].Length-1))

Old Repository Parser, don`'t use

function Create-RepositoryObject {
	param(
		[string]$RInput
		)
	$DataSplit = $RInput.Split()
	switch($DataSplit.Count)
	{
		44 {$RepositoryObject = [PSCustomObject]@{
				"$($DataSplit[12].Substring(0,$($DataSplit[12].Length-1)))"=$DataSplit[13].Substring(0,$($DataSplit[13].Length-1))
				"$($DataSplit[14].Substring(0,$($DataSplit[14].Length-1)))"=$DataSplit[15].Substring(0,$($DataSplit[15].Length-1))
				"$($DataSplit[16].Substring(0,$($DataSplit[16].Length-1)))"=$DataSplit[17].Substring(0,$($DataSplit[17].Length-1))
				"$($DataSplit[18].Substring(0,$($DataSplit[18].Length-1)))"=$DataSplit[19].Substring(0,$($DataSplit[19].Length-1))
				"ConcurrentTaskLimitEnabled"=$DataSplit[22].Substring(0,$($DataSplit[22].Length-1))
				"$($DataSplit[23].Substring(0,$($DataSplit[23].Length-1)))"=$DataSplit[24].Substring(1,1)
			}
		}
		56 {$RepositoryObject = [PSCustomObject]@{
				"$($DataSplit[12].Substring(0,$($DataSplit[12].Length-1)))"=$DataSplit[13].Substring(0,$($DataSplit[13].Length-1))
				"$($DataSplit[14].Substring(0,$($DataSplit[14].Length-1)))"=$DataSplit[15].Substring(0,$($DataSplit[15].Length-1))
				"$($DataSplit[16].Substring(0,$($DataSplit[16].Length-1)))"=$DataSplit[17].Substring(0,$($DataSplit[17].Length-1))
				"$($DataSplit[18].Substring(0,$($DataSplit[18].Length-1)))"=$DataSplit[19].Substring(0,$($DataSplit[19].Length-1))
				"ConcurrentTaskLimitEnabled"=$DataSplit[22].Substring(0,$($DataSplit[22].Length-1))
				"$($DataSplit[23].Substring(0,$($DataSplit[23].Length-1)))"=$DataSplit[24].Substring(1,1)
				"$($DataSplit[46].Substring(0,$($DataSplit[46].Length-1)))"=$DataSplit[47].Substring(0,$($DataSplit[47].Length-1))
				"GatewayserverID"=$DataSplit[49].Substring(0,$($DataSplit[49].Length-1))
				"$($DataSplit[50].Substring(0,$($DataSplit[50].Length-1)))"=$DataSplit[51].Substring(0,$($DataSplit[51].Length-1))
				"$($DataSplit[52].Substring(0,$($DataSplit[52].Length-1)))"=$DataSplit[53].Substring(0,$($DataSplit[53].Length-1))
			}
		}
		62 {$RepositoryObject = [PSCustomObject]@{
				"$($DataSplit[12].Substring(0,$($DataSplit[12].Length-1)))"=$DataSplit[13].Substring(0,$($DataSplit[13].Length-1))
				"$($DataSplit[14].Substring(0,$($DataSplit[14].Length-1)))"=$DataSplit[15].Substring(0,$($DataSplit[15].Length-1))
				"$($DataSplit[16].Substring(0,$($DataSplit[16].Length-1)))"=$DataSplit[17].Substring(0,$($DataSplit[17].Length-1))
				"$($DataSplit[18].Substring(0,$($DataSplit[18].Length-1)))"=$DataSplit[19].Substring(0,$($DataSplit[19].Length-1))
				"ConcurrentTaskLimitEnabled"=$DataSplit[22].Substring(0,$($DataSplit[22].Length-1))
				"$($DataSplit[23].Substring(0,$($DataSplit[23].Length-1)))"=$DataSplit[24].Substring(1,1)
				"$($DataSplit[30].Substring(0,$($DataSplit[30].Length-1)))"=$DataSplit[31].Substring(0,$($DataSplit[31].Length-1))
				"$($DataSplit[32].Substring(0,$($DataSplit[32].Length-1)))"=$DataSplit[33].Substring(0,$($DataSplit[33].Length-1))
				"$($DataSplit[46].Substring(0,$($DataSplit[46].Length-1)))"=$DataSplit[47].Substring(0,$($DataSplit[47].Length-1))
				"GatewayserverID"=$DataSplit[49].Substring(0,$($DataSplit[49].Length-1))
				"$($DataSplit[55].Substring(0,$($DataSplit[55].Length-1)))"=$DataSplit[59].Substring(0,$($DataSplit[59].Length-1))
			}
		}
		67 	{$RepositoryObject = [PSCustomObject]@{
				"$($DataSplit[12].Substring(0,$($DataSplit[12].Length-1)))"=$DataSplit[13].Substring(0,$($DataSplit[13].Length-1))
				"$($DataSplit[14].Substring(0,$($DataSplit[14].Length-1)))"=$DataSplit[15].Substring(0,$($DataSplit[15].Length-1))
				"$($DataSplit[16].Substring(0,$($DataSplit[16].Length-1)))"=$DataSplit[17].Substring(0,$($DataSplit[17].Length-1))
				"$($DataSplit[18].Substring(0,$($DataSplit[18].Length-1)))"=$DataSplit[19].Substring(0,$($DataSplit[19].Length-1))
				"ConcurrentTaskLimitEnabled"=$DataSplit[22].Substring(0,$($DataSplit[22].Length-1))
				"$($DataSplit[23].Substring(0,$($DataSplit[23].Length-1)))"=$DataSplit[24].Substring(1,1)
				"$($DataSplit[30].Substring(0,$($DataSplit[30].Length-1)))"=$DataSplit[31].Substring(0,$($DataSplit[31].Length-1))
				"$($DataSplit[32].Substring(0,$($DataSplit[32].Length-1)))"=$DataSplit[33].Substring(0,$($DataSplit[33].Length-1))
				"$($DataSplit[42].Substring(0,$($DataSplit[42].Length-1)))"=$DataSplit[43].Substring(0,$($DataSplit[43].Length-1))
				"$($DataSplit[51].Substring(0,$($DataSplit[51].Length-1)))"=$DataSplit[52].Substring(0,$($DataSplit[52].Length-1))
				"$($DataSplit[53].Substring(0,$($DataSplit[53].Length-1)))"=$DataSplit[54].Substring(0,$($DataSplit[54].Length-1))
				"$($DataSplit[55].Substring(0,$($DataSplit[55].Length-1)))"=$DataSplit[56].Substring(0,$($DataSplit[56].Length-1))
			}
		}
		68 	{$RepositoryObject = [PSCustomObject]@{
				"$($DataSplit[12].Substring(0,$($DataSplit[12].Length-1)))"=$DataSplit[13].Substring(0,$($DataSplit[13].Length-1))
				"$($DataSplit[14].Substring(0,$($DataSplit[14].Length-1)))"=$DataSplit[15].Substring(0,$($DataSplit[15].Length-1))
				"$($DataSplit[16].Substring(0,$($DataSplit[16].Length-1)))"=$DataSplit[17].Substring(0,$($DataSplit[17].Length-1))
				"$($DataSplit[18].Substring(0,$($DataSplit[18].Length-1)))"=$DataSplit[19].Substring(0,$($DataSplit[19].Length-1))
				"ConcurrentTaskLimitEnabled"=$DataSplit[22].Substring(0,$($DataSplit[22].Length-1))
				"$($DataSplit[23].Substring(0,$($DataSplit[23].Length-1)))"=$DataSplit[24].Substring(1,1)
				"$($DataSplit[30].Substring(0,$($DataSplit[30].Length-1)))"=$DataSplit[31].Substring(0,$($DataSplit[31].Length-1))
				"$($DataSplit[32].Substring(0,$($DataSplit[32].Length-1)))"=$DataSplit[33].Substring(0,$($DataSplit[33].Length-1))
				"$($DataSplit[42].Substring(0,$($DataSplit[42].Length-1)))"=$DataSplit[43].Substring(0,$($DataSplit[43].Length-1))
				"$($DataSplit[51].Substring(0,$($DataSplit[51].Length-1)))"=$DataSplit[52].Substring(0,$($DataSplit[52].Length-1))
				"$($DataSplit[53].Substring(0,$($DataSplit[53].Length-1)))"=$DataSplit[54].Substring(0,$($DataSplit[54].Length-1))
				"$($DataSplit[55].Substring(0,$($DataSplit[55].Length-1)))"=$DataSplit[56].Substring(0,$($DataSplit[56].Length-1))
			}
		}
		72 {$RepositoryObject = [PSCustomObject]@{
				"$($DataSplit[12].Substring(0,$($DataSplit[12].Length-1)))"=$DataSplit[13].Substring(0,$($DataSplit[13].Length-1))
				"$($DataSplit[14].Substring(0,$($DataSplit[14].Length-1)))"=$DataSplit[15].Substring(0,$($DataSplit[15].Length-1))
				"$($DataSplit[16].Substring(0,$($DataSplit[16].Length-1)))"=$DataSplit[17].Substring(0,$($DataSplit[17].Length-1))
				"$($DataSplit[18].Substring(0,$($DataSplit[18].Length-1)))"=$DataSplit[19].Substring(0,$($DataSplit[19].Length-1))
				"ConcurrentTaskLimitEnabled"=$DataSplit[22].Substring(0,$($DataSplit[22].Length-1))
				"$($DataSplit[23].Substring(0,$($DataSplit[23].Length-1)))"=$DataSplit[24].Substring(1,1)
				"$($DataSplit[30].Substring(0,$($DataSplit[30].Length-1)))"=$DataSplit[31].Substring(0,$($DataSplit[31].Length-1))
				"$($DataSplit[32].Substring(0,$($DataSplit[32].Length-1)))"=$DataSplit[33].Substring(0,$($DataSplit[33].Length-1))
				"$($DataSplit[46].Substring(0,$($DataSplit[46].Length-1)))"=$DataSplit[47].Substring(0,$($DataSplit[47].Length-1))
				"$($DataSplit[50].Substring(0,$($DataSplit[50].Length-1)))"=$DataSplit[51].Substring(0,$($DataSplit[51].Length-1))
				"$($DataSplit[64].Substring(0,$($DataSplit[64].Length-1)))"=$DataSplit[65].Substring(0,$($DataSplit[65].Length-1))
				"$($DataSplit[66].Substring(0,$($DataSplit[66].Length-1)))"=$DataSplit[67].Substring(0,$($DataSplit[67].Length-1))
				"$($DataSplit[68].Substring(0,$($DataSplit[68].Length-1)))"=$DataSplit[69].Substring(0,$($DataSplit[69].Length-1))
			}
		}
		Default{Continue}
	}
	return $RepositoryObject
}

#Will rewrite it all =,=

function Create-ProxyObject {
	param(
		[String]$PInput
	)
	$DataSplit = $PInput.Split()
	switch($DataSplit.Count)
	{
		26 {$ProxyObject = [PSCustomObject]@{
				"$($DataSplit[12].Substring(0,$($DataSplit[12].Length-1)))"=$DataSplit[13].Substring(0,$($DataSplit[13].Length-1))
				"$($DataSplit[14].Substring(0,$($DataSplit[14].Length-1)))"=$DataSplit[15].Substring(0,$($DataSplit[15].Length-1))
				"$($DataSplit[16].Substring(0,$($DataSplit[16].Length-1)))"=$DataSplit[17].Substring(0,$($DataSplit[17].Length-1))
				"$($DataSplit[18].Substring(0,$($DataSplit[18].Length-1)))"=$DataSplit[19].Substring(0,$($DataSplit[19].Length-1))
				"$($DataSplit[20].Substring(0,$($DataSplit[20].Length-1)))"=$DataSplit[21].Substring(0,$($DataSplit[21].Length-1))
				"$($DataSplit[22].Substring(0,$($DataSplit[22].Length-1)))"=$DataSplit[23].Substring(0,$($DataSplit[23].Length-1))
				"$($DataSplit[24].Substring(0,$($DataSplit[24].Length-1)))"=$DataSplit[25].Substring(0,$($DataSplit[25].Length))
				}
		}
		20 {$ProxyObject = [PSCustomObject]@{
				"$($DataSplit[12].Substring(0,$($DataSplit[12].Length-1)))"=$DataSplit[13].Substring(0,$($DataSplit[13].Length-1))
				"$($DataSplit[14].Substring(0,$($DataSplit[14].Length-1)))"=$DataSplit[15].Substring(0,$($DataSplit[15].Length-1))
				"$($DataSplit[16].Substring(0,$($DataSplit[16].Length-1)))"=$DataSplit[17].Substring(0,$($DataSplit[17].Length-1))
				"$($DataSplit[18].Substring(0,$($DataSplit[18].Length-1)))"=$DataSplit[19].Substring(0,$($DataSplit[19].Length))
			}
		}
		40 {$ProxyObject = [PSCustomObject]@{
				"$($DataSplit[12].Substring(0,$($DataSplit[12].Length-1)))"=$DataSplit[13].Substring(0,$($DataSplit[13].Length-1))
				"$($DataSplit[14].Substring(0,$($DataSplit[14].Length-1)))"=$DataSplit[15].Substring(0,$($DataSplit[15].Length-1))
				"$($DataSplit[16].Substring(0,$($DataSplit[16].Length-1)))"=$DataSplit[17].Substring(0,$($DataSplit[17].Length-1))
				"$($DataSplit[18].Substring(0,$($DataSplit[18].Length-1)))"=$DataSplit[19].Substring(0,$($DataSplit[19].Length-1))
				"$($DataSplit[20].Substring(0,$($DataSplit[20].Length-1)))"=$DataSplit[21].Substring(0,$($DataSplit[21].Length-1))
				"$($DataSplit[22].Substring(0,$($DataSplit[22].Length-1)))"=$DataSplit[23].Substring(0,$($DataSplit[23].Length-1))
				"$($DataSplit[24].Substring(0,$($DataSplit[24].Length-1)))"=$DataSplit[25].Substring(0,$($DataSplit[25].Length-1))
				"$($DataSplit[26].Substring(0,$($DataSplit[26].Length-1)))"=$DataSplit[27].Substring(0,$($DataSplit[27].Length-1))
				"$($DataSplit[34].Substring(0,$($DataSplit[34].Length-1)))"=$DataSplit[35].Substring(0,$($DataSplit[35].Length-1))
				"$($DataSplit[36].Substring(0,$($DataSplit[36].Length-1)))"=$DataSplit[37].Substring(0,$($DataSplit[37].Length-1))
				"$($DataSplit[38].Substring(0,$($DataSplit[38].Length-1)))"=$DataSplit[39].Substring(0,$($DataSplit[39].Length-1))
			}
		}
	}
	Return $ProxyObject
}

function Create-RepositoryObject {
	param(
		[string]$RInput
		)
	$DataSplit = $RInput.Split(",")
	switch($DataSplit.Count)
	{
		24 {$RepositoryObject = [PSCustomObject]@{
				"$($DataSplit[0].Split()[12].Substring(0,$($DataSplit[0].Split()[12].Length-1)))"=$DataSplit[0].Split()[13]
				"$($DataSplit[1].Split()[1].Substring(0,$($DataSplit[1].Split()[1].Length-1)))"=$DataSplit[1].Split()[2]
				"$($DataSplit[2].Split()[1].Substring(0,$($DataSplit[2].Split()[1].Length-1)))"=$DataSplit[2].Split()[2]
				"$($DataSplit[3].Split()[1].Substring(0,$($DataSplit[3].Split()[1].Length-1)))"=$DataSplit[3].Split()[2]
				"ConcurrentTaskLimitEnabled"=$DataSplit[4].Split()[3]
				"$($DataSplit[5].Split()[1].Substring(0,$($DataSplit[5].Split()[1].Length-1)))"=$DataSplit[5].Split()[2].Substring(1,1)
				"$($DataSplit[9].Split()[1].Substring(0,$($DataSplit[9].Split()[1].Length-1)))"=$DataSplit[9].Split()[2]
				"$($DataSplit[14].Split()[1].Substring(0,$($DataSplit[14].Split()[1].Length-1)))"=$DataSplit[14].Split()[2]
				"$($DataSplit[15].Split(":")[0].SubString(1,$spliter[15].Split(":")[0].Length-1))"=$DataSplit[15].Split(":")[1].Substring(1,$DataSplit[15].Split(":")[1].Length-1)
				"$($DataSplit[16].Split(":")[0].SubString(1,$spliter[16].Split(":")[0].Length-1))"=$DataSplit[16].Split(":")[1].Substring(1,$DataSplit[16].Split(":")[1].Length-1)
				"$($DataSplit[17].Split()[1].Substring(0,$($DataSplit[17].Split()[1].Length-1)))"=$DataSplit[17].Split()[2]
				"$($DataSplit[18].Split()[1].Substring(0,$($DataSplit[18].Split()[1].Length-1)))"=$DataSplit[18].Split()[2]
				"$($DataSplit[19].Split()[1].Substring(0,$($DataSplit[19].Split()[1].Length-1)))"=$DataSplit[19].Split()[2]
			}
		}
		25 {$RepositoryObject = [PSCustomObject]@{
				"$($DataSplit[0].Split()[12].Substring(0,$($DataSplit[0].Split()[12].Length-1)))"=$DataSplit[0].Split()[13]
				"$($DataSplit[1].Split()[1].Substring(0,$($DataSplit[1].Split()[1].Length-1)))"=$DataSplit[1].Split()[2]
				"$($DataSplit[2].Split()[1].Substring(0,$($DataSplit[2].Split()[1].Length-1)))"=$DataSplit[2].Split()[2]
				"$($DataSplit[3].Split()[1].Substring(0,$($DataSplit[3].Split()[1].Length-1)))"=$DataSplit[3].Split()[2]
				"ConcurrentTaskLimitEnabled"=$DataSplit[4].Split()[3]
				"$($DataSplit[5].Split()[1].Substring(0,$($DataSplit[5].Split()[1].Length-1)))"=$DataSplit[5].Split()[2].Substring(1,1)
				"$($DataSplit[9].Split()[1].Substring(0,$($DataSplit[9].Split()[1].Length-1)))"=$DataSplit[9].Split()[2]
				"$($DataSplit[14].Split()[1].Substring(0,$($DataSplit[14].Split()[1].Length-1)))"=$DataSplit[14].Split()[2]
				"$($DataSplit[15].Split()[1].Substring(0,$($DataSplit[15].Split()[1].Length-1)))"=$DataSplit[15].Split()[2]
				"$($DataSplit[16].Split()[1].Substring(0,$($DataSplit[16].Split()[1].Length-1)))"=$DataSplit[16].Split()[2]
				"$($DataSplit[17].Split()[1].Substring(0,$($DataSplit[17].Split()[1].Length-1)))"=$DataSplit[17].Split()[2]
				"$($DataSplit[18].Split()[1].Substring(0,$($DataSplit[18].Split()[1].Length-1)))"=$DataSplit[18].Split()[2]
				"$($DataSplit[19].Split(":")[0].SubString(1,$DataSplit[19].Split(":")[0].Length-1))"=$DataSplit[19].Split(":")[1].Substring(1,$DataSplit[19].Split(":")[1].Length-1)
				"$($DataSplit[20].Split(":")[0].Substring(1,$DataSplit[20].Split(":")[0].Length-1))"=$DataSplit[20].Split(":")[1].Substring(1,$DataSplit[20].Split(":")[1].Length-1)
				"$($DataSplit[21].Split()[1].Substring(0,$($DataSplit[21].Split()[1].Length-1)))"=$DataSplit[21].Split()[2]
				"$($DataSplit[22].Split()[1].Substring(0,$($DataSplit[22].Split()[1].Length-1)))"=$DataSplit[22].Split()[2]
				"$($DataSplit[23].Split()[1].Substring(0,$($DataSplit[23].Split()[1].Length-1)))"=$DataSplit[23].Split()[2]
			}
		}
		21 {$RepositoryObject = [PSCustomObject]@{
				"$($DataSplit[0].Split()[12].Substring(0,$($DataSplit[0].Split()[12].Length-1)))"=$DataSplit[0].Split()[13]
				"$($DataSplit[1].Split()[1].Substring(0,$($DataSplit[1].Split()[1].Length-1)))"=$DataSplit[1].Split()[2]
				"$($DataSplit[2].Split()[1].Substring(0,$($DataSplit[2].Split()[1].Length-1)))"=$DataSplit[2].Split()[2]
				"$($DataSplit[3].Split()[1].Substring(0,$($DataSplit[3].Split()[1].Length-1)))"=$DataSplit[3].Split()[2]
				"ConcurrentTaskLimitEnabled"=$DataSplit[4].Split()[3]
				"$($DataSplit[5].Split()[1].Substring(0,$($DataSplit[5].Split()[1].Length-1)))"=$DataSplit[5].Split()[2].Substring(1,1)
				"$($DataSplit[9].Split()[1].Substring(0,$($DataSplit[9].Split()[1].Length-1)))"=$DataSplit[9].Split()[2]
				"$($DataSplit[10].Split()[1].Substring(0,$($DataSplit[10].Split()[1].Length-1)))"=$DataSplit[10].Split()[2]
				"$($DataSplit[14].Split()[1].Substring(0,$($DataSplit[14].Split()[1].Length-1)))"=$DataSplit[14].Split()[2]
				"$($DataSplit[16].Split()[1].Substring(0,$($DataSplit[16].Split()[1].Length-1)))"=$DataSplit[16].Split()[2].Substring(1,$DataSplit[16].Split()[2].Length-1)
				"$($DataSplit[17].Split()[1].Substring(0,$($DataSplit[17].Split()[1].Length-1)))"=$DataSplit[17].Split()[2].SubString(1,$DataSplit[17].Split()[2].Length-3)
				"$($DataSplit[18].Split()[1].Substring(0,$($DataSplit[18].Split()[1].Length-1)))"=$DataSplit[18].Split(":")[1].SubString(1,$DataSplit[18].Split(":")[1].Length-1)
				"$($DataSplit[19].Split()[1].Substring(0,$($DataSplit[19].Split()[1].Length-1)))"=$DataSplit[19].Split(":")[1].SubString(1,$DataSplit[19].Split(":")[1].Length-1)
			}
		}
		15 {if(!($DataSplit.Split(",")[1].Split(":")[1] -like "*NFS*")){Continue}
			$RepositoryObject = [PSCustomObject]@{
				"$($DataSplit[0].Split()[12].Substring(0,$($DataSplit[0].Split()[12].Length-1)))"=$DataSplit[0].Split()[13]
				"$($DataSplit[1].Split()[1].Substring(0,$($DataSplit[1].Split()[1].Length-1)))"=$DataSplit[1].Split()[2]
				"$($DataSplit[2].Split()[1].Substring(0,$($DataSplit[2].Split()[1].Length-1)))"=$DataSplit[2].Split()[2]
				"$($DataSplit[3].Split()[1].Substring(0,$($DataSplit[3].Split()[1].Length-1)))"=$DataSplit[3].Split()[2]
				"ConcurrentTaskLimitEnabled"=$DataSplit[4].Split()[3]
				"$($DataSplit[5].Split()[1].Substring(0,$($DataSplit[5].Split()[1].Length-1)))"=$DataSplit[5].Split()[2].Substring(1,1)
				"$($DataSplit[9].Split()[1].Substring(0,$($DataSplit[9].Split()[1].Length-1)))"=$DataSplit[9].Split()[2]
			}
		}
	}
	Return $RepositoryObject