#This script does not change the status of multiple rotated-drive backed repositories on a single managed server, which is officially unsupported in Veeam. Such a setup is strictly unsupported as per the User Guide, and the existence of this script does not change that. The script is merely a courtesy to allow functionality, but makes no guarantees to full functionality nor does it offer a Supported Status to an environment using multiple rotated Repositories on a single Managed Server. Removal of this text does not change the Support Statement from Veeam regarding this situation/script.

#Make a CSV Before hand and put it in a safe/static spot
#CSV should have three columns: DriveFName = Drive Friendly name here only for readability, RDLetter = Drive Letter to assign, Identifier = Reference File Name on the Drive. 
#Identifier should be formatted as "rotated_drive_01" and incrementing for each drive (e.g., first drive is rotated_drive_01, second is rotated_drive_02
#Identifier file must have no extension and sit at the root of the drive
#Currently the script loops continuously watching the drive letters. There is a commented out sleep command which can be used, but you can also add a condition to the while-loop or remove the while-loop and create some triggered action in Task Scheduler. That will be beyond the scope of this script.
#The script assumes that the necessary drive letter is available. If it cannot be set because the driveletter is occupied, the script emails a warning and stops. This is based on the assumption that if a drive has the required letter, it may be writing data from a Veeam Job

function Send-WarningEmail {
$smtp = "127.0.0.1"
$from = "test@test.com"
$to = "test@test.com"
[System.Net.ServicePointManager]::SecurityProtocol = 'TLS12' #Allowed values Ssl3, Tls, Tls11, Tls12
$body= "There is a drive letter conflict for the rotated drives which requires your attention. Drive $($WhichDrive.DriveFName) has been inserted, but the required Drive Letter $($WhichDrive.RDLetter) is occupied. The script has stopped until this is corrected"
Send-MailMessage -SmtpServer $smtp  -To $to -From $from -Subject "Rotated Drive Intervention Needed" -Body $body
}

while ($active -eq $null){
	$DriveList = Import-Csv -Path "C:\temp\drivelist.csv"
	$Volumes = Get-Volume | ?{$_.DriveLetter -ne $null -and $_.DriveType -ne "CD-ROM"}
	foreach ($volume in $volumes){
		$driveletter = $volume.DriveLetter
		$CheckIdentifier = Get-item -Path ($driveletter + "`:\rotated_drive_*")
		if ($CheckIdentifier){
			#confirm that the drive detected has the correct letter
			$IdentifierName  = $CheckIdentifier.Name
			$WhichDrive = $Drivelist | ? {$_.Identifier -eq $IdentifierName}
			If ($WhichDrive.RDLetter -ne $driveletter){
				#if the drive has the wrong letter, try to set it. if this fails, send an email and stop
				if($Volumes.DriveLetter -notcontains $WhichDrive.RDLetter){
					Set-Partition -DriveLetter $driveletter -NewDriveLetter $WhichDrive.RDLetter
					} else {
						Send-WarningEmail
						Exit
					}
				}	
			}
		#Start-Sleep 1
	}		
}
