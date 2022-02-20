#Written by David D.
#Simple script for mass-enabling/disabling AAIP if it previously was enabled/disabled.
#Use-case here was that somehow during upgrade, all jobs got AAIP enabled, Cx wants it back the way it was
#This needs access to a working Veeam Server, and also a copy of VMC.log from before the upgrade
#There is no way to skip that requirement on VMC -- sorry :( 
#Be sure to change $vmcpath to the path for the VMC.log. I recommend make a copy in a workspace folder
#The if statement checks $GuestProcessing to see if that value is "true" or not. This should work for Backup Jobs
#I think this works for Replicas also, but not tested

Add-PSSnapin VeeamPSSnapin
$jobs = get-vbrjob | ?{$_.JobType -eq "Backup"}
$vmcpath = Get-Childitem -Path "C:\Users\Administrator\Desktop\workspace\VMC.log"
$aaipDisabled = @()
foreach ($job in $jobs) {
$jobID = $job.id.ToString()
[array]$VMCData = Get-Content $vmcpath | Select-String -Pattern "JobID: $jobID"
$guestProcessing = $VMCData[0].ToString()| %{$_.Split(',')[19]; }
     if ($guestProcessing.Contains("False")){
         $aaipDisabled += $job
         }
}

$aaipDisabled | Disable-VBRJobVSSIntegration | Out-Null
