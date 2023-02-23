
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
$DEFIMPFILE="$C:\usersImported.ldf"
$DEFEXPFILE="$C:\usersExported.ldf"
# En este caso, las variables se han declarado en el propio script

# Asignar clave a un usuario
function modPasswd {
	Clear-Host;Write-Host "Cambiar clave a un usuario..."
	# Solicitar confirmacion para cambiar la clave del usuario que se muestra
	Write-Host "¿Desea establecer una contraseña al usuario $USUARIO?"
	$RESPUESTA = Read-Host "[y] Yes  [n] No: (por defecto es "n")" 
	if ( "$RESPUESTA" -Match "y" ) {
		Write-Host "Ha seleccionado la opcion [y]"
		# Repetir hasta tener una clave valida
		while ( $PASSWORD_OK -eq 0 ) {
			# Solicitar clave hasta tener una valida
			# Verificar clave sabiendo que si no es valida, se vuelve a pedir
			# Solicitar clave al usuario (2 veces)
			$PASSWORD1 = Read-Host "Contraseña"
			$PASSWORD2 = Read-Host "Repetir contraseña"
			# Si las claves son diferentes, se piden de nuevo
			if ( "$PASSWORD1" -NotMatch "$PASSWORD2" ) {
				PASSWORD=1
			}
			else {
				# Verificar que la clave cumpla unas minimas condiciones 
				# Copiar clave
				PASSWORD=$PASSWORD1
				# Se asume que la clave es valida
				PASSWORD_OK=0
				# Si la clave es igual a 1, estas son diferentes
				if ( "$PASSWORD" -Match "1" ) {
					Write-Host "[ERROR] - Las contraseñas son diferentes"
					PASSWORD_OK=1
				}	
			}
			# Si la clave es valida, se rompe el bucle
			# if ( $PASSWORD_OK -eq 0 ) {
				# break
			# }
			# Verificar salida comando
			$ErrorActionPreference = "SilentlyContinue"
			$checkModPasswd = Set-ADAccountPassword $USUARIO -NewPassword (ConvertTo-SecureString -AsPlainText "$PASSWORD" -force)
			if ( $? -eq $False ) {
				Write-Host "[ERROR] - La clave no cumple lo minimo requerido"
				PASSWORD_OK=1
			}
		}
		Set-ADAccountPassword $USUARIO -NewPassword (ConvertTo-SecureString -AsPlainText "$PASSWORD" -force)
	}
	elseif ( "$RESPUESTA" -Match "n" ) {
		Write-Host "Ha seleccionado la opcion [n]"
		Write-Host "Al no establecerla, el usuario debera cambiarla en el proximo intento de inicio de sesion."
		Set-ADUser $USUARIO -ChangePasswordAtLogon $True
	}
	else {
		Write-Host "Como el caracter introducido es diferente a los especificados previamente, se tratara como [n]"
		Write-Host "Al no establecerla, el usuario debera cambiarla en el proximo intento de inicio de sesion."
		Set-ADUser $USUARIO -ChangePasswordAtLogon $True
	}
}

# Activar la cuenta del usuario
function enDisUser {
	Write-Host "Lista de cuentas de usuario deshabilitadas"
	# Obtenga la lista de cuentas de usuario deshabilitadas.
	Search-ADAccount -AccountDisabled | select Name, SamAccountName
	Write-Host "¿Desea activar la cuenta del usuario $USUARIO?"
	$OK = Read-Host "[y] Yes  [n] No: (por defecto es "n")"
	if ( "$RESPUESTA" -Match "y" ) {
		Write-Host "Ha seleccionado la opcion [y]"
		Write-Host "Activando la cuenta del usuario $USUARIO"
		Enable-ADAccount $USUARIO
	}
	elseif ( "$RESPUESTA" -Match "n" ) {
		Write-Host "Ha seleccionado la opcion [n]"
		Write-Host "Desactivando la cuenta del usuario $USUARIO"
		Disable-ADAccount $USUARIO
	}
	else {
		Write-Host "Como el caracter introducido es diferente a los especificados previamente, se tratara como [n]"
		Write-Host "Desactivando la cuenta del usuario $USUARIO"
		Disable-ADAccount $USUARIO
	}
}

