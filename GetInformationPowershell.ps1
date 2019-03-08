################################################################
#                                                              #
#   AUTOR: Kevin Illanas                                       #
#   DESCIPTION: Collect information from the computer          #
#   and send it by mail.                                       #
#                                                              #
#   VERSION: 1.0.6.0                                           #
#                                                              #
################################################################
ECHO OFF
Clear-Host
# -----------
# - Options -
# -----------
# Show list of local users
$users = 'true'
# Show list of local groups
$groups = 'true'
# Show Windows shared folders
$sharedfolders = 'true'
# Show the registered Outlook email address
$emailaddress = 'true'
# Secure password route (default route "$env:USERPROFILE\.cert\cert")
# Create cert with "SecurePasswordPowershell" utility
$cert = "$env:USERPROFILE\.cert\cert"
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
$company = read-host "Company name?"
$owner = read-host "Owner name?"
$send = read-host "Send mail with summary? [Y/N]"
$ip = (Get-WmiObject Win32_NetworkAdapterConfiguration | Where { $_.Ipaddress.length -gt 1 }).ipaddress[0]
$mac = (Get-NetAdapter | Where-Object {$_.Name -eq 'Ethernet'}).MacAddress
$adapterName = (Get-NetAdapter | Where-Object {$_.Name -eq 'Ethernet'}).Name
$adapterDesc = (Get-NetAdapter | Where-Object {$_.Name -eq 'Ethernet'}).InterfaceDescription
$core = (Get-CimInstance -ClassName Win32_Processor).Name
$ram = (Get-Ciminstance Win32_OperatingSystem | Select-Object @{Name = "total";Expression = {[int]($_.TotalVisibleMemorySize/1mb)}}).total
$domainName = (Get-CimInstance -ClassName Win32_ComputerSystem).Domain
$domain = (Get-WmiObject -Class Win32_ComputerSystem).PartOfDomain
$os = (Get-CimInstance -ClassName Win32_OperatingSystem).caption
$graphic = (Get-WmiObject Win32_VideoController).description
$file = "$company - $owner - $env:COMPUTERNAME.txt"
# --------------
# - Out format -
# --------------
Write-Output "-----------------------------------------------------------------------" > $file
Write-Output "COMPUTER INFORMATION" >> $file
Write-Output "By Kevin Illanas - 2018" >> $file
Write-Output "-----------------------------------------------------------------------" >> $file
Write-Output "DATE: $((get-date).tostring('dd-MM-yyyy'))" >> $file
Write-Output "COMPANY: $company" >> $file
Write-Output "COMPUTER NAME: $env:COMPUTERNAME" >> $file
Write-Output "OPERATING SYSTEM: $os" >> $file
if ($domain -eq 'true') {
    Write-Output "DOMAIN: $domainName"  >> $file
} else {
    Write-Output "WORKGROUP: $domainName" >> $file
}
Write-Output "CURRENT USER: $env:USERNAME" >> $file
Write-Output "CURRENT USER FOLDER: $env:USERPROFILE" >> $file
Write-Output "IP ADDRESS: $ip" >> $file
Write-Output "MAC: $mac ($adapterName - $adapterDesc)" >> $file
Write-Output "PROCESSOR: $core" >> $file
Write-Output "MEMORY: $ram GB" >> $file
Write-Output "GRAPHIC: $graphic" >> $file
Write-Output "" >> $file
Get-Wmiobject win32_logicaldisk -Filter "DriveType=3" | Select @{name="Unit";Expression={$_.Name}},@{name="Format";Expression={$_.FileSystem}},@{name="Name";Expression={$_.VolumeName}},@{n="Free Space";e={[math]::truncate($_.freespace / 1GB)}} >> $file
if ($emailaddress -eq 'true') {
    Write-Output "-----------------------------------------------------------------------" >> $file
    Write-Output "EMAIL ADDRESS" >> $file
    Write-Output "-----------------------------------------------------------------------" >> $file
    $outlook = ((New-Object -ComObject 'Outlook.Application').Application.Session.Accounts | Select-Object DisplayName).DisplayName
    Write-Output $outlook >> $file
}
if ($sharedfolders -eq 'true') {
    Write-Output "" >> $file
    Write-Output "-----------------------------------------------------------------------" >> $file
    Write-Output "SHARED FOLDERS" >> $file
    Write-Output "-----------------------------------------------------------------------" >> $file
    $sharedfolders = (get-WmiObject -class Win32_Share | where {$_.path -ne ""}).path
    Write-Output $sharedfolders >> $file
}
if ($users -eq 'true') {
    Write-Output "" >> $file
    Write-Output "-----------------------------------------------------------------------" >> $file
    Write-Output "ACTIVE LOCAL USERS" >> $file
    Write-Output "-----------------------------------------------------------------------" >> $file
    $users = (Get-Localuser | where {$_.enabled -eq "true"}).name
    Write-Output $users >> $file
}
if ($groups -eq 'true') {
    Write-Output "" >> $file
    Write-Output "-----------------------------------------------------------------------" >> $file
    Write-Output "LOCAL GROUPS" >> $file
    Write-Output "-----------------------------------------------------------------------" >> $file
    $groups = (Get-Localgroup).name
    Write-Output $groups >> $file
}
# --------------
# - Send email -
# --------------
if ($send -eq 'Y') {
    $cred = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $from, (Get-Content $cert | ConvertTo-SecureString)
    $subject = "$company - $owner - $env:COMPUTERNAME"
    Send-MailMessage -From $from -To $to -Subject $subject -Attachments $file -SmtpServer $smtp -Port $port -Encoding 'UTF8' -Credential $cred
}
