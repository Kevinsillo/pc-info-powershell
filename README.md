# Powershell Utilities
These are some tools written in powershell to perform different automated tasks such as backups or obtain information from a computer.

## GetInformationPowershell
That is a simple script for gather information of any computer with Powershell and send to email.

### Modify
Edit the file to change email options and users/groups list

### Out Format example
![Example](https://i.imgur.com/DWtHqCQ.png)

## BackupControlPowershell
Script for backup scheduling, version control, delete old versions, log by mail.

### Modify
Edit file tu change OPTIONS and EMAIL DATA. The "delete" option and "days" remove old folders of backup (default: 10 days before). You can't send email with log disabled, because the email only send log attached.
