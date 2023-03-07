
# Autor: Jose Maria Viudez
# Descripcion: Script para monitorear los recursos del sistema
# creando un fichero log por cada vez que se ejecute el mismo.
# Este script debe ser ejecutado con permisos de administrador.
# En este caso, las variables se han declarado en el propio script

# Limpiar la pantalla al lanzar el menu
Clear-Host

# Establecer la ruta de la carpeta donde se guardaran los archivos de registro
$logFolder = "C:\Logs"

# Obtener la fecha y hora actual para el nombre del archivo de registro
$logDate = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
$Date = Get-Date -Format "yyyy-MM-dd"
$Time = Get-Date -Format "HH:mm:ss"

# Establecer la ruta del archivo de registro
$logPath = "$logFolder\SystemResources_$logDate.log"

Function Get-SysInfo {
	# Obtener informacion del sistema
	$systemInfo = Get-WmiObject -Class Win32_ComputerSystem
	$osInfo = Get-WmiObject -Class Win32_OperatingSystem
	$processorInfo = Get-WmiObject -Class Win32_Processor
	$memoryInfo = Get-WmiObject -Class Win32_PhysicalMemory
	$diskInfo = Get-WmiObject -Class Win32_LogicalDisk
	
	# Mostrar informacion del sistema
	$ResultSysInfo = Write-Host "`nInformacion del sistema:`n
		Nombre de la computadora: $($systemInfo.Name)
		Fabricante del sistema: $($systemInfo.Manufacturer)
		Modelo del sistema: $($systemInfo.Model)
		Sistema operativo: $($osInfo.Caption) $($osInfo.Version)
		Procesador: $($processorInfo.Name)
		Memoria fisica total: $([math]::Round($memoryInfo.Capacity / 1GB, 2)) GB"
}

Function Get-NetInfo {
	# Mostrar informacion de red
	$networkAdapterInfo = Get-WmiObject -Class Win32_NetworkAdapterConfiguration | Where-Object { $_.IPAddress -ne $null }
	$networkAdapterSpeed = Get-WmiObject -Class Win32_NetworkAdapter | Where-Object { $_.NetConnectionStatus -eq 2 } | Select-Object -ExpandProperty Speed
	
	$ResultNetInfo = Write-Host "`nInformacion de red:`n
		Velocidad de la conexion: $([math]::Round($networkAdapterSpeed / 1MB, 2)) MB/s
		Direccion IP: $($networkAdapterInfo.IPAddress[0])
		Mascara de subred: $($networkAdapterInfo.IPSubnet[0])
		Puerta de enlace predeterminada: $($networkAdapterInfo.DefaultIPGateway[0])"
}

Function Get-MemInfo {
	# Mostrar informacion de memoria
	$memoryUsage = Get-WmiObject -Class Win32_OperatingSystem | Select-Object -ExpandProperty FreePhysicalMemory
	$totalMemory = Get-WmiObject -Class Win32_ComputerSystem | Select-Object -ExpandProperty TotalPhysicalMemory
	$memoryUsagePercentage = [math]::Round(($totalMemory - $memoryUsage) / $totalMemory * 100, 2)
	
	$ResultMemInfo = Write-Host "`nInformacion de memoria:`n
		Memoria fisica en uso: $([math]::Round($memoryUsage / 1GB, 2)) GB
		Porcentaje de uso de la memoria fisica: $memoryUsagePercentage%"
}

# Funcion para obtener la informacion del disco
Function Get-DiskInfo {
    $diskInfo = Get-WmiObject -Class Win32_LogicalDisk
    foreach ($disk in $diskInfo) {
            $diskSize = [math]::Round($disk.Size / 1GB, 2)
            $freeSpace = [math]::Round($disk.FreeSpace / 1GB, 2)
            $usedSpace = [math]::Round(($disk.Size - $disk.FreeSpace) / 1GB, 2)
    }
	
	# Mostrar informacion del disco
	$ResultDiskInfo = Write-Host "`nInformacion del disco:`n
	Tamano: $diskSize GB
	Espacio libre: $freeSpace GB
	Espacio usado: $usedSpace GB
	`nFin del monitoreo de recursos, puedes consultarlo en $logPath...`n"
}

# Funcion para mostrar la informacion
Function Show-Info {
	Write-Host $ResultSysInfo
	Write-Host $ResultNetInfo
	Write-Host $ResultMemInfo
	Write-Host $ResultDiskInfo
}

# Funcion para escribir en el archivo de registro
Function Write-LogFile {
	# Out-File -FilePath "C:\ruta\al\archivo.txt" -InputObject $resultado
    Add-Content $logPath $ResultSysInfo
    Add-Content $logPath $ResultNetInfo
	Add-Content $logPath $ResultMemInfo
    Add-Content $logPath $ResultDiskInfo
}

# Crear la carpeta si no existe
if (!(Test-Path $logFolder)) {
	Write-Host "El directorio $logFolder para los logs no existe"
    Write-Host "Creando directorio $logFolder..."
    New-Item -ItemType Directory -Path $logFolder | Out-Null
}

# Ejecucion de las siguientes funciones
Get-SysInfo
Get-NetInfo
Get-MemInfo
Get-DiskInfo
Show-Info
Write-LogFile