Step-by-Step Breakdown
SMTP Email Setup: The script begins by defining the variables needed to send reports via email:

powershell
Copy code
$From = "xxx@xxx.com"
$SMTPServer = "xxx.xxx.xxx"
$To = "xxx@xxx.com"
$AminAddress = "xxx@xxx.com"
Connect to Exchange Online: Using Connect-ExchangeOnline, the script connects to your organization’s Microsoft 365 environment securely using a certificate and AppID:

powershell
Copy code
Connect-ExchangeOnline -CertificateThumbPrint "xxx" -AppID "xxx" -Organization "yourorg.onmicrosoft.com"
Retrieve Email Activity: The script collects message trace data from the last 10 days and stores it in an array for comparison against all distribution groups:

powershell
Copy code
[array]$CurrentMessages = (Get-MessageTrace -Status Expanded -PageSize 5000 -Page $Page -StartDate $StartDate -EndDate $EndDate | Select-Object RecipientAddress, Received)
Classify Distribution Groups: Each distribution group is evaluated to see if it received any emails in the past 10 days. Based on that evaluation, the group is classified as either active or inactive:

powershell
Copy code
If ($MessageTable -Match $DL.PrimarySMTPAddress) {
    $ActiveStatus = "Active"
} Else {
    $ActiveStatus = "Inactive"
}
Update Active Directory Attributes: The script updates custom attributes in Active Directory to track how long a group has been inactive. Active groups have their attribute reset to 0, while inactive groups have it incremented:

powershell
Copy code
set-distributiongroup -identity $line.smtp -CustomAttribute10 0
Reporting: The script generates two CSV files: one for active groups and another for inactive groups. These are then attached to an email report, which is sent to the designated recipient:

powershell
Copy code
Send-MailMessage -From "$From" -To "$To" -Subject "Distribution Group Cleanup Report" -Body $HtmlReport -BodyAsHtml -SmtpServer "$SMTPServer" -Attachments $CSVFile, $CSVFileActive
Disconnect and Cleanup: After processing the data, the script disconnects from Exchange Online and removes the PowerShell snap-ins used:

powershell
Copy code
Disconnect-ExchangeOnline -Confirm:$false
remove-PSSnapin Microsoft.Exchange.Management.PowerShell.SnapIn
Why Use This Script?	