
# Autor: Jose Maria Viudez
# Descripcion: Script para monitorear los recursos del sistema
# creando un fichero log por cada vez que se ejecute el mismo.
# Este script debe ser ejecutado con permisos de administrador.
# En este caso, las variables se han declarado en el propio script

# Limpiar la pantalla al lanzar el menu
Clear-Host

# Establecer la ruta de la carpeta donde se guardarán los archivos de registro
$logFolder = "C:\Logs"

# Obtener la fecha y hora actual para el nombre del archivo de registro
$logDate = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
$Date = Get-Date -Format "yyyy-MM-dd"
$Time = Get-Date -Format "HH:mm:ss"

# Establecer la ruta del archivo de registro
$logPath = "$logFolder\SystemResources_$logDate.log"

# Obtener resumen del monitoreo de recursos 
Function Get-SumSysRes {
	$cpu = Get-Counter '\Processor(_Total)\% Processor Time'
	$memory = Get-Counter '\Memory\Available MBytes'
	$disk = Get-Counter '\LogicalDisk(_Total)\% Free Space'

	# Formatear la información
	$cpuUsage = "{0:N2}" -f ($cpu.CounterSamples[0].CookedValue / $cpu.CounterSamples[0].BaseValue * 100)
	$memoryAvailable = "{0:N2}" -f $memory.CounterSamples[0].CookedValue
	$diskFreeSpace = "{0:N2}" -f $disk.CounterSamples[0].CookedValue
		
	$Result-SumSysRes = (
		# Mostrar resumen del monitoreo de recursos 
		Write-Host "Inicio del monitoreo de recursos del día $Date a las $Time:"
		Write-Host ""
		Write-Host "Resumen:"
		Write-Host ""
		Write-Host "CPU Usage: $cpuUsage"
		Write-Host "Memory Available: $memoryAvailable"
		Write-Host "Memory Free Space: $diskFreeSpace"
		Write-Host ""
	) | Out-String

}

# Función para obtener el uso de la CPU
Function Get-CpuUsage {
    $cpu = Get-WmiObject -Class Win32_Processor
    $prevIdleTime = $prevKernelTime = $prevUserTime = 0
    $idleTime = $kernelTime = $userTime = $totalTime = 0
    
    # Obtener la información de la CPU
    foreach ($proc in $cpu) {
        $idleTime += $proc.GetPropertyValue("IdleTime").toUInt64()
        $kernelTime += $proc.GetPropertyValue("KernelModeTime").toUInt64()
        $userTime += $proc.GetPropertyValue("UserModeTime").toUInt64()
    }
    
    # Calcular el tiempo total de la CPU
    $totalTime = $kernelTime + $userTime
    $idleTime = $totalTime - $idleTime
    
    # Calcular el porcentaje de uso de la CPU
    $cpuUsage = (($totalTime - $prevTotalTime) - ($idleTime - $prevIdleTime)) / ($totalTime - $prevTotalTime) * 100
    
    # Almacenar los valores previos
    $prevTotalTime = $totalTime
    $prevIdleTime = $idleTime
    
    # Retornar el porcentaje de uso de la CPU
    # return $cpuUsage
	
	$Result-CpuUsage = (
		Write-Host "CPU Usage: $cpuUsage`%"
		Write-Host ""
	) | Out-String
}

# Función para obtener el uso de la memoria
Function Get-MemoryUsage {
    $memoryUsage = Get-Counter "\Memory\Available MBytes"
    
    # Retornar el valor de memoria disponible
    # return $memoryUsage.CounterSamples[0].CookedValue
	
	$Result-MemoryUsage = (
		Write-Host "Memory Usage: $memoryUsage.CounterSamples[0].CookedValue`MB"
		Write-Host ""
	) | Out-String
}

# Función para obtener el uso del disco
Function Get-DiskUsage {
    $disks = Get-WmiObject -Class Win32_LogicalDisk -Filter "DriveType=3"
    $diskUsage = @()
    
    # Obtener el uso de cada disco
    foreach ($disk in $disks) {
        $freeSpace = [Math]::Round($disk.FreeSpace / 1GB, 2)
        $totalSpace = [Math]::Round($disk.Size / 1GB, 2)
        $usedSpace = $totalSpace - $freeSpace
        $percentUsed = [Math]::Round($usedSpace / $totalSpace * 100, 2)
        $diskUsage += @{
            "DriveLetter" = $disk.DeviceID
            "TotalSpace" = $totalSpace
            "FreeSpace" = $freeSpace
            "UsedSpace" = $usedSpace
            "PercentUsed" = $percentUsed
        }
    }
    
    # Retornar el uso de los discos
    # return $diskUsage
	
	$Result-DiskUsage = (
		Write-Host "Disk Usage:"
		$diskUsage | Format-Table -AutoSize
		Write-Host ""
	) | Out-String
}

