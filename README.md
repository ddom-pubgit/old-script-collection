# Drive Assigner

A tool for ensuring that removable drives in windows always get the same drive letter

==Workflow==

The script works in several steps:

1. Gather all mounted volumes and drive letters
2. Import an authoritative list of rotated drives from a csv file
3. Check each Volume for the identifier file; if nothing is found, do nothing
4. For each identifier found, check against the authoritative list and confirm if the correct drive letter is assigned
5. If not, try to set the drive letter
6. By default, if the correct drive letter is already in use, the script defaults to sending a warning email -- this is to avoid potential conflicts or dismounting a drive during write operations. 

The script comes with **No Support**. It is provided as a courtesy and nothing more. There is no support, no guarantee, no patching/bugfixes. Feature Requests may be submitted, but there is no time frame for such requests

* Currently, [Veeam does not support multiple rotated repositories](https://helpcenter.veeam.com/docs/backup/vsphere/backup_repository_rotated.html?ver=100) on the same managed server. 
* This script **does not change or circumvent this fact**; such setups are explicitly unsupported
* The script is merely a courtesy to allow normal functionality to continue, but any problems outside of the script will not be eligible for investigation
* The script is to be used at your own risk. Again, no support or guarantee offered for this script.

The script by default operates in a While-Loop -- this can be edited to the user's discretion. 

