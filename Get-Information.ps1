################################################################
#                                                              #
#   AUTOR: Kevin Illanas                                       #
#   DESCIPTION: Collect information from the computer          #
#   and send it by mail.                                       #
#                                                              #
#   VERSION: 3.0                                               #
#                                                              #
################################################################
ECHO OFF
CLS
# -----------
# - Options -
# -----------
# Show list of users groups and shared folders
$users='true'
$groups='true'
$sharedfolders='true'
$emailaddress='true'
# -------------------
# - Send email data -
# -------------------
$from = ''
$to = ''
$smtp = ''
$port = ''
# -------------
# - Variables -
# -------------
$ip = (Get-WmiObject Win32_NetworkAdapterConfiguration | Where { $_.Ipaddress.length -gt 1 }).ipaddress[0]
$core = (Get-CimInstance -ClassName Win32_Processor).Name
$ram = (Get-Ciminstance Win32_OperatingSystem | Select-Object @{Name = "total";Expression = {[int]($_.TotalVisibleMemorySize/1mb)}}).total
$domainName = (Get-CimInstance -ClassName Win32_ComputerSystem).Domain
$domain = (Get-WmiObject -Class Win32_ComputerSystem).PartOfDomain
$company = read-host "Company name?"
$owner = read-host "Owner name?"
$file="$company - $owner - $env:COMPUTERNAME.txt"
# --------------
# - Out format -
# --------------
ECHO "-----------------------------------------------------------------------" > $file
ECHO "COMPUTER INFORMATION - $((get-date).tostring('dd-MM-yyyy'))" >> $file
ECHO "By Kevin Illanas - 2018" >> $file
ECHO "-----------------------------------------------------------------------" >> $file
ECHO "COMPANY: $company" >> $file
ECHO "COMPUTER NAME: $env:COMPUTERNAME" >> $file
if ($domain -eq 'true') {
    ECHO "DOMAIN: $domainName"  >> $file
} else {
    ECHO "WORKGROUP: $domainName" >> $file
}
ECHO "CURRENT USER: $env:USERNAME" >> $file
ECHO "CURRENT USER FOLDER: $env:USERPROFILE" >> $file
ECHO "IP ADDRESS: $ip" >> $file
ECHO "PROCESSOR: $core" >> $file
ECHO "MEMORY: $ram" >> $file
ECHO "" >> $file
Get-Wmiobject win32_logicaldisk -Filter "DriveType=3" | Select @{name="Unit";Expression={$_.Name}},@{name="Format";Expression={$_.FileSystem}},@{name="Name";Expression={$_.VolumeName}},@{n="Free Space";e={[math]::truncate($_.freespace / 1GB)}} >> $file
if ($emailaddress -eq 'true') {
    ECHO "-----------------------------------------------------------------------" >> $file
    ECHO "EMAIL ADDRESS" >> $file
    ECHO "-----------------------------------------------------------------------" >> $file
    $outlook = ((New-Object -ComObject 'Outlook.Application').Application.Session.Accounts | Select-Object DisplayName).DisplayName
    ECHO $outlook >> $file
}
if ($sharedfolders -eq 'true') {
    ECHO "" >> $file
    ECHO "-----------------------------------------------------------------------" >> $file
    ECHO "SHARED FOLDERS" >> $file
    ECHO "-----------------------------------------------------------------------" >> $file
    $sharedfolders = (get-WmiObject -class Win32_Share | where {$_.path -ne ""}).path
    ECHO $sharedfolders >> $file
}
if ($users -eq 'true') {
    ECHO "" >> $file
    ECHO "-----------------------------------------------------------------------" >> $file
    ECHO "ACTIVE LOCAL USERS" >> $file
    ECHO "-----------------------------------------------------------------------" >> $file
    $users = (Get-Localuser | where {$_.enabled -eq "true"}).name
    ECHO $users >> $file
}
if ($groups -eq 'true') {
    ECHO "" >> $file
    ECHO "-----------------------------------------------------------------------" >> $file
    ECHO "LOCAL GROUPS" >> $file
    ECHO "-----------------------------------------------------------------------" >> $file
    $groups = (Get-Localgroup).name
    ECHO $groups >> $file
}
# --------------
# - Send email -
# --------------
$send = read-host "Send mail with summary? [Y/N]"
if ($send -eq 'Y') {
    $subject = "$company - $owner - $env:COMPUTERNAME"
    $credencial = Get-Credential -UserName $from
    Send-MailMessage -From $from -To $to -Subject $subject -Attachments $file -SmtpServer $smtp -Port $port -Encoding 'UTF8' -Credential $credencial
}
