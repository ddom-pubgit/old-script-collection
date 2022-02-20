<# Simple Script to add only the most recent points in a Reverse Incremental Chain
To a File to Tape Job. Change lines for: $backup, $files2Backup (adjust the range), $obj (correct the root path...script  can be changes to grab root path automatically)
#>

Add-PSSnapin VeeamPSSnapin
$backup = Get-VBRBackup -Name 'OffloadBackup'
$rps = Get-VBRRestorepoint -Backup $backup
$sorted = $rps | sort-object -property CreationTime -Descending
$files2Backup = $sorted[0..10].GetStorage().PartialPath.Internal.Elements
$obj = @()
Foreach($file in $files2Backup){
$obj += New-VBRFileToTapeObject -Path "E:\offloadbackup\$file"
}
$job = Get-VBRTapeJob -name 'f2tscript'
Set-VBRFiletoTapeJob -job $job -Object $obj