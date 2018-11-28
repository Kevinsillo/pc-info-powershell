################################################################
#                                                              #
#   AUTOR: Kevin Illanas                                       #
#   DESCIPTION: Backups with version control and log mail      #
#                                                              #
#   VERSION: 1.0                                               #
#                                                              #
################################################################
ECHO OFF
CLS
# -------------------------------------------------------
# Options 
# -------------------------------------------------------
# Routes of data for backups
$from = @(
    # 'D:\Databases\backup',
    # 'C:\Users',
    # 'E:\Data\Windows.iso'
    )
# Route of destination backup
$to = '' # 'F:\backups\'
# Delete old files (true / false)
$delete = 'false'
# Days later tu delete files
$days = '10'
# Create log of backups (true / false) 
$log = 'true'
# -------------------------------------------------------
# Send email data
# -------------------------------------------------------
$mfrom = ''
$mto = ''
$smtp = ''
$port = ''
# -------------------------------------------------------
# Variables
# -------------------------------------------------------
$logName = "backupLog_$((get-date).tostring('yyy-MM-dd')).txt"
$send = read-host "Send mail with summary log? [Y/N]"
$toCreate = "$to$((get-date).tostring('yyy-MM-dd'))"
$oldBackup = (get-date).AddDays(-$days).ToString("yyy-MM-dd")
# -------------------------------------------------------
# Controls
# -------------------------------------------------------
if ($from.Count -eq 0) {
    Write-Host "ERROR" -BackgroundColor red
    ECHO "------------------------------------------------------------------"
    Write-Host "Option FROM is empty. Please add items in FROM." -ForegroundColor yellow
    ECHO "------------------------------------------------------------------"
    PAUSE
    EXIT
}
if ($to.Length -eq 0) {
    Write-Host "ERROR" -BackgroundColor red
    ECHO "------------------------------------------------------------------"
    Write-Host "Option TO is empty. Please add items in TO." -ForegroundColor yellow
    ECHO "------------------------------------------------------------------"
    PAUSE
    EXIT
}
if ($delete -eq 'true' -and $days.Length -eq 0) {
    Write-Host "ERROR" -BackgroundColor red
    ECHO "------------------------------------------------------------------"
    Write-Host "Option DAYS is empty. Please add number of days to delete." -ForegroundColor yellow
    ECHO "------------------------------------------------------------------"
    PAUSE
    EXIT
}
if ($send -eq 'Y') {
    if ($mfrom.Length -eq 0 -or $mto.Length -eq 0 -or $smtp.Length -eq 0 -or $port.Length -eq 0) {
        Write-Host "ERROR" -BackgroundColor red
        ECHO "------------------------------------------------------------------"
        Write-Host "Missing some of the mail data. Please add all mail data." -ForegroundColor yellow
        ECHO "------------------------------------------------------------------"
        PAUSE
        EXIT
    }
    if ($log -ne 'true') {
        Write-Host "MAIL ERROR" -BackgroundColor red
        ECHO "------------------------------------------------------------------"
        Write-Host "LOG is disable. Please enable LOG for send mail." -ForegroundColor yellow
        ECHO "------------------------------------------------------------------"
        PAUSE
        EXIT
    }
}
# -------------------------------------------------------
# Code 
# -------------------------------------------------------
MKDIR $toCreate
if ($log -eq 'true') {
    ECHO "Copying items at $((get-date).tostring('HH:mm'))" > $logName
}
For ($i=0; $i -lt $from.Count; $i++) {
    $fromi = $from[$i]
    Copy-Item -Path $from[$i] -Destination $toCreate
    if ($log -eq 'true') {
        ECHO "$i.- Copied the item   $fromi   to   $toCreate" >> $logName
    }
}
if ($log -eq 'true') {
    ECHO "Backup finalized at $((get-date).tostring('HH:mm'))" >> $logName
}
if ($delete = 'true') {
    if ($log -eq 'true') {
        ECHO "Deleting old backups at $((get-date).tostring('HH:mm'))" >> $logName
    }
    RD -Force -Recurse -ErrorAction SilentlyContinue $to$oldBackup
    if ($log -eq 'true') {
        ECHO "Deleted the old backup $to$oldBackup at $((get-date).tostring('HH:mm'))" >> $logName
    }
}
# -------------------------------------------------------
# Send email
# -------------------------------------------------------
if ($send -eq 'Y') {
    if ($log -eq 'true') {
        $subject = "Backup report log of $env:COMPUTERNAME"
        $credencial = Get-Credential -UserName $mfrom
        Send-MailMessage -From $mfrom -To $mto -Subject $subject -Attachments $logName -SmtpServer $smtp -Port $port -Encoding 'UTF8' -Credential $credencial
    }
}
