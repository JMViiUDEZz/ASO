
# Autor: Jose Maria Viudez
# Descripcion: Realizar un conjunto de scripts en PowerShell con la finalidad de poder facilitar la gestion de usuarios de Active Directory

# Llamar al archivo de configuracion ActiveDirectory.ps1
. .\ActiveDirectory.ps1

# Verifica si un usuario existe
function existUser {
	(Get-ADUser $1).SamAccountName
}

function existUserName {
	# Obtenga todos los usuarios con un texto especifico en el nombre.
	(Get-Aduser -Filter { Name -like "*$1 $2*"}).Name
}
# Verifica si una unidad organizativa existe
function existOu {
	(Get-ADOrganizationalUnit "OU=$1,$DC").Name
}

# Asignar clave a un usuario
function modPasswd {
	Clear-Host;Write-Host "Cambiar clave a un usuario..."
	# Solicitar confirmacion para cambiar la clave del usuario que se muestra
	Write-Host "¿Desea establecer una contraseña al usuario $1?"
	$RESPUESTA = Read-Host "[y] Yes  [n] No: (por defecto es "n")" 
	if ( "$RESPUESTA" -Match "y" ) {
		Write-Host "Ha seleccionado la opcion [y]"
		# Repetir hasta tener una clave valida
		while ( $PASSWORD_OK -eq 0 ) {
			# Solicitar clave hasta tener una valida
			getModPasswd
			# Verificar clave sabiendo que si no es valida, se vuelve a pedir
			checkModPasswd $PASSWORD
			# Si la clave es valida, se rompe el bucle
			# if ( $PASSWORD_OK -eq 0 ]; then
				# break
			# fi
			# Verificar salida comando
			Set-ADAccountPassword $1 -NewPassword (ConvertTo-SecureString -AsPlainText "$PASSWORD" -force)
			if ( $? -ne $True ) {
				Write-Host "[ERROR] - La clave no cumple lo minimo requerido"
				PASSWORD_OK=1
			}
		}
	}
	elseif ( "$RESPUESTA" -Match "n" ) {
		Write-Host "Ha seleccionado la opcion [n]"
		Write-Host "Al no establecerla, el usuario debera cambiarla en el proximo intento de inicio de sesion."
		Set-ADUser $1 -ChangePasswordAtLogon $True
	}
	else {
		Write-Host "Como el caracter introducido es diferente a los especificados previamente, se tratara como [n]"
		Write-Host "Al no establecerla, el usuario debera cambiarla en el proximo intento de inicio de sesion."
		Set-ADUser $1 -ChangePasswordAtLogon $True
	}
}

# Solicitar clave al usuario (2 veces)
function getModPasswd {
	$PASSWORD1 = Read-Host "Contraseña"
	$PASSWORD2 = Read-Host "Repetir contraseña"
	# stty -Write-Host; Read-Host PASSWORD2; stty Write-Host; Write-Host ""
	# Si las claves son diferentes, se piden de nuevo
	if ( "$PASSWORD1" -NotMatch "$PASSWORD2" ) {
		PASSWORD=1
	}
	else {
		PASSWORD=$PASSWORD1
	}
}

# Verificar que la clave cumpla unas minimas condiciones 
function checkModPasswd {
	# Copiar clave
	PASSWORD=$1
	# Se asume que la clave es valida
	PASSWORD_OK=0
	# Si la clave es igual a 1, estas son diferentes
	if ( "$PASSWORD" -Match "1" ) {
		Write-Host "[ERROR] - Las contraseñas son diferentes"
		PASSWORD_OK=1
	}
}

# Activar la cuenta del usuario
function enDisUser {
	Write-Host "Lista de cuentas de usuario deshabilitadas"
	# Obtenga la lista de cuentas de usuario deshabilitadas.
	Search-ADAccount -AccountDisabled | select Name, SamAccountName
	Write-Host "¿Desea activar la cuenta del usuario $1?"
	$OK = Read-Host "[y] Yes  [n] No: (por defecto es "n")"
	if ( "$RESPUESTA" -Match "y" ) {
		Write-Host "Ha seleccionado la opcion [y]"
		Write-Host "Activando la cuenta del usuario $1"
		Enable-ADAccount $1
	}
	elseif ( "$RESPUESTA" -Match "n" ) {
		Write-Host "Ha seleccionado la opcion [n]"
		Write-Host "Desactivando la cuenta del usuario $1"
		Disable-ADAccount $1
	}
	else {
		Write-Host "Como el caracter introducido es diferente a los especificados previamente, se tratara como [n]"
		Write-Host "Desactivando la cuenta del usuario $1"
		Disable-ADAccount $1
	}
}