Function Get-SysInfo {
	# Obtener información del sistema
	$systemInfo = Get-WmiObject -Class Win32_ComputerSystem
	$osInfo = Get-WmiObject -Class Win32_OperatingSystem
	$processorInfo = Get-WmiObject -Class Win32_Processor
	$memoryInfo = Get-WmiObject -Class Win32_PhysicalMemory
	$diskInfo = Get-WmiObject -Class Win32_LogicalDisk
	
	# Mostrar información del sistema
	$Result-SysInfo = (
		Write-Host "Información del sistema:"
		Write-Host ""
		Write-Host "Nombre de la computadora: $($systemInfo.Name)"
		Write-Host "Fabricante del sistema: $($systemInfo.Manufacturer)"
		Write-Host "Modelo del sistema: $($systemInfo.Model)"
		Write-Host "Sistema operativo: $($osInfo.Caption) $($osInfo.Version)"
		Write-Host "Procesador: $($processorInfo.Name)"
		Write-Host "Memoria física total: $([math]::Round($memoryInfo.Capacity / 1GB, 2)) GB"
		Write-Host ""
	) | Out-String

}

Function Get-NetInfo {
	# Mostrar información de red
	$networkAdapterInfo = Get-WmiObject -Class Win32_NetworkAdapterConfiguration | Where-Object { $_.IPAddress -ne $null }
	$networkAdapterSpeed = Get-WmiObject -Class Win32_NetworkAdapter | Where-Object { $_.NetConnectionStatus -eq 2 } | Select-Object -ExpandProperty Speed
	
	$Result-NetInfo = (
		Write-Host "Información de red:"
		Write-Host ""
		Write-Host "Velocidad de la conexión: $([math]::Round($networkAdapterSpeed / 1MB, 2)) MB/s"
		Write-Host "Dirección IP: $($networkAdapterInfo.IPAddress[0])"
		Write-Host "Máscara de subred: $($networkAdapterInfo.IPSubnet[0])"
		Write-Host "Puerta de enlace predeterminada: $($networkAdapterInfo.DefaultIPGateway[0])"
		Write-Host ""	
	) | Out-String
}

Function Get-MemInfo {
	# Mostrar información de memoria
	$memoryUsage = Get-WmiObject -Class Win32_OperatingSystem | Select-Object -ExpandProperty FreePhysicalMemory
	$totalMemory = Get-WmiObject -Class Win32_ComputerSystem | Select-Object -ExpandProperty TotalPhysicalMemory
	$memoryUsagePercentage = [math]::Round(($totalMemory - $memoryUsage) / $totalMemory * 100, 2)
	
	$Result-MemInfo = (
		Write-Host "Información de memoria:"
		Write-Host ""
		Write-Host "Memoria física en uso: $([math]::Round($memoryUsage / 1GB, 2)) GB"
		Write-Host "Porcentaje de uso de la memoria física: $memoryUsagePercentage%"
		Write-Host ""
	) | Out-String
}

# Función para obtener la información del disco
Function Get-DiskInfo {
    $diskInfo = Get-WmiObject -Class Win32_LogicalDisk
    foreach ($disk in $diskInfo) {
            $diskSize = [math]::Round($disk.Size / 1GB, 2)
            $freeSpace = [math]::Round($disk.FreeSpace / 1GB, 2)
            $usedSpace = [math]::Round(($disk.Size - $disk.FreeSpace) / 1GB, 2)
    }
	
	# Mostrar información del disco
	$Result-DiskInfo = (
		Write-Host "Información del disco:"
		Write-Host ""
		Write-Host "Tamaño: $diskSize GB"
		Write-Host "Espacio libre: $freeSpace GB"
		Write-Host "Espacio usado: $usedSpace GB"
		Write-Host ""
		Write-Host "Fin del monitoreo de recursos, puedes consultarlo en $logPath..."
		Write-Host ""
	) | Out-String
}

# Función para mostrar la información
Function Show-Info {
	Write-Host $Result-SumSysRes
	Write-Host $Result-CpuUsage
	Write-Host $Result-DiskUsage
	Write-Host $Result-SysInfo
	Write-Host $Result-NetInfo
	Write-Host $Result-MemInfo
	Write-Host $Result-DiskInfo
}

# Función para escribir en el archivo de registro
Function Write-LogFile {
	# Out-File -FilePath "C:\ruta\al\archivo.txt" -InputObject $resultado
    Add-Content $logPath $Result-SumSysRes
	Add-Content $logPath $Result-CpuUsage
    Add-Content $logPath $Result-DiskUsage
    Add-Content $logPath $Result-SysInfo
    Add-Content $logPath $Result-NetInfo
	Add-Content $logPath $Result-MemInfo
    Add-Content $logPath $Result-DiskInfo
}

# Crear la carpeta si no existe
if (!(Test-Path $logFolder)) {
	Write-Host "El directorio $logFolder para los logs no existe"
    Write-Host "Creando directorio $logFolder..."
    New-Item -ItemType Directory -Path $logFolder | Out-Null
}

# Ejecucion de las siguientes funciones
Get-SumSysRes
Get-CpuUsage
Get-DiskUsage
Get-SysInfo
Get-NetInfo
Get-MemInfo
Get-DiskInfo
Show-Info
Write-LogFile