# Desbloquear la cuenta del usuario (Bloqueado por introducir una contraseña erronea reiteradamente)
function unUser {
	Write-Host "Lista de cuentas de usuario bloqueadas: "
	# Obtenga la lista de cuentas de usuario bloqueadas.
	Search-ADAccount -LockedOut | select Name, SamAccountName
	Write-Host "¿Desea Desbloquear la cuenta del usuario $USUARIO?"
	$OK = Read-Host "[y] Yes  [n] No: (por defecto es "n")"
	if ( "$RESPUESTA" -Match "y" ) {
		Write-Host "Ha seleccionado la opcion [y]"
		Write-Host "Desbloqueando la cuenta del usuario $USUARIO"
		Unlock-ADAccount $USUARIO
	}
	elseif ( "$RESPUESTA" -Match "n" ) {
		Write-Host "Ha seleccionado la opcion [n]"
	}
	else {
		Write-Host "Como el caracter introducido es diferente a los especificados previamente, se tratara como [n]"
	}
}

# Obtener un usuario, si existe
function getUser {
	Clear-Host;Write-Host "Obtener un usuario, si existe"
	$USUARIO = Read-Host "Usuario"
	# Verifica si un usuario existe
	$existUser = (Get-ADUser $USUARIO).SamAccountName
	$ErrorActionPreference = "SilentlyContinue"
	if ( "$existUser" -NotMatch "$USUARIO" ) {
		Write-Host "El usuario $USUARIO no existe"
		Write-Host "¿Desea obtenerlo mediante su nombre y apellido?"
		$RESPUESTA = Read-Host "[y] Yes  [n] No: (por defecto es "n")" 
		if ( "$RESPUESTA" -Match "y" ) {
			Write-Host "Ha seleccionado la opcion [y]"
			$NOMBRE = Read-Host "Nombre"
			$APELLIDO = Read-Host "Apellido"
			# Verifica si un usuario existe
			$existUserName = (Get-ADUser -Filter { Name -like "*$NOMBRE $APELLIDO*"}).SamAccountName
			$ErrorActionPreference = "SilentlyContinue"
			if ( "$existUserName" -NotMatch "$USUARIO" ) {
				Write-Host "El usuario $USUARIO llamado $NOMBRE $APELLIDO no existe"
			}
			else {
				Write-Host "Busqueda de datos del usuario $USUARIO llamado $NOMBRE ${APELLIDO}: "
				# Obtenga todos los usuarios con un texto especifico en el nombre.
				Get-Aduser -Filter { Name -like "*$NOMBRE $APELLIDO*"}
				Start-Sleep -Seconds 3
			}
		}
		elsif ( "$RESPUESTA" -Match "n" ) {
			Write-Host "Ha seleccionado la opcion [n]"
			Write-Host "El usuario $USUARIO no existe"
		}
		else {
			Write-Host "Como el caracter introducido es diferente a los especificados previamente, se tratara como [n]"
			Write-Host "El usuario $USUARIO no existe"
		}
	}
	else {
		Write-Host "Busqueda de datos del usuario ${USUARIO}: "
		Get-ADUser $USUARIO
		Start-Sleep -Seconds 3
	}

}

