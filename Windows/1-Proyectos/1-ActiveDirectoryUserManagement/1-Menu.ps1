
# Autor: Jose Maria Viudez
# Descripcion: Realizar un conjunto de scripts en PowerShell con la finalidad de poder facilitar la gestion de usuarios de Active Directory

# Llamar al archivo de configuracion ActiveDirectory.ps1
. .\ActiveDirectory.ps1

# Mostrar informacion del dominio
function getAll {
	Clear-Host;Write-Host "Mostrar informacion del dominio..."
	Write-Host "¿Cual de los siguientes opciones desea utilizar respecto al dominio $DOMAIN?"
	$RESPUESTA = Read-Host "[scd] Su controlador de dominio [lcd] Lista controladores de dominio [ccd] Contar controladores de dominio: (por defecto es "d")" 
	if ( "$RESPUESTA" -Match "scd" ) {
		Write-Host "Ha seleccionado la opcion [scd]"
		# Mostrar el controlador de dominio al que pertenece su computadora
		Get-ADDomainController –Discover
	}
	elseif ( "$RESPUESTA" -Match "lcd" ) {
		Write-Host "Ha seleccionado la opcion [lcd]"
		# Mostrar la lista de todos los controladores de dominio
		Get-ADDomainController -Filter * | ft
	}
	elseif ( "$RESPUESTA" -Match "ccd" ) {
		Write-Host "Ha seleccionado la opcion [ccd]"
		# Contar la cantidad de controladores de dominio
		Get-ADDomainController -Filter * | Measure-Object
	}
	else {
		Write-Host "Como el caracter introducido es diferente a los especificados previamente, se tratara como [g]"
		# Enumerar miembros de un grupo
		Get-ADGroupMember "$GRUPO"
	}
}

# Importar usuarios
function imUsers {
	Clear-Host;Write-Host "Importar usuarios..."
	# Introducir un archivo de importacion
	$IMPFILE = Read-Host "Introduce la ruta del archivo de importacion" 
	# Comprobar que el archivo de importacion introducido existe
	$EXISTFILE = Test-Path $IMPFILE	
	if ( $EXISTFILE -eq $True ) {
		Write-Host "El archivo de importacion existe..."
		# Importar usuarios
		Ldifde -i -f $IMPFILE
	}
	elseif ( ( $EXISTFILE -eq $False ) -and ( $IMPFILE -Match "" ) ) {
		Write-Host "Al no introducirlo, se utilizara la ruta por defecto especificada en el archivo de configuracion..."
		# Importar usuarios
		Ldifde -i -f $DEFIMPFILE
	}
	else {
		Write-Host "El archivo de importacion no existe, por lo que se utilizara la ruta por defecto especificada en el archivo de configuracion..."
		# Importar usuarios
		Ldifde -i -f $DEFIMPFILE
	}
}

# Exportar usuarios
function exUsers {
	Clear-Host;Write-Host "Exportar usuarios..."
	# Introducir un archivo de exportacion
	$EXPFILE = Read-Host "Introduce la ruta del archivo de exportacion: " 
	# Comprobar que el archivo de exportacion introducido no existe
	$EXISTFILE = Test-Path $EXPFILE	
	if ( $EXISTFILE -eq $True ) {
		Write-Host "El archivo de exportacion ya existe, por lo que se eliminara para poder reemplazarlo..."
		Remove-Item $EXPFILE	
		# Exportar usuarios
		Ldifde -r "objectClass=User" -f $EXPFILE
	}
	elseif ( $EXISTFILE -eq $False ) {
		Write-Host "El archivo de exportacion no existe..."
		# Exportar usuarios
		Ldifde -r "objectClass=User" -f $EXPFILE
	}
	elseif ( ( $EXISTFILE -eq $False ) -and ( $EXPFILE -Match "" ) ) {
		Write-Host "Al no introducirlo, se utilizara la ruta por defecto especificada en el archivo de configuracion"
		# Exportar usuarios
		Ldifde -r "objectClass=User" -f $DEFEXPFILE
	}
	else {
		Write-Host "El archivo de importacion no existe, por lo que se utilizara la ruta por defecto especificada en el archivo de configuracion"
		# Exportar usuarios
		Ldifde -r "objectClass=User" -f $DEFEXPFILE
	}
}

# Limpiar la pantalla al lanzar el menu
Clear-Host

# Funcion que muestra las opciones del menu
function getOptions{
    Write-Host "1. Mostrar informacion del dominio"
    Write-Host "2. Menu para gestionar unidades organizativas"
	Write-Host "3. Menu para gestionar grupos"
    Write-Host "4. Menu para gestionar usuarios"
    Write-Host "5. Importar usuarios"
	Write-Host "6. Exportar usuarios"
    Write-Host "7. Cerrar el programa"    
    
}
 
# Ejecucion de la funcion para que muestre las opciones del menu
getOptions
 
# Leer la opcion introducida por el usuario
$OPCION = Read-Host "Introduzca una opcion"

# Bucle para permanecer en el menu hasta que el usuario introduzca la opcion 7
while($OPCION -ne 7)
{
	# Comprobar que ha introducido el usuario
    switch($OPCION)
    {
        1{Invoke-Command -ComputerName w-server -ScriptBlock {getAll}}
        2{Invoke-Command -ComputerName w-server -FilePath C:\1-ActiveDirectoryUserManagement\1.1-MenuOrganizationalUnits.ps1}
        3{Invoke-Command -ComputerName w-server -FilePath C:\1-ActiveDirectoryUserManagement\1.2-MenuGroups.ps1}
        4{Invoke-Command -ComputerName w-server -FilePath C:\1-ActiveDirectoryUserManagement\1.3-MenuUsers.ps1}
        5{Invoke-Command -ComputerName w-server -ScriptBlock {imUsers}}
        6{Invoke-Command -ComputerName w-server -ScriptBlock {exUsers}}
		7{exit}
    }
	# Volvemos a ejecutar la funcion para que muestre las OPCIONes del menu
    getOptions
	# Leer la nueva opcion introducida por el usuario
    $OPCION = Read-Host "Introduzca una nueva opcion"
}
