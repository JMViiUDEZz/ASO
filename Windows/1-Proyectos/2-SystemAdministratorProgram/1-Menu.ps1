
# Autor: Jose Maria Viudez
# Descripcion: Realizar un conjunto de scripts en PowerShell para
# poder gestionarlos gracias al menu que aparece a continuacion.
# En este caso, las variables se han declarado en el propio script

# Limpiar la pantalla al lanzar el menu
Clear-Host

# Funcion que muestra las opciones del menu
function getOptions{
    Write-Host "1. Monitorear los recursos del sistema"
	Write-Host "2. Realizar copias de seguridad a los usuarios del sistema"
	Write-Host "3. Restaurar copias de seguridad de los usuarios del sistema"
    Write-Host "4. Cerrar el programa"  
}
 
# Ejecucion de la funcion para que muestre las opciones del menu
getOptions
 
# Leer la opcion introducida por el usuario
$Option = Read-Host "Introduzca una opcion"

# Bucle para permanecer en el menu hasta que el usuario introduzca la opcion 4
while($Option -ne 4)
{
	# Comprobar que ha introducido el usuario
    switch($Option)
    {
		1{
			Write-Host "¿Desea realizarlo en el propio equipo cliente o en el servidor?"
			$Ok = Read-Host "[c] Client  [s] Server: (por defecto es "c")"
			if ( "$Ok" -Match "c" ) {
				Write-Host "Ha seleccionado la opcion [c]"
				C:\ASO\Windows\1-Proyectos\2-SystemAdministratorProgram\1.1-ResourcesMonitoring.ps1
			}
			elseif ( "$Ok" -Match "s" ) {
				Write-Host "Ha seleccionado la opcion [s]"
				Invoke-Command -ComputerName w-server -Credential ASIR\Administrador -FilePath C:\ASO\Windows\1-Proyectos\2-SystemAdministratorProgram\1.1-ResourcesMonitoring.ps1
			}
			else {
				Write-Host "Como el caracter introducido es diferente a los especificados previamente, se tratara como [c]"
				C:\ASO\Windows\1-Proyectos\2-SystemAdministratorProgram\1.1-ResourcesMonitoring.ps1
			}	
		}	
		2{
			Write-Host "¿Desea realizarlo en el propio equipo cliente o en el servidor?"
			$Ok = Read-Host "[c] Client  [s] Server: (por defecto es "c")"
			if ( "$Ok" -Match "c" ) {
				Write-Host "Ha seleccionado la opcion [c]"
				C:\ASO\Windows\1-Proyectos\2-SystemAdministratorProgram\1.2-MakeUserBackups.ps1
			}
			elseif ( "$Ok" -Match "s" ) {
				Write-Host "Ha seleccionado la opcion [s]"
				Invoke-Command -ComputerName w-server -Credential ASIR\Administrador -FilePath C:\ASO\Windows\1-Proyectos\2-SystemAdministratorProgram\1.2-MakeUserBackups.ps1
			}
			else {
				Write-Host "Como el caracter introducido es diferente a los especificados previamente, se tratara como [c]"
				C:\ASO\Windows\1-Proyectos\2-SystemAdministratorProgram\1.2-MakeUserBackups.ps1
			}	
		}	
		3{
			Write-Host "¿Desea realizarlo en el propio equipo cliente o en el servidor?"
			$Ok = Read-Host "[c] Client  [s] Server: (por defecto es "c")"
			if ( "$Ok" -Match "c" ) {
				Write-Host "Ha seleccionado la opcion [c]"
				C:\ASO\Windows\1-Proyectos\2-SystemAdministratorProgram\1.3-RecoverUserBackups.ps1
			}
			elseif ( "$Ok" -Match "s" ) {
				Write-Host "Ha seleccionado la opcion [s]"
				Invoke-Command -ComputerName w-server -Credential ASIR\Administrador -FilePath C:\ASO\Windows\1-Proyectos\2-SystemAdministratorProgram\1.3-RecoverUserBackups.ps1
			}
			else {
				Write-Host "Como el caracter introducido es diferente a los especificados previamente, se tratara como [c]"
				C:\ASO\Windows\1-Proyectos\2-SystemAdministratorProgram\1.3-RecoverUserBackups.ps1
			}	
		}			
		4{exit}
    }
	# Volvemos a ejecutar la funcion para que muestre las opciones del menu
    getOptions
	# Leer la nueva opcion introducida por el usuario
    $OPCION = Read-Host "Introduzca una nueva opcion"
}