# Obtener todos los usuarios
function getAllUsers {
	Clear-Host;Write-Host "Obtener todos los usuarios"
	Write-Host "¿Desea obtenerlos con todas sus propiedades?"
	$RESPUESTA = Read-Host "[y] Yes  [n] No: (por defecto es "n")" 
	if ( "$RESPUESTA" -Match "y" ) {
		Write-Host "Ha seleccionado la opcion [y]"
		# Obtenga todas las propiedades de todas las cuentas de usuario.
		Get-ADUser -Filter * -Properties *
		Start-Sleep -Seconds 3
	}
	elseif ( "$RESPUESTA" -Match "n" ) {
		Write-Host "Ha seleccionado la opcion [n]"
		# Obtenga todos los usuarios de dominio de Active Directory.
		Get-ADUser -Filter *
		Start-Sleep -Seconds 3
	}
	else {
		Write-Host "Como el caracter introducido es diferente a los especificados previamente, se tratara como [n]"
		# Obtenga todos los usuarios de dominio de Active Directory.
		Get-ADUser -Filter *
		Start-Sleep -Seconds 3
	}
}

# Obtener todos los usuarios de una unidad organizativa 
function getAllUsersOu() {
	Clear-Host;Write-Host "Obtener todos los usuarios de una unidad organizativa"
	$UO= Read-Host "Unidad organizativa"
	# Verifica si una unidad organizativa existe
	$existOu = (Get-ADOrganizationalUnit "OU=$UO,$DC").Name
	$ErrorActionPreference = "SilentlyContinue"
	if ( "$existOu" -NotMatch "$UO" ) {
		Write-Host "La unidad organizativa $UO no existe"
	}
	else {
		Write-Host "Busqueda de datos los usuarios de la unidad organizativa ${OU}: "
		# Obtenga todos los usuarios de una unidad organizativa especifica.
		Get-ADUser -Filter * -SearchBase "OU=$UO,$DC" 
		Start-Sleep -Seconds 3
	}
}

# Crear un usuario
function addUser {
	Clear-Host;Write-Host "Crear un usuario"
	# Solicitar usuario sabiendo que si existe, se pide otro. Por ello, este no se puede enviar por parametro ($1)
	$USUARIO = Read-Host "Usuario"
	# Verifica si un usuario existe
	$existUser = (Get-ADUser $USUARIO).SamAccountName
	$ErrorActionPreference = "SilentlyContinue"
	while ( "$existUser" -Match "$USUARIO" ) {
		$USUARIO = Read-Host "Usuario $USUARIO ya existe, ingrese nuevo"
	}
	# Solicitar otros campos del usuario
	$NOMBRE = Read-Host "Nombre"
	$APELLIDO = Read-Host "Apellido"
	# Crear usuario
	New-ADUser "$NOMBRE $APELLIDO" -Path "OU=usuarios,$DC" -SamAccountName $USUARIO -GivenName "$NOMBRE" -SurName "$APELLIDO"
	# Asignar clave al usuario
	# modPasswd $USUARIO
	# Activar la cuenta del usuario
	# enDisUser $USUARIO
}

