Add-Type -AssemblyName System.Windows.Forms
$FileBrowser = New-Object System.Windows.Forms.OpenFileDialog #-Property @{ InitialDirectory = [Environment]::GetFolderPath('Desktop') }

[void]$FileBrowser.ShowDialog()

$LogFile = $FileBrowser.Filename
$LogName = $FileBrowser.FileName | Split-Path -leaf
$JobName = $LogName.Split(".",3)[1]
$LogPath = $FileBrowser.FileName
[string]$FriendlyXML ="FriendlyXML_"+$JobName+".log"

write-host "The Logpath is $Logfile"
write-host "The name of the file is $LogName"
write-host "The Job name is $JobName"
write-host "We will write the data to something called $FriendlyXML"