
# Autor: Jose Maria Viudez
# Descripcion: Realizar un conjunto de scripts en PowerShell para
# poder gestionarlos gracias al menu que aparece a continuacion.
# En este caso, las variables se han declarado en el propio script

# Limpiar la pantalla al lanzar el menu
Clear-Host

# Funcion que muestra las opciones del menu
function getOptions{
    Write-Host "1. Monitorear los recursos del sistema del servidor"
	Write-Host "2. Monitorear los recursos del sistema del cliente"
	Write-Host "3. Realizar copias de seguridad a los usuarios del sistema"
	Write-Host "4. Restaurar copias de seguridad de los usuarios del sistema"
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
        1{Invoke-Command -ComputerName w-server -Credential ASIR\Administrador -FilePath C:\ASO\Windows\1-Proyectos\2-SystemAdministratorProgram\1.1-ResourcesMonitoring.ps1}
        2{C:\ASO\Windows\1-Proyectos\2-SystemAdministratorProgram\1.1-ResourcesMonitoring.ps1}
		3{Invoke-Command -ComputerName w-server -Credential ASIR\Administrador -FilePath C:\ASO\Windows\1-Proyectos\2-SystemAdministratorProgram\1.2-MakeUserBackups.ps1}
        4{Invoke-Command -ComputerName w-server -Credential ASIR\Administrador -FilePath C:\ASO\Windows\1-Proyectos\2-SystemAdministratorProgram\1.3-RecoverUserBackups.ps1}
		5{exit}
    }
	# Volvemos a ejecutar la funcion para que muestre las opciones del menu
    getOptions
	# Leer la nueva opcion introducida por el usuario
    $OPCION = Read-Host "Introduzca una nueva opcion"
}
