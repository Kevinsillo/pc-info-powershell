################################################################
#                                                              #
#   AUTOR: Kevin Illanas                                       #
#   DESCIPTION: Create a secure password for other scripts     #
#                                                              #
#   VERSION: 1.0                                               #
#                                                              #
################################################################
ECHO OFF
CLS
# -------------------------------------------------------
# Options 
# -------------------------------------------------------
# Password
$pass = ''
# Name of the cert file
$name = 'cert'
# Route of the cert file
$route = "$env:USERPROFILE\.cer\"
# -------------------------------------------------------
# Variables
# -------------------------------------------------------
$logName = "securePasswordLog_$((get-date).tostring('yyy-MM-dd')).txt"
# -------------------------------------------------------
# Code 
# -------------------------------------------------------
MKDIR $route
ECHO "$((get-date).tostring('HH:mm')) - Folder $route created" > $logName
$pass | ConvertTo-SecureString -AsPlainText -Force | ConvertFrom-SecureString | Out-File $route$name
ECHO "$((get-date).tostring('HH:mm')) - Cert $route$name created" >> $logName
Invoke-Item $route
