
# Autor: Jose Maria Viudez
# Descripcion: Script para realizar copias de seguridad a los usuarios del sistema.
# Este script debe ser ejecutado con permisos de administrador.
# En este caso, las variables se han declarado en el propio script

# Limpiar la pantalla al lanzar el menu
Clear-Host

# Funcion para hacer una copia de seguridad de un usuario
function Backup-Users {
	# Pedimos al usuario que introduzca los nombres de los usuarios separados por espacio
	$users = Read-Host "Introduce los nombres de los usuarios separados por espacios"

	# Convertimos la cadena de usuarios en un array y eliminamos posibles espacios en blanco
	$users = $users.Trim() -split '\s+'

	# Iteramos por cada usuario y realizamos las comprobaciones necesarias antes de hacer la copia de seguridad
	foreach ($user in $users) {
		# Comprobamos que el usuario exista en el sistema
		# if (-not (Get-ADUser -Filter {SamAccountName -eq $user})) {
		$ErrorActionPreference = "SilentlyContinue"
		if (-not (Get-LocalUser -Name "$user")) {
			Write-Host "El usuario '$user' no existe en el sistema. No se realizara la copia de seguridad."
			continue
		} 
		
		# Comprobamos que el usuario tenga un directorio de inicio
		# $userFolder = (Get-ADUser -Identity $user -Properties Homedirectory).Homedirectory
		$usersPath = "C:\Users"
		$userFolder = Join-Path $usersPath "$user"
		if (-not $userFolder) {
			Write-Host "El usuario '$user' no tiene un directorio de inicio. No se realizara la copia de seguridad."
			continue
		}
		
		# Comprobamos que tengamos permisos para acceder al directorio de inicio del usuario
		try {
			$acl = Get-Acl $userFolder
		} catch {
			Write-Host "No se tienen permisos para acceder al directorio de inicio del usuario '$user'. No se realizara la copia de seguridad."
			continue
		}
		
		# Creamos el directorio de backup en el directorio de inicio del usuario
		# $backupPath = Join-Path $userFolder "backup"
		$backupPath = "C:\UserBackups"
		if (-not (Test-Path $backupPath)) {
			New-Item -ItemType Directory -Path $backupPath | Out-Null
		}
		
		# Realizamos la copia de seguridad
		$backupDate = Get-Date -Format "yyyyMMdd-HHmmss"
		$backupFile = Join-Path $backupPath "backup-$user-$backupDate.zip"
		Compress-Archive -Path $userFolder\* -DestinationPath $backupFile -Force
		
		# Comprobar que la copia de seguridad se realizo correctamente
		if (Test-Path $backupFile) {
			Write-Host "La copia de seguridad de $user se realizo correctamente."
			Write-Host "Se ha realizado una copia de seguridad de los archivos del usuario '$user' en el archivo '$backupFile'."
		}
		else {
			Write-Host "La copia de seguridad de $user no se pudo realizar."
		}
		
	}

}

# Ejecucion de las siguientes funciones
Backup-Users


