###################################
######-----Ejercicio 1-----########
###################################
#1. Realiza la instalación de Ubuntu Server sobre una máquina virtual con 2GB de memoria y 20GB de disco duro.

#2. El nombre del servidor será u-server.
#	1) Cambiar el nombre del servidor:
sudo hostnamectl set-hostname u-server
sudo echo u-server > /etc/hostname
#	2) Modificar el fichero cloud.cfg para no perder el nombre al reiniciar:
sudo echo 'preserve_hostname: true' > /etc/cloud/cloud.cfg
#	3) Modificar el fichero de hosts:
sudo echo '127.0.1.1 u-server' >> /etc/hosts

#3. Instala, de forma manual, todas las actualizaciones pendientes del sistema.
#	1) Actualizar índice de paquetes:
sudo apt update -y
#	2) Actualizar los paquetes instalados:
sudo apt upgrade -y
#	3) Actualizar automáticamente paquetes críticos:
sudo dpkg-reconfigure -plow unattended-upgrades

#4. Configura el servidor con la dirección IP fija 192.168.1.100/24 para la conexión con la red local.
#5. Configura el servidor con una dirección IP obtenida por DHCP para la conexión a Internet.
#	Puerta de enlace temporal:
sudo echo '# Ejemplo de configuración
network:
  ethernets:
    eth0:
      dhcp4: true
    eth1:
      addresses: [192.168.1.100/24]
      dhcp4: no
  version: 2' > /etc/netplan/00-installer-config.yaml
#	Aplicar cambios con la orden:
sudo netplan apply

#6. Configura el protocolo de sincronización de la fecha y hora.
#	1) Establecer la zona horaria
sudo timedatectl set-timezone Europe/Madrid
#	2) Activamos sincronización NTP 
sudo timedatectl set-ntp on

#7. Realiza los ajustes adecuados para administrar el servidor desde un ordenador remoto.
#	Instalación:
sudo apt install openssh-client
sudo apt install openssh-server
#	Configuración:
sudo echo 'Port 22
AllowUsers jose
PermitRootLogin no
Banner /etc/issue.net' > /etc/ssh/sshd_config
sudo systemctl restart ssh


###################################
######-----Ejercicio 2-----########
###################################
#1. Crea los grupos profesores y alumnos.
#	Crear un grupo:
sudo addgroup profesores
sudo addgroup alumnos

#2. Crea los usuarios paula y pablo pertenecientes al grupo de profesores.
#	Crear usuarios:
sudo adduser paula --ingroup profesores
#sudo adduser pablo --ingroup profesores
#	Asignar un usuario a un grupo:
sudo adduser pablo profesores
#sudo adduser paula profesores

#3. Crea los usuarios ana y alberto pertenecientes al grupo de alumnos.
#	Crear usuarios:
sudo adduser ana --ingroup alumnos
#sudo adduser alberto --ingroup alumnos
#	Asignar un usuario a un grupo:
sudo adduser alberto alumnos
#sudo adduser ana alumnos

#4. En srv crea la carpeta profesores para compartir documentos. Solo los profesores podrán acceder y modificar el contenido de este directorio.
cd /srv
mkdir profesores
chmod 770 profesores

#5. En srv crea la carpeta alumnos para compartir documentos. Además de los alumnos, los profesores también podrán acceder pero solo con permiso de lectura.
cd /srv
mkdir alumnos
chmod 775 alumnos


###################################
######-----Ejercicio 3-----########
###################################
#1. Añade un nuevo disco duro a nuestro servidor para realizar copias de seguridad.
#	1) Obtener información y localizar el nuevo disco duro:
lshw -C disk
#	2) Inicializar y particionar:
fdisk /dev/sdb
#		n (add a new partition)
#		p (primary)
#		1 (partition number)
#		w (write changes)
#	3) Formatear la partición:
mkfs -t ext4 /dev/sdb1
#	4) Crear el punto de montaje y montar la nueva partición:
mkdir /mnt/backup
mount /dev/sdb1 /mnt/backup
#	5) Averiguar UUID:
blkid
#	6) Configurar el sistema para montar el volumen al inicio:
sudo nano /etc/fstab
#		Añadimos la línea usando el UUID obtenido
#		UUID=n...n /mnt/backup ext4 defaults 0 2

#2. Realiza una copia de seguridad completa de los directorios alumnos y profesores.
#	1) Crear el script backup.sh:
cd /usr/local/bin
sudo echo '#!/bin/bash

# Directorio a salvar y destino. 
orig1="/srv/alumnos"
orig2="/srv/profesores"
dest="/mnt/backup"

# Nombre del fichero.
dia=$(date +%A)
fichero1="Copia-alumnos-$dia.tgz"
fichero2="Copia-profesores-$dia.tgz"

# Realizamos la copia de seguridad.
echo "Realizando backup de $orig en $dest/$fichero"
tar czf $dest/$fichero1 $orig1
tar czf $dest/$fichero2 $orig2

echo "Copia finalizada"

# Listamos los ficheros en $dest y comprobamos
# el tamaño de los ficheros.
ls -lh $dest' > ./backup.sh
#	2) Dar permisos de ejecución:
chmod u+x backup.sh
#	3) Ejecutar el script:
sudo ./backup.sh
#	4) Programar el scripts:
#sudo crontab -e
#		Añadir la línea:
#0 0 * * * bash /usr/local/bin/backup.sh

#3. Programa las copias de seguridad para que se realice una copia incremental diariamente.
#	Instalación Duplicity:
sudo apt install duplicity -y
#	Crear una copia. En la primera ejecución se realizará una copia completa, el resto serán incrementales:
duplicity /datos/ file:///copia/
#	Forzar una copia completa:
#duplicity full /datos/ file:///copia/
#	Lista el contenido de los backup:
duplicity list-current-files file:///copia/
#	Registros de todos los backup realizados:
#duplicity collection-status file:///copia/
#	Recuperación de ficheros:
#duplicity restore file:///copia/ /datos/
#		Notas:  
#		Se puede sustituir file por otros protocolos como ssh o ftp para hacer las copias en un servidor externo.


###################################################
######-----Caso Practico con Duplicity-----########
###################################################
#1. Realiza una copia de seguridad completa de los directorios alumnos y profesores en un servidor externo utilizando el protocolo ftp.
#2. Automatiza la copia de seguridad para que se ejecute todos los días a las 12:00h

#############################################################
######-----Caso Practico con Duplicity(Solucion)-----########
#############################################################
#	1) Instalamos los paquetes necesarios:
sudo apt install duplicity ncftp -y
#	2)Creamos el fichero y asignamos permisos:
cd /usr/local/bin
sudo chmod 700 backup.sh
#	3)Contenido del fichero:
sudo echo 'export PASSPHRASE=Cadena-de-cifrado
export FTP_PASSWORD=Clave-del-servidor-FTP
duplicity /srv/alumnos ftp://usuarioFtp@ftp.dominio.com/backup/alum
unset PASSPHRASE
unset FTP_PASSWORD' > ./backup.sh
#	4) Automatizar añadiendo en el root crontab:
#		Crear una tarea programada:
sudo crontab -e
#0 0 * * * /root/scripts/backup.sh >>/var/log/duplicity/alum.log