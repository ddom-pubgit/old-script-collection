#Check Powershell and .Net Versions.
#Check if Powershell  is at least v5
$PsValid = $false
$NetValid = $false

$PsChk = $PSVersionTable.PSversion
If ($PsChk.Major -ge "5") {
$PsValid = $true} 

#Check for .Net 4.5
$NetChk = (Get-ItemProperty "HKLM:SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full").Release -ge 378389
If ($NetChk -eq $true){ $NetValid = $true }


Write-Host "Netvalid is $NetValid"
Write-Host "PSValid is $PSValid"

If ($PSValid -eq $true){
	Write-Host "Powershell version is 5 or greater"
	} else {
		Write-Host "Powershell version is $PsChk, which is too low"
		}
		
If ($NetValid -eq $false) {
	Write-Host ".Net Version is too low"
	} else {
		Write-Host ".Net Version is 4.5 or greater"
		}
