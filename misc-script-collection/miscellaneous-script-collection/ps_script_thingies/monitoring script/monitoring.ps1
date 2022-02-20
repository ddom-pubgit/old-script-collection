$i = 0
While ($i -eq 0) {
Get-Date >> C:\temp\monitorlog.log
get-process *Veeam* | Group-Object -Property ProcessName, ID | Format-Table Name, @{n='Mem (KB)';e={'{0:N0}' -f (($_.Group|Measure-Object WorkingSet -Sum).Sum / 1KB)};a='right'} -AutoSize >> C:\temp\monitorlog.log
If ($(Test-Path C:\temp\stopscript.log)){
Exit}
Start-Sleep 300 #edit this as required. Typically, every 5% of the job run should be sufficient. (e.g., if the job takes 100 minutes to run, set to 300 for 5 minutes (.05*100 = 5)
}