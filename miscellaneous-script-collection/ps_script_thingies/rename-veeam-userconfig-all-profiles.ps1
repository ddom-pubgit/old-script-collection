<# Quick script to fix corrupted user.profile files on Veeam Server
This will rename all of them to _old.
No Support is provided for this script, it was tested in lab and is offered "as-is"
#>

$UserFolders = Get-ChildItem C:\Users
ForEach($User in $UserFolders){
	if(Test-Path "C:\Users\$User\AppData\Local\Veeam_Software_Group_GmbH"){
	$paths = Get-ChildItem -Recurse -Path "C:\Users\$User\AppData\Local\Veeam_Software_Group_GmbH\veeam.backup.shell.exe_*\10.0.0.0"
		foreach($path in $paths){
			Rename-Item $path $path"_old"
		}
	}
}