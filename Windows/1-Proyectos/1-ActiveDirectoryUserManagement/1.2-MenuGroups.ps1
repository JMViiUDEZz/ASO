
# Autor: Jose Maria Viudez
# Descripcion: Realizar un conjunto de scripts en PowerShell con la finalidad de poder facilitar la gestion de usuarios de Active Directory

# Llamar al archivo de configuracion ActiveDirectory.ps1
# . .\ActiveDirectory.ps1

# Configuración
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

# Verifica si un grupo existe
function existGroup() {
	(Get-ADGroup $1).Name
}

# Verifica si un usuario existe
function existUser {
	(Get-ADUser $1).SamAccountName
}

# Obtener un grupo, si existe
function getGroup() {
	Clear-Host;Write-Host "Obtener un grupo, si existe"
	$GRUPO = Read-Host "Grupo: "
	if ( "existGroup $GRUPO" -NotMatch "$GRUPO" ) {
		Write-Host "El grupo $GRUPO no existe"
	}
	else {
		Write-Host "Busqueda de datos del grupo ${GRUPO}"
		Get-ADGroup $GRUPO
		Start-Sleep -Seconds 3
	}
}

# Obtener todos los grupos
function getAllGroups() {
	Clear-Host;Write-Host "Obtener todos los grupos"
	Write-Host "¿Desea obtenerlos con todas sus propiedades?"
	$RESPUESTA = Read-Host "[y] Yes  [n] No: (por defecto es "n")" 
	if ( "$RESPUESTA" -Match "y" ) {
		Write-Host "Ha seleccionado la opcion [y]"
		# Obtenga todas las propiedades de todos los grupos.
		Get-ADGroup -Filter * -Properties *
		Start-Sleep -Seconds 3
	}
	elseif ( "$RESPUESTA" -Match "n" ) {
		Write-Host "Ha seleccionado la opcion [n]"
		# Obtenga todos los grupos de dominio de Active Directory.
		Get-ADGroup -Filter *
		Start-Sleep -Seconds 3
	}
	else {
		Write-Host "Como el caracter introducido es diferente a los especificados previamente, se tratara como [n]"
		# Obtenga todos los grupos de dominio de Active Directory.
		Get-ADGroup -Filter *
		Start-Sleep -Seconds 3
	}
}

# Crear un grupo
function addGroup() {
	Clear-Host;Write-Host "Crear un grupo"
	# Solicitar grupo sabiendo que si existe, se pide otro. Por ello, este no se puede enviar por parametro ($1)
	$GRUPO = Read-Host "Grupo: "
	while ( "existGroup $GRUPO" -Match "1" ) {
		$GRUPO = Read-Host "Grupo $GRUPO ya existe, ingrese nuevo"
	}
	Write-Host "¿Cual de los siguientes valores desea establecer para el parametro GroupScope al grupo $GRUPO?"
	$RESPUESTA = Read-Host "[dl] DomainLocal [g] Global [u] Universal: (por defecto es "g")" 
	if ( "$RESPUESTA" -Match "dl" ) {
		Write-Host "Ha seleccionado la opcion [dl]"
		# Crear grupo
		New-ADGroup $GRUPO -Path "OU=$UO,$DC" -GroupScope DomainLocal
	}
	elseif ( "$RESPUESTA" -Match "g" ) {
		Write-Host "Ha seleccionado la opcion [g]"
		# Crear grupo
		New-ADGroup $GRUPO -Path "OU=$UO,$DC" -GroupScope Global
	}
	elseif ( "$RESPUESTA" -Match "u" ) {
		Write-Host "Ha seleccionado la opcion [u]"
		# Crear grupo
		New-ADGroup $GRUPO -Path "OU=$UO,$DC" -GroupScope Universal
	}
	else {
		Write-Host "Como el caracter introducido es diferente a los especificados previamente, se tratara como [g]"
		# Crear grupo
		New-ADGroup $GRUPO -Path "OU=$UO,$DC" -GroupScope Global
	}
}

