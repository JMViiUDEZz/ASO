
# Autor: Jose Maria Viudez
# Descripcion: Realizar un conjunto de scripts en PowerShell con la finalidad de poder facilitar la gestion de usuarios de Active Directory

# Llamar al archivo de configuracion ActiveDirectory.ps1
#. .\ActiveDirectory.ps1

# Configuracion
$DOMAIN=(Get-ADDomainController).Domain
$DC=(Get-ADDomainController).DefaultPartition
$ADMIN="Administrador"
$PASSWORD="jose2019+"
$DATE=Get-Date -Format "MM/dd/yyyy"
$TIME=Get-Date -Format "HH:mm"
$DATE_TIME=Get-Date -Format "MM/dd/yyyy_HH:mm"
$DEFDIR="C:\1-ActiveDirectoryUserManagement"
$DEFIMPFILE="$DIRPS1\usersImported.ldf"
$DEFEXPFILE="$DIRPS1\usersExported.ldf"
# En este caso, las variables se han declarado en el propio script

# Limpiar la pantalla al lanzar el menu
Clear-Host

# Funcion que muestra las opciones del menu
function getOptions{
    Write-Host "1. Menu para gestionar unidades organizativas"
	Write-Host "2. Menu para gestionar grupos"
    Write-Host "3. Menu para gestionar usuarios"
    Write-Host "4. Cerrar el programa"    
    
}
 
# Ejecucion de la funcion para que muestre las opciones del menu
getOptions
 
# Leer la opcion introducida por el usuario
$OPCION = Read-Host "Introduzca una opcion"

# Bucle para permanecer en el menu hasta que el usuario introduzca la opcion 4
while($OPCION -ne 4)
{
	# Comprobar que ha introducido el usuario
    switch($OPCION)
    {
        1{Invoke-Command -ComputerName w-server -Credential ASIR\Administrador -FilePath C:\ASO\1-Windows\1-Proyectos\1-ActiveDirectoryUserManagement\1.1-MenuOrganizationalUnits.ps1}
        2{Invoke-Command -ComputerName w-server -Credential ASIR\Administrador -FilePath C:\ASO\1-Windows\1-Proyectos\1-ActiveDirectoryUserManagement\1.2-MenuGroups.ps1}
        3{Invoke-Command -ComputerName w-server -Credential ASIR\Administrador -FilePath C:\ASO\1-Windows\1-Proyectos\1-ActiveDirectoryUserManagement\1.3-MenuUsers.ps1}
        4{exit}
    }
	# Volvemos a ejecutar la funcion para que muestre las OPCIONes del menu
    getOptions
	# Leer la nueva opcion introducida por el usuario
    $OPCION = Read-Host "Introduzca una nueva opcion"
}
