#!/bin/bash
#Ensure you make a file in /tmp called logfile.log (e.g., touch /tmp/logfile.log)
runscript="0"


while [ $runscript > 0 ]
do
	if [[ $(lsof | grep <replace with name of backup job without brackets>) ]]; then
		date +"%Y-%m-%d %T Job is running" >> /tmp/logfile.log
		lsof | grep <replacewithnameofbackupjob> | grep vib | grep -v veeamagen >> /tmp/logfile.log
		sleep 30
	else
		date +"%Y-%m-%d %T Job is not running" >> /tmp/logfile.log
		sleep 10m
	fi
done



[!!!!! below is an example, do not use !!!!!!]
#!/bin/bash
#Ensure you make a file in /tmp called logfile.log (e.g., touch /tmp/logfile.log)
runscript="0"

while [ $runscript > 0 ]
do
        if [[ $(lsof | grep 'vmware-pervm-ffi') ]]; then
                date +"%Y-%m-%d %T Job is running" >> /tmp/logfile.log
                lsof | grep 'vmware-pervm-ffi | grep vib | grep -v veeamagen >> /tmp/logfile.log
                sleep 30
        else
                date +"%Y-%m-%d %T Job is not running" >> /tmp/logfile.log
                sleep 10m
        fi
done