# Eliminar un grupo
function delGroup() {
	Clear-Host;Write-Host "Eliminar un grupo"
	# Solicitar grupo sabiendo que si no existe, se pide otro. Por ello, este no se puede enviar por parametro ($1)
	$GRUPO = Read-Host "Grupo: "
	while ( "existUser $GRUPO" -NotMatch "$GRUPO" ) {
		$GRUPO = Read-Host "El grupo $GRUPO no existe, ingrese uno nuevo"
	}
	Remove-ADGroup $GRUPO 
}

# Modificar un grupo
function modGroup {
	Clear-Host;Write-Host "Modificar un grupo"
	# Modificar un grupo
	# Solicitar grupo sabiendo que si no existe, se pide otro. Por ello, este no se puede enviar por parametro ($1)
	$GRUPO = Read-Host "Grupo: "
	while ( "existUser $GRUPO" -NotMatch "$GRUPO" ) {
		$GRUPO = Read-Host "El grupo $GRUPO no existe, ingrese uno nuevo"
	}
	# Solicitar otros campos del usuario
	Write-Host "A continuacion, podra añadir Eliminar un usuario a un grupo:"
	# Solicitar usuario sabiendo que si no existe, se pide otro. Por ello, este no se puede enviar por parametro ($1)
	$USUARIO = Read-Host "Usuario: "
	while ( "existUser $USUARIO" -NotMatch "$USUARIO" ) {
		$USUARIO = Read-Host "Usuario $USUARIO ya existe, ingrese nuevo"
	}		
	Write-Host "¿Cual de los siguientes opciones desea usar para modificar el grupo $GRUPO, respecto al usuario $USUARIO introducido previamente?"
	$RESPUESTA = Read-Host "[a] Añadir [r] Eliminar [g] Enumerar: (por defecto es "r")" 
	if ( "$RESPUESTA" -Match "a" ) {
		Write-Host "Ha seleccionado la opcion [a]"
		# Añadir un usuario a un grupo:
		Add-ADGroupmember $GRUPO -Members $USUARIO
	}
	elseif ( "$RESPUESTA" -Match "r" ) {
		Write-Host "Ha seleccionado la opcion [r]"
		# Eliminar un usuario de un grupo
		Remove-ADGroupmember $GRUPO -Member $USUARIO
	}
	elseif ( "$RESPUESTA" -Match "g" ) {
		Write-Host "Ha seleccionado la opcion [g]"
		# Enumerar miembros de un grupo
		Get-ADGroupMember "$GRUPO"
	}
	else {
		Write-Host "Como el caracter introducido es diferente a los especificados previamente, se tratara como [g]"
		# Enumerar miembros de un grupo
		Get-ADGroupMember "$GRUPO"
	}
}

# Limpiar la pantalla al lanzar el menu
Clear-Host

# Funcion que muestra las opciones del menu
function getOptions{
    Write-Host "1. Crear un grupo"
    Write-Host "2. Obtener todos los grupos"
    Write-Host "3. Obtener un grupo"
    Write-Host "4. Modificar un grupo"
    Write-Host "5. Eliminar un grupo"
    Write-Host "6. Cerrar el programa"    
    
}
 
# Ejecucion de la funcion para que muestre las opciones del menu
getOptions
 
# Leer la opcion introducida por el usuario
$OPCION = Read-Host "Introduzca una opcion"

# Bucle para permanecer en el menu hasta que el usuario introduzca la opcion 6
while($OPCION -ne 6)
{
	# Comprobar que ha introducido el usuario
    switch($OPCION)
    {
        1{addGroup}
        2{getAllGroups}
        3{getGroup}
        4{modGroup}
        5{delGroup}
        6{exit}
    }
	# Volvemos a ejecutar la funcion para que muestre las opciones del menu
    getOptions
	# Leer la nueva opcion introducida por el usuario
    $OPCION = Read-Host "Introduzca una nueva opcion"
}
