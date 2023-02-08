#!/bin/bash

# Autor: José María Viúdez
# Descripcion: Script para monitorear los recursos del sistema
# creando un fichero log por cada vez que se ejecute el mismo.

# Llamar al archivo de configuracion environment.sh
. ./environment.sh

SystemInfo() {
    # Mostrar el nombre del sistema
    echo "Nombre del sistema: `hostname`">>$LOG
	# uname -n
	echo "">>$LOG
	
    # Mostrar el nombre del sistema operativo
    echo "Nombre del sistema operativo: `uname -o`">>$LOG
	echo "">>$LOG

    # Mostrar el nombre del kernel
    echo "Nombre del kernel: `uname -s`">>$LOG
    echo "">>$LOG
	
    # Mostrar la versión del kernel
    echo "Versión del kernel: `uname -r`">>$LOG
    echo "">>$LOG
	
	# Mostrar la arquitectura de la CPU
    echo "Arquitectura de la CPU: `uname -m`">>$LOG
    echo "">>$LOG
		
	# Mostrar el modelo de la CPU
	echo "Modelo de la CPU: `cat /proc/cpuinfo | grep "model name" | sort -u | awk -F ":" '{print $2}'`">>$LOG
	echo "">>$LOG
	
	# Obtener la carga de la CPU y mostrar un mensaje que indica si es una carga normal, peligrosa o muy peligrosa
    uptime | awk -F'load average:' '{ print $2 }' | cut -f1 -d, | awk '{if ($1 > 2) print "Carga de la CPU: " $1 " - Muy peligrosa"; else if ($1 > 1) print "Carga de la CPU: " $1 " - Peligrosa"; else print "Carga de la CPU: " $1 " - Normal"}'>>$LOG
    echo "">>$LOG	

	# Mostrar la distribución de Linux
	echo "Distribución de Linux: `lsb_release -s -d`">>$LOG
	echo "">>$LOG

	# Mostrar número de usuarios logeados
	echo "Número de usuarios logeados: `uptime | awk '{print $4}'`">>$LOG
    echo "">>$LOG

	# Mostrar usuarios logeados
	echo "Usuarios logeados: `whoami`">>$LOG
	echo "">>$LOG

	# Mostrar tiempo de actividad del sistema
    echo "Tiempo de actividad del sistema: `uptime | awk '{print $3,$4}' | cut -f1 -d,`">>$LOG
    echo "">>$LOG
	
	# Mostrar el número de archivos abiertos
	echo "Número de archivos abiertos: `lsof | wc -l`">>$LOG
	echo "``">>$LOG
}

Network_Monitor() {
	# Mostrar la lista de interfaces de red disponibles en el sistema 
	echo "Interfaces de red disponibles en el sistema:">>$LOG
	echo "`tcpdump -D | awk '{print $1}'`">>$LOG
	echo "">>$LOG
	
	# Mostrar IPs internas, externas y DNS
	echo "IP Interna: `hostname -I`">>$LOG
	echo "IP Externa: `curl -s ipecho.net/plain`">>$LOG
	echo "DNS: `cat /etc/resolv.conf | grep "nameserver" | awk '{print $2}'`">>$LOG
	echo "">>$LOG
	
	# Comprobar la conexión a Internet. 
	ping -c 1 google.com > /dev/null && echo "Internet: Conectado">>$LOG || echo -e "Internet: Desconectado">>$LOG
	echo "">>$LOG

	# Mostrar puertos abiertos tras realizar un escaneo.
	echo "Puertos abiertos:">>$LOG
	echo "`nmap localhost | grep "open" | awk '{print $1}' | cut -f1 -d/ | sort -n`">>$LOG
	echo "">>$LOG
}
Memory_Monitor() {
    # Obtener la memoria ram con el comando free.
	echo "RAM total: `free -h | grep 'Mem:' | awk '{print $2}'`">>$LOG
	echo "RAM usada: `free -h | grep 'Mem:' | awk '{print $3}'`">>$LOG
	echo "RAM libre: `free -h | grep 'Mem:' | awk '{print $4}'`">>$LOG
	echo "RAM usada como memoria caché: `cat /proc/meminfo | grep 'Cached:' | awk '{print $2,$3}'`">>$LOG
    echo "">>$LOG
	
	# Obtener el tamaño del espacio swap.
	echo "SWAP total: `cat /proc/meminfo | grep 'SwapTotal:' | awk '{print $2,$3}'`">>$LOG
	echo "SWAP libre: `cat /proc/meminfo | grep 'SwapFree:' | awk '{print $2,$3}'`">>$LOG
	echo "SWAP usada como memoria caché: `cat /proc/meminfo | grep 'SwapCached:' | awk '{print $2,$3}'`">>$LOG
	echo "">>$LOG

	
	# Mostrar el tamaño de la memoria caché
	echo "Tamaño de la memoria caché: `cat /proc/cpuinfo | grep "cache size" | sort -u | awk -F ":" '{print $2}'`">>$LOG
	echo "">>$LOG
}

Disk_Monitor() {
	# Mostrar uso Disco
	echo "Disco total montado en /: `df -h / | grep / | awk '{ print $2}'`">>$LOG
	echo "Disco usado montado en /: `df -h / | grep / | awk '{ print $3}'`">>$LOG
	echo "Disco libre montado en /: `df -h / | grep / | awk '{ print $4}'`">>$LOG  
	echo "Uso de disco montado en /: `df -h / | grep / | awk '{ print $5}'`">>$LOG
	echo "">>$LOG
}

clear

# Directorio del LOG
if ! [ -d $DIRLOG ]; then
    echo "El directorio $DIRLOG para los logs no existe"
    echo "Creando directorio $DIRLOG..."
    mkdir -p $DIRLOG
fi
 
echo "">>$LOG
echo "Información del sistema del día $DATE a las $TIME">>$LOG
echo "">>$LOG

SystemInfo
Network_Monitor
Memory_Monitor
Disk_Monitor

echo "Fin del monitoreo de recursos, puedes consultarlo en $LOG"
echo ""

