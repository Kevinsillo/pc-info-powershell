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
$pass = 'iXefF3DfPV'
$name = 'cert'
$route = "$env:USERPROFILE\.cert\"
# -------------------------------------------------------
# Variables
# -------------------------------------------------------
MKDIR $route
$pass | ConvertTo-SecureString -AsPlainText -Force | ConvertFrom-SecureString | Out-File $route$name
PAUSE