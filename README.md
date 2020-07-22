# Tape Monitor Script

A simple script to monitor the connection of Tape hardware on a Tape Server

## Instructions

1. Run the script from an Administrative Powershell prompt
2. The script will write to C:\temp\tapemonitor.log by default. This can be changed in the first few lines
3. The script is meant to check for Changers going offline. If you have standalone devices, you can change the command quickly (check the comments in the script)
4. The script runs for 1 week by default
5. Logging is done every minute, or terminates once the script determines that the number of connected devices has changed.

Set the variables at the beginning of the script, and let it run. 

If the customer must disconnect the hardware for unexpected maintenance, remind them to restat the script. 