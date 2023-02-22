
# Autor: Jose Maria Viudez
# Descripcion: Realizar un conjunto de scripts en PowerShell con la finalidad de poder facilitar la gestion de usuarios de Active Directory

# Llamar al archivo de configuracion ActiveDirectory.ps1
# . .\ActiveDirectory.ps1

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

# Verifica si una unidad organizativa existe
function existOu {
	$getOu = (Get-ADOrganizationalUnit "OU=$OU,$DC").Name
	$ErrorActionPreference = "SilentlyContinue"
}

# Obtener una unidad organizativa, si existe
function getOu {
	Clear-Host;Write-Host "Obtener una unidad organizativa, si existe"
	$UO = Read-Host "Unidad organizativa"
	existOu
	if ( "$getOu" -Match "$UO") { 
		Write-Host "Busqueda de datos de la unidad organizativa $UO"
		Get-ADOrganizationalUnit "OU=$UO,$DC"
		Start-Sleep -Seconds 3
	}
	else {
		Write-Host "La unidad organizativa ${UO} no existe"
	}
}

# Obtener todas las unidades organizativas
function getAllOus() {
	Clear-Host;Write-Host "Obtener todas las unidades organizativas"
	Write-Host "¿Desea obtenerlas con todas sus propiedades?"
	$RESPUESTA = Read-Host "[y] Yes  [n] No: (por defecto es "n")" 
	if ( "$RESPUESTA" -Match "y" ) {
		Write-Host "Ha seleccionado la opcion [y]"
		# Obtenga todas las propiedades de todas las unidades organizativas.
		Get-ADOrganizationalUnit -Filter * -Properties *
		Start-Sleep -Seconds 3
	}
	elseif ( "$RESPUESTA" -Match "n" ) {
		Write-Host "Ha seleccionado la opcion [n]"
		# Obtenga todas las unidades organizativas de dominio de Active Directory.
		Get-ADOrganizationalUnit -Filter *
		Start-Sleep -Seconds 3
	}
	else {
		Write-Host "Como el caracter introducido es diferente a los especificados previamente, se tratara como [n]"
		# Obtenga todas las unidades organizativas de dominio de Active Directory.
		Get-ADOrganizationalUnit -Filter *
		Start-Sleep -Seconds 3
	}
}

# Crear una unidad organizativa
function addOu {
	Clear-Host;Write-Host "Crear una unidad organizativa"
	# Solicitar unidad organizativa sabiendo que si existe, se pide otro. Por ello, este no se puede enviar por parametro ($1)
	$UO = Read-Host "Unidad organizativa"
	existOu
	while ( "$getOu" -Match "$UO" ) {
		$UO = Read-Host "Unidad organizativa $UO ya existe, ingrese nuevo"
	}
	# Crear unidad organizativa
	New-ADOrganizationalUnit $UO -Path "$DC"
}

# Eliminar una unidad organizativa
function delOu {
	Clear-Host;Write-Host "Eliminar una unidad organizativa"
	# Solicitar unidad organizativa sabiendo que si no existe, se pide otro. Por ello, este no se puede enviar por parametro ($1)
	$UO = Read-Host "Unidad organizativa: "
	existOu
	while ( "$getOu" -NotMatch "$UO" ) {
		$GRUPO = Read-Host "La unidad organizativa $UO no existe, ingrese uno nuevo"
	}
	Remove-ADOrganizationalUnit "OU=$UO,$DC" -Recursive
}

# Limpiar la pantalla al lanzar el menu
Clear-Host

# Funcion que muestra las opciones del menu
function getOptions{
    Write-Host "1. Crear una unidad organizativa"
    Write-Host "2. Obtener todas las unidades organizativas"
	Write-Host "3. Obtener una unidad organizativa"
	Write-Host "4. Eliminar una unidad organizativa"
    Write-Host "5. Cerrar el programa"    
    
}
 
# Ejecucion de la funcion para que muestre las opciones del menu
getOptions
 
# Leer la opcion introducida por el usuario
$OPCION = Read-Host "Introduzca una opcion"

# Bucle para permanecer en el menu hasta que el usuario introduzca la opcion 5
while($OPCION -ne 5)
{
	# Comprobar que ha introducido el usuario
    switch($OPCION)
    {
        1{addOu}
        2{getAllOus}
		3{getOu}
        4{delOu}
        5{exit}
    }
	# Volvemos a ejecutar la funcion para que muestre las opciones del menu
    getOptions
	# Leer la nueva opcion introducida por el usuario
    $OPCION = Read-Host "Introduzca una nueva opcion"
}
