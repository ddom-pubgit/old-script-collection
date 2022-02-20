	
# Scheduling

* NextRuntime is unreliable
  * Because of job chaining, scheduler issues, server time issues, retries, don't parse on NextRunTime. 

* Active/Synthetic Full days are stored as [System.DayofWeek] objects (many other properties triggered by day also are the same)
  * These are actually interger values 0-6 and are **culturally invariant** (i.e., no relation to the locale on the system): https://docs.microsoft.com/en-us/dotnet/api/system.dayofweek?view=net-5.0 
    * $_.value__ returns the numerical value

* Math with [System.DayofWeek] objects is a little strange in PS5:
  * A $true result returns the object being tested, a $false result returns nothing (this is not the same as $null!!!!!)
    * Don't test like ($null -eq $value) where $value = ($DTObj1 -eq $DTObj2). You'd expect $value to be $null here, but it's not, it's just "empty", which is strange cause it's not what other operators on objects in Powershell do
  * PS 6 handles such operations as expected and returbns $true or $false (presumably PS 7 also but not tested)
    * For PS 5 just test for $true results
  * You can compare such objects by adding DayOfWeek objects to an array and using Measure
  * Reverting a numerical value to a day can be done with [System.Enum]::GetName("DayofWeek",value_int), but this returns a String Object
    * Said string can be converted to a DayOfWeek object with [System.DayOfWeek]::string you got

* It is not safe to assume a job has only one run per given calendar day
   * Even if the job is scheduled to only run once per day

* Use $DateObject.Date to get 00:00:00 of that day
* Use Add() and AddDays() to do math on DateObjects (methods accept negative values)


# Backup Sessions (Not Tape)

* Job Objects have FindLastSession() method to get last session data
  * Same as Get-VBRBackupSession -Job | Sort -Descending | select -First 1
  * Generally preferable to understand the most recent run this way
  * FindLastSession().WillBeRetried will be true if job is in between automatic retry runs
    * But don't assume all jobs have retries enabled (it is default however)
  * FindLastSession().Result returns result of last Job Session


#Storage Paths (Backup paths)

* Scale-out Repositories (SOBR) and non-SOBR repos have different paths
  * Non-SOBR use full path on system and can be retrieved with just the path for the Storage Object
  * SOBR uses relative paths for the Storage and need to be constructed with:
    * Extent.GetPath()
    * MetaPath property†
    * Storage Name (Storage = backup file, e.g., vbk/vib/vrb)
    *  † You can also use the Job.Name property but this will fail for imported backups on a SOBR as well as Orphaned, so it's better to use the MetaFile Path
    * SOBR requires a metafile for Backups when adding an extent, so it's safe to assume this will be here. Backups on SOBR that somehow have a NULL or empty meta file path should be treated as exceptions and do not need special handling; by definition it is a problem with the environment and it needs to be fixed, not handled by code


#Storages

* GetAllStorages() and GetAllChildrenStorages() seem to hit the same DB backend, but GetAllChildrenstorages() works with all job types as best I can tell; seems preferrable in all cases

#Passing Variables between scripts

* On occasion you might need to pass a variable between PS sessions. Use Export-Clixml: https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/export-clixml?view=powershell-7.1#example-2--export-an-object-to-an-xml-file
  * Save it to a universally accessible location, have the secondary script import the XML into the currrent session and you'll avoid extra compute to rebuild objects.


#Debugging tools


