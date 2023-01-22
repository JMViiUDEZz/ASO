#!/bin/bash

# Autor: José María Viúdez
# Descripcion: Realizar un conjunto de scripts con la finalidad de crear servidores virtuales con ubuntu, utilizando uvtool.
# Además, para automatizar aun más el proceso, se crearán archivos CSV para la importación y exportación de los mismos.

# Limpiar la pantalla al lanzar el menú
clear

# Verifica si un servidor virtual existe
existVirtualServer() {
	uvt-kvm list | awk -v virtualserver=$1 '{if($2==virtualserver) print "1"}'
}

# Función que muestra las opciones del menú
getOptions() {
	echo "1) Obtener una imagen de la nube"
	echo "2) Obtener la lista de servidores virtuales en ejecución"
    echo "3) Crear un servidor virtual"
	echo "4) Conectarse a un servidor virtual en ejecución"
	echo "5) Averiguar la IP de un servidor virtual"
	echo "6) Destruir un servidor virtual"
    echo "7) Importar servidores virtuales"
    echo "8) Salir"
}

# Ejecución de la funcion para que muestre las opciones del menú
getOptions

# Leer la opción introducida por el usuario
read -p "Introduce una opción: " option

# Bucle de permanecer en el menú hasta que el usuario introduzca la opción 3
while [ ${option} != 8 ]
do
clear
	# Comprobar que ha introducido el usuario
	case ${option} in
		1)
			# Si el usuario introduce la opción 1 le pedimos que introduzca la imagen	
			read -p "Introduce la imagen que desea obtener: " OS
			uvt-simplestreams-libvirt sync release=$OS arch=amd64
			break
		;;
		2)
			# Si el usuario introduce la opción 2 se listarán los servidores virtuales en ejecución
			uvt-kvm list
			sleep 3
			break
		;;
		3)
			# Si el usuario introduce la opción 3 le pedimos que introduzca el nombre y otras características del servidor virtual	
			read -p "Introduce el nombre del servidor virtual: " VIRTUAL_SERVER	
			read -p "Introduce el nombre de la imagen: " OS			
			read -p "Introduce el número de nucleos de la CPU: " NUMBER_CPU			
			read -p "Introduce el tamaño de la memoria RAM: " SIZE_MEMORY			
			read -p "Introduce el tamaño del disco: " SIZE_DISK			
			read -p "Introduce la contraseña del usuario: " PASSWD			
			if [ "`existVirtualServer $VIRTUAL_SERVER`" = "1" ]
			then
				echo "Servidor virtual $VIRTUAL_SERVER ya existe, vuelve a introducirlo"
			else
				# Generar una clave ssh
				ssh-keygen
				# Crear servidor virtual
				uvt-kvm create $VIRTUAL_SERVER release=$OS --cpu $NUMBER_CPU --memory $SIZE_MEMORY --disk $SIZE_DISK --ssh-public-key-file /home/$USER/.ssh/id_rsa --password $PASSWD
				uvt-kvm wait $VIRTUAL_SERVER
				echo "Servidor virtual $VIRTUAL_SERVER ha sido creado correctamente"
				break
			fi
		;;
		4)
			# Si el usuario introduce la opción 4 le pedimos que introduzca el nombre del servidor virtual
			read -p "Introduce el nombre del servidor virtual: " VIRTUAL_SERVER	
			uvt-kvm ssh $VIRTUAL_SERVER
			break
		;;
		5)
			# Si el usuario introduce la opción 5 le pedimos que introduzca el nombre del servidor virtual
			read -p "Introduce el nombre del servidor virtual: " VIRTUAL_SERVER	
			uvt-kvm ip $VIRTUAL_SERVER
			break
		;;
		6)
			# Si el usuario introduce la opción 6 le pedimos que introduzca el nombre del servidor virtual
			read -p "Introduce el nombre del servidor virtual que desea destruir: " VIRTUAL_SERVER			
			if [ "`existVirtualServer $VIRTUAL_SERVER`" = "1" ]
			then
				# Destruir servidor virtual
				uvt-kvm destroy $VIRTUAL_SERVER
				echo "Servidor virtual $VIRTUAL_SERVER ha sido destruido correctamente"
				break
			else		
				echo "Servidor virtual $VIRTUAL_SERVER no existe, vuelve a introducirlo"
			fi
		;;
		7)
			# Si el usuario introduce la opción 7 le pedimos que introduzca un archivo de importación
			read -p "Introduce un archivo de importacion de servidores virtuales: " ImportFile
			# Comprobaremos que el archivo de importación introducido existe			
			if [ -f $ImportFile ]; then
				sh 1.1-ImportVirtualServers.sh $ImportFile
				break
			else
				echo "El archivo de importacion no existe, vuelve a introducirlo"
				sleep 3
			fi
		;;
		*)
			# En caso de q el usuario introduzca una opción no válida, se mostrará lo siguiente
			echo "Opción no válida"
			break
		;;
	esac
done