# Desbloquear la cuenta del usuario (Bloqueado por introducir una contraseña erronea reiteradamente)
function unUser {
	Write-Host "Lista de cuentas de usuario bloqueadas: "
	# Obtenga la lista de cuentas de usuario bloqueadas.
	Search-ADAccount -LockedOut | select Name, SamAccountName
	Write-Host "¿Desea Desbloquear la cuenta del usuario $1?"
	$OK = Read-Host "[y] Yes  [n] No: (por defecto es "n")"
	if ( "$RESPUESTA" -Match "y" ) {
		Write-Host "Ha seleccionado la opcion [y]"
		Write-Host "Desbloqueando la cuenta del usuario $1"
		Unlock-ADAccount $1
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
	if ( "existUser $USUARIO" -NotMatch "$USUARIO" ) {
		Write-Host "El usuario $USUARIO no existe"
		Write-Host "¿Desea obtenerlo mediante su nombre y apellido?"
		$RESPUESTA = Read-Host "[y] Yes  [n] No: (por defecto es "n")" 
		if ( "$RESPUESTA" -Match "y" ) {
			Write-Host "Ha seleccionado la opcion [y]"
			$NOMBRE = Read-Host "Nombre"
			$APELLIDO = Read-Host "Apellido"
			if ( "existUserName $NOMBRE $APELLIDO" -NotLike "*$NOMBRE $APELLIDO*" ) {
				Write-Host "El usuario $USUARIO llamado $NOMBRE $APELLIDO no existe"
			}
			else {
				Write-Host "Busqueda de datos del usuario $USUARIO llamado $NOMBRE ${APELLIDO}: "
				# Obtenga todos los usuarios con un texto especifico en el nombre.
				Get-Aduser -Filter { Name -like "existUserName $NOMBRE $APELLIDO"}
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
		Write-Host "Busqueda de datos del usuario $USUARIO: "
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
	$OU = Read-Host "Unidad organizativa"
	if ( "existOu $OU" -NotMatch "$OU" ) {
		Write-Host "La unidad organizativa $OU no existe"
	}
	else {
		Write-Host "Busqueda de datos los usuarios de la unidad organizativa ${OU}: "
		# Obtenga todos los usuarios de una unidad organizativa especifica.
		Get-ADUser -Filter * -SearchBase "OU=$OU,$DC" 
		Start-Sleep -Seconds 3
	}
}

# Crear un usuario
function addUser {
	Clear-Host;Write-Host "Crear un usuario"
	# Solicitar usuario sabiendo que si existe, se pide otro. Por ello, este no se puede enviar por parametro ($1)
	$USUARIO = Read-Host "Usuario: "
	while ( "existUser $USUARIO" -Match "$USUARIO" ) {
		$USUARIO = Read-Host "Usuario $USUARIO ya existe, ingrese nuevo"
	}
	# Solicitar otros campos del usuario
	$NOMBRE = Read-Host "Nombre"
	$APELLIDO = Read-Host "Apellido"
	# $GRUPO = Read-Host "Grupo principal (getAllGroups): " GRUPO
	# Crear usuario
	New-ADUser "$NOMBRE $APELLIDO" -Path "OU=$UO,$DC" -SamAccountName $USUARIO -GivenName "$NOMBRE" -SurName "$APELLIDO"
	# Asignar clave al usuario
	modPasswd $USUARIO
	# Activar la cuenta del usuario
	enDisUser $USUARIO
}

# Modificar un usuario
function modUser {
	Clear-Host;Write-Host "Modificar un usuario"
	# Modificar un usuario
	# Solicitar usuario sabiendo que si no existe, se pide otro. Por ello, este no se puede enviar por parametro ($1)
	$USUARIO = Read-Host "Usuario"
	while ( "existUser $USUARIO" -NotMatch "$USUARIO" ) {
		$USUARIO = Read-Host "El usuario $USUARIO no existe, ingrese uno nuevo: "
	}
	# Solicitar otros campos del usuario
	Read-Host "Nombre" NOMBRE
	Read-Host "Apellido" APELLIDO
	# Modificar usuario
	Set-ADUser $USUARIO -GivenName "$NOMBRE" -SurName "$APELLIDO"
	# Asignar clave al usuario
	modPasswd $USUARIO
	# Activar o desactivar la cuenta del usuario
	enDisUser $USUARIO
	# Desbloquear la cuenta del usuario
	unUser $USUARIO

}

# Eliminar un usuario
function delUser {
	Clear-Host;Write-Host "Eliminar un usuario"
	# Solicitar usuario sabiendo que si no existe, se pide otro. Por ello, este no se puede enviar por parametro ($1)
	$USUARIO = Read-Host "Usuario"
	while ( "existUser $USUARIO" -NotMatch "$USUARIO" ) {
		$USUARIO = Read-Host "El usuario $USUARIO no existe, ingrese uno nuevo"
	}
	Remove-ADUser $USUARIO
}

# Limpiar la pantalla al lanzar el menu
Clear-Host

# Funcion que muestra las opciones del menu
function getOptions{
    Write-Host "1. Crear un usuario"
    Write-Host "2. Obtener todos los usuarios"
	Write-Host "3. Obtener un usuario"
    Write-Host "4. Modificar un usuario"
	Write-Host "5. Eliminar un usuario"
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
        1{addUser}
        2{getAllUsers}
		3{getUser}
        4{modUser}
        5{delUser}
		6{exit}
    }
	# Volvemos a ejecutar la funcion para que muestre las opciones del menu
    getOptions
	# Leer la nueva opcion introducida por el usuario
    $OPCION = Read-Host "Introduzca una nueva opcion"
}
