$smtp = "127.0.0.1"
$from = "test@test.com"
$to = "test@test.com"

add-pssnapin veeampssnapin

[System.Net.ServicePointManager]::SecurityProtocol = 'TLS12' #Allowed values Ssl3, Tls, Tls11, Tls12
$configjob = Get-VBRConfigurationBackupJob
ConvertTo-HTML -InputObject $configjob -Property Name,LastResult,NextRun,Target > C:\temp\ConfigurationReport.html
$body = Get-Content C:\temp\ConfigurationReport.html -Raw
Send-MailMessage -SmtpServer $smtp  -To $to -From $from -Subject "Configuration Backup Report" -Body $body -BodyAsHtml


#Add the following to run with secure ports, but we cannot support this.
#-port 587 -UseSSL