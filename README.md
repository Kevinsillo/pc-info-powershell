# Powershell Utilities
These are some tools written in powershell to perform different automated tasks such as backups or obtain information from a computer.

## SecurePasswordPowershell
Generate a "cred" file with your encripted password (**%pUSERPROFILE%/.cred/cred**)

### How to Use
Edit file and introduce your password. Then you can run script for generate file.

## GetInformationPowershell
That is a simple script for gather information of any computer with Powershell and send by email. For send email use **SecurePasswordPowershell** before, that utility create a one file with encripted password.

### How to Use
Edit the file to change **OPTIONS** and **SEND EMAIL DATA**

### Out Format example
![Example](https://i.imgur.com/DWtHqCQ.png)

## BackupControlPowershell
Script for backup scheduling, control version, delete old versions and log by email.

### How to Use
Edit file to change **OPTIONS** and **SEND EMAIL DATA**. The "delete" and "days" options remove old folders of backup (default: 10 days before). You can't send email with log disabled, because the email only send log attached.
