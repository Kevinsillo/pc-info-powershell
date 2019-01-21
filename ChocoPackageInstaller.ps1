################################################################
#                                                              #
#   AUTOR: Kevin Illanas                                       #
#   DESCIPTION: Choco package installer                        #
#                                                              #
#   VERSION: 2.0                                               #
#                                                              #
################################################################
ECHO OFF
CLEAR
# -------------------------------------------------------
# Variables
# -------------------------------------------------------
$packages = @(
    # Arrays example of packages
    # Web Developer:
    # "vscode","nodejs-lts","postman","mongodb","robo3t","7zip",
    )
# -------------------------------------------------------
# Install Chocolatey
# -------------------------------------------------------
Write-Host " Instalador de paquetes Chocolatey                   " -ForegroundColor white -BackgroundColor red
Write-Host "-----------------------------------------------------" -ForegroundColor red
$test = Test-Path -Path C:\ProgramData\chocolatey
if ($test -eq "True") {
    Write-Host "Chocolatey ya está instalado en su sistema" -ForegroundColor yellow
} else {
    Write-Host "Instalando chocolatey..." -ForegroundColor yellow
    Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1')) | Out-Null
    Write-Host "Chocolatey instalado correctamente" -ForegroundColor green
}
# -------------------------------------------------------
# Packages to install
# -------------------------------------------------------
Write-Host ""
Write-Host " Lista de paquetes a instalar                        " -ForegroundColor white -BackgroundColor red
Write-Host "-----------------------------------------------------" -ForegroundColor red
if ($packages.count -eq 0) {
    Write-Host "No se han añadido paquetes a instalar..." -ForegroundColor red
} else {
    ((Get-culture).TextInfo.ToTitleCase($packages)) -replace " ", "`n"
}
# -------------------------------------------------------
# Package installation
# -------------------------------------------------------
Write-Host ""
Write-Host " Instalando paquetes...                              " -ForegroundColor white -BackgroundColor red
Write-Host "-----------------------------------------------------" -ForegroundColor red
if ($packages.count -eq 0) {
    Write-Host "No se han añadido paquetes a instalar..." -ForegroundColor red
}
for ($i=0; $i -lt $packages.Length; $i++) {
    $check = (choco search $packages[$i] --local-only | select-string -Pattern $packages[$i] | %{$_.Line}).count
    if ($check -gt 0) {
        Write-Host "El paquete"$packages[$i]"ya está instalado" -ForegroundColor yellow
    } else {
        $check = (choco search $packages[$i] | select-string -Pattern $packages[$i] | %{$_.Line}).count
        if ($check -gt 0) {
            choco install $packages[$i] -y --force --force-dependencies | Out-Null
            Write-Host "El paquete"$packages[$i]"se ha instalado correctamente" -ForegroundColor green
        } else {
            Write-Host "El paquete"$packages[$i]"no existe en los repositorios. Revise los repositorios en https://chocolatey.org/packages" -ForegroundColor red
        }
    } 
}
Write-Host ""
Write-Host " Lista de paquetes instalados                        " -ForegroundColor white -BackgroundColor red
Write-Host "-----------------------------------------------------" -ForegroundColor red
choco search --local-only
Write-Host ""