# Modificar un usuario
function modUser {
	Clear-Host;Write-Host "Modificar un usuario"
	# Modificar un usuario
	# Solicitar usuario sabiendo que si no existe, se pide otro. Por ello, este no se puede enviar por parametro ($1)
	$USUARIO = Read-Host "Usuario"
	# Verifica si un usuario existe
	$existUser = (Get-ADUser $USUARIO).SamAccountName
	$ErrorActionPreference = "SilentlyContinue"
	while ( "$existUser" -NotMatch "$USUARIO" ) {
		$USUARIO = Read-Host "El usuario $USUARIO no existe, ingrese uno nuevo"
	}
	# Solicitar otros campos del usuario
	Read-Host "Nombre" NOMBRE
	Read-Host "Apellido" APELLIDO
	# Modificar usuario
	Set-ADUser $USUARIO -GivenName "$NOMBRE" -SurName "$APELLIDO"
	# Asignar clave al usuario
	# modPasswd $USUARIO
	# Activar o desactivar la cuenta del usuario
	# enDisUser $USUARIO
	# Desbloquear la cuenta del usuario
	# unUser $USUARIO

	# Asignar clave a un usuario
	Clear-Host;Write-Host "Cambiar clave a un usuario..."
	# Solicitar confirmacion para cambiar la clave del usuario que se muestra
	Write-Host "¿Desea establecer una contraseña al usuario $USUARIO?"
	$RESPUESTA = Read-Host "[y] Yes  [n] No: (por defecto es "n")" 
	if ( "$RESPUESTA" -Match "y" ) {
		Write-Host "Ha seleccionado la opcion [y]"
		# Repetir hasta tener una clave valida
		while ( $PASSWORD_OK -eq 0 ) {
			# Solicitar clave hasta tener una valida
			# Verificar clave sabiendo que si no es valida, se vuelve a pedir
			# Solicitar clave al usuario (2 veces)
			$PASSWORD1 = Read-Host "Contraseña"
			$PASSWORD2 = Read-Host "Repetir contraseña"
			# Si las claves son diferentes, se piden de nuevo
			if ( "$PASSWORD1" -NotMatch "$PASSWORD2" ) {
				PASSWORD=1
			}
			else {
				# Verificar que la clave cumpla unas minimas condiciones 
				# Copiar clave
				PASSWORD=$PASSWORD1
				# Se asume que la clave es valida
				PASSWORD_OK=0
				# Si la clave es igual a 1, estas son diferentes
				if ( "$PASSWORD" -Match "1" ) {
					Write-Host "[ERROR] - Las contraseñas son diferentes"
					PASSWORD_OK=1
				}	
			}
			# Si la clave es valida, se rompe el bucle
			# if ( $PASSWORD_OK -eq 0 ) {
				# break
			# }
			# Verificar salida comando
			$ErrorActionPreference = "SilentlyContinue"
			$checkModPasswd = Set-ADAccountPassword $USUARIO -NewPassword (ConvertTo-SecureString -AsPlainText "$PASSWORD" -force)
			if ( $? -eq $False ) {
				Write-Host "[ERROR] - La clave no cumple lo minimo requerido"
				PASSWORD_OK=1
			}
		}
		Set-ADAccountPassword $USUARIO -NewPassword (ConvertTo-SecureString -AsPlainText "$PASSWORD" -force)
	}
	elseif ( "$RESPUESTA" -Match "n" ) {
		Write-Host "Ha seleccionado la opcion [n]"
		Write-Host "Al no establecerla, el usuario debera cambiarla en el proximo intento de inicio de sesion."
		Set-ADUser $USUARIO -ChangePasswordAtLogon $True
	}
	else {
		Write-Host "Como el caracter introducido es diferente a los especificados previamente, se tratara como [n]"
		Write-Host "Al no establecerla, el usuario debera cambiarla en el proximo intento de inicio de sesion."
		Set-ADUser $USUARIO -ChangePasswordAtLogon $True
	}

	# Activar la cuenta del usuario
	Write-Host "Lista de cuentas de usuario deshabilitadas"
	# Obtenga la lista de cuentas de usuario deshabilitadas.
	Search-ADAccount -AccountDisabled | select Name, SamAccountName
	Write-Host "¿Desea activar la cuenta del usuario $USUARIO?"
	$OK = Read-Host "[y] Yes  [n] No: (por defecto es "n")"
	if ( "$RESPUESTA" -Match "y" ) {
		Write-Host "Ha seleccionado la opcion [y]"
		Write-Host "Activando la cuenta del usuario $USUARIO"
		Enable-ADAccount $USUARIO
	}
	elseif ( "$RESPUESTA" -Match "n" ) {
		Write-Host "Ha seleccionado la opcion [n]"
		Write-Host "Desactivando la cuenta del usuario $USUARIO"
		Disable-ADAccount $USUARIO
	}
	else {
		Write-Host "Como el caracter introducido es diferente a los especificados previamente, se tratara como [n]"
		Write-Host "Desactivando la cuenta del usuario $USUARIO"
		Disable-ADAccount $USUARIO
	}

	# Desbloquear la cuenta del usuario (Bloqueado por introducir una contraseña erronea reiteradamente)
	Write-Host "Lista de cuentas de usuario bloqueadas: "
	# Obtenga la lista de cuentas de usuario bloqueadas.
	Search-ADAccount -LockedOut | select Name, SamAccountName
	Write-Host "¿Desea Desbloquear la cuenta del usuario $USUARIO?"
	$OK = Read-Host "[y] Yes  [n] No: (por defecto es "n")"
	if ( "$RESPUESTA" -Match "y" ) {
		Write-Host "Ha seleccionado la opcion [y]"
		Write-Host "Desbloqueando la cuenta del usuario $USUARIO"
		Unlock-ADAccount $USUARIO
	}
	elseif ( "$RESPUESTA" -Match "n" ) {
		Write-Host "Ha seleccionado la opcion [n]"
	}
	else {
		Write-Host "Como el caracter introducido es diferente a los especificados previamente, se tratara como [n]"
	}
}