* Don't use PowerShell ISE ever. It behaves differently than production Powershell and you'll waste time debugging ISE vs Production. Just write in somthing like Notepad++ or Visual Studio Code with the PS plugin, then test in PS. 
* Use the below options for debugging (seriously, ISE just wastes time, don't use it. For all of it's benefits, it's unwritten differences will eat up as much or more of your time)
* To call a function name within a function, use:

```(Get-Variable MyInvocation -Scope 1).Value.MyCommand.Name```
  
  * Explore that Get-Variable  *.Value Property to meet your needs, but for me I'm mostly concerned about the Function name for debugging

* Powershell doesn't have a great way to delcare which loop you're in. Use the following:
  * Add a ``Write-host`` to your loop (start of finish, doesn't matter) to declare when you're in a given loop. You'll need to add some relevant text and check the console output. ``Add-Content`` does the same thing, but let's you write to a log file.
  * You can do something like:
 	
```
    function Write-Debug {
        param(
          [string]$LogValue
         )
         Add-Content -Value "$DebugDateTime $DebugValue
    }
```

* Set $LogDateTime in advance as a DateTime Value with time included. I prefer something like ``(Get-Date) ::`` to separate the automated data from real data, but this is not essential. I use the above for Logs also but change the values to ``$LogValue`` and ``$LogDateTime`` respectively. 
* I'm not aware of a way to check which loop you're in or which item in a "smart" manner. Start a counter at 0 ( ```$i=0``` ) and when you are debugging, declare your count with ```$i | Write-Host```. This will let you at least know which element in an array broke your function/loop/whatever and it's easy enough to reproduce. 
  * You might write a Try-Catch that simply writes exceptions to a $brokenItem arrray, but this seems like a lot of work =,= Still, migh work
* Obvious for me but maybe not for everyone, anytime you get a ```Null```-anything error, it means something you passed as an argument is ```$null$``` and you need to check the items you're parsing. Using the above counter method during debug, you will find your issues fast if you think about the unique properties between a working and non-working object. 



#PSCustom Objects

* Normally, you'd call a PSCustom Object like:

```$someobject = New-Object {Name="somename";Expression=@{Some expression},...}``` †

†  note: you can shorthand the Name/Expression to n/e respectively, but this is more annoying for me)

or 

```
$Someobject = [PSCustomObject]@{
    Property1 = "thing1"
    Property2 = "thing2"
    ...
}
```

Neither is realy wrong, but I think it's a bit misleading/verbose. The first option is very verbose and I don't think it reads well for newbies. It gets the benefit of a single line, but I find that you're stuck trying to decipher the content.

Instead, I recommend use the following:

```
$SomeObject = "" | select Property1, Property2, ...
Property1 = "some string"
Property2 = (Some Expression)
```

I prefer the last because it's just a llittle easier to understand I think.
You get the benefit of a single line to declare the Custom Object, but it's a lot cleaner to read, you don't have to worry about closing the object array (it's done in one line), and it's clear what needs to be added, if anything. $null is valid on such objects (i.e,, you don't need a real user value for each property)

No way above is "right", each will work and as best I know they are consistent across PS versions. PSCookbook doesn't seem to have a preference, so as of 14.08.2021, it's not clear for me if there's a downside to any of the above; last just makes most sense for me, but you might resonate differently and I'm not intending to argue for/against any one position.

Use such objects when you want to return specific information to pass back to the global scope (i.e., for the entire script to access)

#Strings

* Don't.
* Seriously Don't
* Strings are the devil

Avoid validating strings in Powershell whenever possible; parse object properties instead. 
String's are really bad, really slow, and really clunky.
All Text objects have string related methods, but they are very verbose and the same operation from shell (any really, bash, zsh, etc) will always be some magnitude faster than Powershell.
Powershell was not built for text munging, it was built for Object-Oriented workflows.

If you need to parse Veeam-related things (Storages (backup files), job names, etc), do it with native objects. Get storage names with ```GetAllChildrenStorages()``` on backup objects, get job names from Job Objects, etc.

Never assume a string will be consistent across releases; it's __always__ better to use the Object Property rather than try to parse strings. 

#SureBackup Process

* Most important thing to note is that HyperV and VMware have distinctly different processing -- you must make sure you read the cmdlets carefully.

* HV Application Groups accept an array of VMs returned by ```Find-VBRHvEntity```
  * This kind of sucks because this cmdlet is very slow and it's hard to associate it to jobs (I'm not sure there's a way to convert a Job Object to an HVVmItem object -- Surebackup Jobs work with LinkedJob associations, and as best I can tell, we do the same hierarchy lookup at the start of Surebackup jobs)
  * Parsing by host can be done with

```
$HostsAndVms = Find-VBRHvEntity -HostsAndVMs
$VMs = $HostsAndVms |Where-Object {$_.Type -eq 'Vm'}

That will return all VMs. To get only VMs from a specific cluster is a pain in the ass
 
Assuming you have $VMs,  
$AllVmsFromCluster = $VMs | Where-Object {$_.GetConnHost().HierarchyRoot.Hostname -eq 'name of cluster as it shows in Veeam UI'}
```

* If there is a cleaner way, I'm all ears
