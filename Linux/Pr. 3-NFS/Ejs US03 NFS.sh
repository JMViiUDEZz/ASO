####################################
######-----Ejercicios-----##########
####################################
#1. Instala en una máquina virtual con el sistema operativo de escritorio Lubuntu. (Requisitos mínimos Lubuntu 20.04 Procesador de 1 GHz, 512MB de RAM y 5GB de disco duro) 

#2. Configura la máquina para pertenecer a la red 192.168.1.0/24 y comprueba que tienes conectividad con el servidor 192.168.1.100
#	En mi caso, la he configurado en modo gráfico.
#	Para tener conectividad con el servidor, este tiene que estar encendido.
ping 192.168.1.100

#3. Utilizando el sistema NFS comparte los directorios alumnos para lectura/escritura y profesores sólo para lectura con una máquina cliente con Lubuntu.
#NFS permite a un sistema compartir directorios y archivos con otros sistemas a través de la red.

#*Configuración del servidor*
#	Instalación:
sudo apt install nfs-kernel-server -y
sudo reboot
#Crear carpetas compartidas en el servidor y establecer los permisos:
sudo mkdir /srv/alumnos
sudo chown nobody:nogroup /srv/alumnos
sudo chmod -R 777 /srv/alumnos
#	Indicando los directorios a exportar.
sudo echo '/srv/alumnos 192.168.1.100/24(rw,sync,no_root_squash)
/srv/profesores 192.168.1.100/24(ro,sync,no_root_squash)' > /etc/exports
#		Nota: Se puede reemplazar * con nombres DNS concretos de máquina. (no dejar espacios entre * y las opciones).
#	Reiniciar el servicio:
sudo service nfs-kernel-server restart

#*Configuración de los clientes (Manual)*#
#	Instalar el paquete nfs-common:
sudo apt install nfs-common
#	Crear los puntos de montaje en los clientes:
sudo mkdir /mnt/alumnos
sudo mkdir /mnt/profesores
sudo chmod -R 777 /mnt/alumnos
sudo chmod -R 777 /mnt/profesores
#	Montando los directorios NFS.
sudo mount -t nfs4 u-server:/srv/alumnos /mnt/alumnos
sudo mount -t nfs4 u-server:/srv/profesores /mnt/profesores

#*Configuración de los clientes (Automática)*#
#	Una forma alternativa de montar un recurso compartido desde otra máquina es añadiendo una línea en el archivo fstab:
sudo echo 'u-server:/srv/alumnos  /mnt/alumnos  nfs4  auto  0  0
u-server:/srv/profesores  /mnt/profesores  nfs4  auto  0  0' > /etc/fstab
#	Comprobación:
df -h