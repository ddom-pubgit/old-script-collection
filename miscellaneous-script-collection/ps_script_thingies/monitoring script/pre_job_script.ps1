if($(Test-Path "C:\temp\stopscript.log")){
	Remove-Item "C:\temp\stopscript.log"
	}

Start-Process powershell.exe -ArgumentList "-file C:\temp\monitoring.ps1" >> C:\temp\script.log
#Start-Job -FilePath "C:\temp\test.ps1" | out-null