# Eliminar un usuario
function delUser {
	Clear-Host;Write-Host "Eliminar un usuario"
	# Solicitar usuario sabiendo que si no existe, se pide otro. Por ello, este no se puede enviar por parametro ($1)
	$USUARIO = Read-Host "Usuario"
	# Verifica si un usuario existe
	$existUser = (Get-ADUser $USUARIO).SamAccountName
	$ErrorActionPreference = "SilentlyContinue"
	while ( "$existUser" -NotMatch "$USUARIO" ) {
		$USUARIO = Read-Host "El usuario $USUARIO no existe, ingrese uno nuevo"
	}
	Remove-ADUser $USUARIO
}

# Obtener informacion del dominio
function getAll {
	Clear-Host;Write-Host "Obtener informacion del dominio..."
	Write-Host "¿Cual de los siguientes opciones desea utilizar respecto al dominio $DOMAIN?"
	$RESPUESTA = Read-Host "[scd] Su controlador de dominio [lcd] Lista controladores de dominio [ccd] Contar controladores de dominio: (por defecto es "scd")" 
	if ( "$RESPUESTA" -Match "scd" ) {
		Write-Host "Ha seleccionado la opcion [scd]"
		# Obtener el controlador de dominio al que pertenece su computadora
		Get-ADDomainController -Discover
	}
	elseif ( "$RESPUESTA" -Match "lcd" ) {
		Write-Host "Ha seleccionado la opcion [lcd]"
		# Obtener la lista de todos los controladores de dominio
		Get-ADDomainController -Filter * | ft
	}
	elseif ( "$RESPUESTA" -Match "ccd" ) {
		Write-Host "Ha seleccionado la opcion [ccd]"
		# Contar la cantidad de controladores de dominio
		Get-ADDomainController -Filter * | Measure-Object
	}
	else {
		Write-Host "Como el caracter introducido es diferente a los especificados previamente, se tratara como [scd]"
		# Enumerar miembros de un grupo
		Get-ADDomainController -Discover
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
	Write-Host "1. Obtener informacion del dominio"
    Write-Host "2. Crear un usuario"
    Write-Host "3. Obtener todos los usuarios"
	Write-Host "4. Obtener un usuario"
    Write-Host "5. Modificar un usuario"
	Write-Host "6. Eliminar un usuario"
	Write-Host "7. Importar usuarios"
	Write-Host "8. Exportar usuarios"
    Write-Host "9. Cerrar el programa"    
}
 
# Ejecucion de la funcion para que muestre las opciones del menu
getOptions
 
# Leer la opcion introducida por el usuario
$OPCION = Read-Host "Introduzca una opcion"

# Bucle para permanecer en el menu hasta que el usuario introduzca la opcion 9
while($OPCION -ne 9)
{
	# Comprobar que ha introducido el usuario
    switch($OPCION)
    {
		1{getAll}
        2{addUser}
        3{getAllUsers}
		4{getUser}
        5{modUser}
        6{delUser}
		7{imUsers}
		8{exUsers}
		9{exit}
    }
	# Volvemos a ejecutar la funcion para que muestre las opciones del menu
    getOptions
	# Leer la nueva opcion introducida por el usuario
    $OPCION = Read-Host "Introduzca una nueva opcion"
}
