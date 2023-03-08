
# Autor: Jose Maria Viudez
# Descripcion: Script para restaurar copias de seguridad de los usuarios del sistema.
# Este script debe ser ejecutado con permisos de administrador.
# En este caso, las variables se han declarado en el propio script

# Limpiar la pantalla al lanzar el menu
Clear-Host

# Variables globales
# $backupPath = "C:\UserBackups"
# $restorePath = "C:\UserRestores"

# Funcion para restaurar todas las copias de seguridad de usuarios
Function Restore-AllUsers {
	# Pedimos al usuario que introduzca los nombres de los usuarios separados por espacio
	$users = Read-Host "Introduce los nombres de los usuarios separados por espacio"

	# Convertimos la cadena de usuarios en un array y eliminamos posibles espacios en blanco
	$users = $users.Trim() -split '\s+'

	# Iteramos por cada usuario y realizamos las comprobaciones necesarias antes de recuperar la copia de seguridad
	foreach ($user in $users) {
		# Comprobamos que el usuario exista en el sistema
		# if (-not (Get-ADUser -Filter {SamAccountName -eq $user})) {
		$ErrorActionPreference = "SilentlyContinue"
		if (-not (Get-LocalUser -Name "$user")) {
			Write-Host "El usuario '$user' no existe en el sistema. No se recuperara la copia de seguridad."
			continue
		}
		
		# Comprobamos que el usuario tenga un directorio de inicio
		# $userFolder = (Get-ADUser -Identity $user -Properties Homedirectory).Homedirectory
		$usersPath = "C:\Users"
		$userFolder = Join-Path $usersPath "$user"
		if (-not $userFolder) {
			Write-Host "El usuario '$user' no tiene un directorio de inicio. No se recuperara la copia de seguridad."
			continue
		}
		
		# Comprobamos que tengamos permisos para acceder al directorio de inicio del usuario
		try {
			$acl = Get-Acl $userFolder
		} catch {
			Write-Host "No se tienen permisos para acceder al directorio de inicio del usuario '$user'. No se recuperara la copia de seguridad."
			continue
		}
		
		# Comprobamos que el directorio de backup exista
		# $backupPath = Join-Path $userFolder "backup"
		$backupPath = "C:\UserBackups"
		if (-not (Test-Path $backupPath)) {
			Write-Host "No se ha encontrado el directorio de backup del usuario '$user'. No se recuperara la copia de seguridad."
			continue
		}
		
		# Buscamos el archivo de backup mas reciente
		$backupFile = Get-ChildItem $backupPath -Filter "backup-$user-*.zip" | Sort-Object -Property LastWriteTime -Descending | Select-Object -First 1
		if (-not $backupFile) {
			Write-Host "No se ha encontrado ningun archivo de backup para el usuario '$user'. No se recuperara la copia de seguridad."
			continue
		}
		
		# Recuperamos la copia de seguridad
		# $recoveryPath = Join-Path $userFolder "backup-restore"
		$recoveryDate = Get-Date -Format "yyyyMMdd-HHmmss"
		$recoveryPath = Join-Path "C:\UserRecovery" "recovery-$user-$recoveryDate"
		if (-not (Test-Path $recoveryPath)) {
			New-Item -ItemType Directory -Path $recoveryPath | Out-Null
		}
		Expand-Archive -Path $backupFile -DestinationPath $recoveryPath -Force
		Write-Host "Se ha recuperado la copia de seguridad del usuario '$user' en el directorio '$recoveryPath'."
	}
}

# Restaurar todas las copias de seguridad de usuarios
Restore-AllUsers

