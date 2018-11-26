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
$ip = Get-WmiObject Win32_NetworkAdapterConfiguration | Where { $_.Ipaddress.length -gt 1 }
$ip = $ip.ipaddress[0]
$core = Get-CimInstance -ClassName Win32_Processor | Select-Object Name
$core = $core.name
$ram = Get-Ciminstance Win32_OperatingSystem | Select-Object @{Name = "total";Expression = {[int]($_.TotalVisibleMemorySize/1mb)}}
$ram = $ram.total
$domain = Get-CimInstance -ClassName Win32_ComputerSystem | Select-Object Domain
$domain = $domain.domain
$client = read-host "Client name?"
$file="$client - $env:COMPUTERNAME.txt"
# --------------
# - Out format -
# --------------
ECHO "-----------------------------------------------------------------------" > $file
ECHO "COMPUTER INFORMATION - $((get-date).tostring('dd-MM-yyyy'))" >> $file
ECHO "-----------------------------------------------------------------------" >> $file
ECHO "CLIENT: $client" >> $file
ECHO "COMPUTER name: $env:COMPUTERNAME" >> $file
ECHO "CURRENT USER: $env:USERNAME" >> $file
ECHO "CURRENT USER FOLDER: $env:USERPROFILE" >> $file
ECHO "IP ADDRESS: $ip" >> $file
ECHO "DOMAIN/WORKGROUP: $domain" >> $file
ECHO "PROCESSOR: $core" >> $file
ECHO "MEMORY RAM: $ram GB" >> $file
ECHO "" >> $file
Get-Wmiobject win32_logicaldisk -Filter "DriveType=3" | Select @{name="Unit";Expression={$_.Name}},@{name="Format";Expression={$_.FileSystem}},@{name="Name";Expression={$_.VolumeName}},@{n="Free Space";e={[math]::truncate($_.freespace / 1GB)}} >> $file
if ($emailaddress -eq 'true') {
    ECHO "-----------------------------------------------------------------------" >> $file
    ECHO "EMAIL ADDRESS" >> $file
    ECHO "-----------------------------------------------------------------------" >> $file
    $outlookApplication = New-Object -ComObject 'Outlook.Application'
    $outlook = $outlookApplication.Application.Session.Accounts | Select-Object DisplayName
    ECHO $outlook.DisplayName >> $file
}
if ($sharedfolders -eq 'true') {
    ECHO "" >> $file
    ECHO "-----------------------------------------------------------------------" >> $file
    ECHO "SHARED FOLDERS" >> $file
    ECHO "-----------------------------------------------------------------------" >> $file
    $sharedfolders = get-WmiObject -class Win32_Share | where {$_.path -ne ""}
    ECHO $sharedfolders.path >> $file
}
if ($users -eq 'true') {
    ECHO "" >> $file
    ECHO "-----------------------------------------------------------------------" >> $file
    ECHO "ACTIVE LOCAL USERS" >> $file
    ECHO "-----------------------------------------------------------------------" >> $file
    $users = Get-Localuser | where {$_.enabled -eq "true"}
    ECHO $users.name >> $file
}
if ($groups -eq 'true') {
    ECHO "" >> $file
    ECHO "-----------------------------------------------------------------------" >> $file
    ECHO "LOCAL GROUPS" >> $file
    ECHO "-----------------------------------------------------------------------" >> $file
    $groups = Get-Localgroup
    ECHO $groups.name >> $file
}
# --------------
# - Send email -
# --------------
$send = read-host "Send mail with summary? [Y/N]"
if ($send -eq 'Y') {
    $subject = "$client - User:$env:USERNAME PC:$env:COMPUTERNAME"
    $body = Get-Content $file -Encoding 'UTF8' | Out-String
    $credencial = Get-Credential
    Send-MailMessage -From $from -To $to -Subject $subject -Body $body -SmtpServer $smtp -Port $port -Encoding 'UTF8' -Credential $credencial
}
