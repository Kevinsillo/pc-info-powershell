# Powershell Utilities
These are some tools written in powershell to perform different automated tasks such as backups or obtain information from a computer.

## 1.- SecurePasswordPowershell
Generate a "cred" file with your encripted password (**%USERPROFILE%/.cred/cred**)

### How to Use
Edit file and introduce your password. Then you can run script for generate file.

## 2.- GetInformationPowershell
That is a simple script for gather information of any computer with Powershell and send by email. For send email use **SecurePasswordPowershell** before, that utility create a one file with encripted password.

### How to Use
Edit the file to change **OPTIONS** and **SEND EMAIL DATA**

### Out Format example
![Example](https://i.imgur.com/DWtHqCQ.png)

## 3.- BackupControlPowershell
Script for backup scheduling, control version, delete old versions and log by email.

### How to Use
Edit file to change **OPTIONS** and **SEND EMAIL DATA**. The "delete" and "days" options remove old folders of backup (default: 10 days before). You can't send email with log disabled, because the email only send log attached.

## 1.- ChocoPackageInstaller
Install packages like Linux with Chocolatey. This script install Choco packages from an array.

### How to Use
Edit the file and introduce name of Choco packages. Later execute it in Powershell with elevated privileges.
>$packages = @(
    "vscode","nodejs-lts","postman","mongodb","robo3t","7zip"
    )
