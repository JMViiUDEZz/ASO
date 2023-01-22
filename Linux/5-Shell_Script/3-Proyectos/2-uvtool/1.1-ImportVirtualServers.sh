#!/bin/bash

# Autor: José María Viúdez
# Descripcion: Realizar un conjunto de scripts con la finalidad de crear servidores virtuales con ubuntu, utilizando uvtool.
# Además, para automatizar aun más el proceso, se crearán archivos CSV para la importación y exportación de los mismos.

# Crear un servidor virtual
addVirtualServer() {
	echo "Crear servidor virtual $VIRTUAL_SERVER"
	if [ "`existVirtualServer $VIRTUAL_SERVER`" = "1" ]
	then
		echo "Servidor virtual $VIRTUAL_SERVER ya existe"
	else
		# Generar una clave ssh
		ssh-keygen
		# Crear servidor virtual
		uvt-kvm create $VIRTUAL_SERVER release=$OS --cpu $NUMBER_CPU --memory $SIZE_MEMORY --disk $SIZE_DISK --ssh-public-key-file /home/$USER/.ssh/id_rsa --password $PASSWD
		echo "Servidor virtual $VIRTUAL_SERVER ha sido creado correctamente"
	fi
}

# Verifica si un servidor virtual existe
existVirtualServer() {
	uvt-kvm list | awk -v virtualserver=$1 '{if($2==virtualserver) print "1"}'
}

# Bucle de todas las líneas del archivo a importar
for linea in $(cat $1)
do
    # Guardar en variables los diferentes campos del servidor virtual
	VIRTUAL_SERVER=$(grep "$linea" $1 | cut -d',' -f1)
	OS=$(grep "$linea" $1 | cut -d',' -f2)
	NUMBER_CPU=$(grep "$linea" $1 | cut -d',' -f3)
	SIZE_MEMORY=$(grep "$linea" $1 | cut -d',' -f4)
	SIZE_DISK=$(grep "$linea" $1 | cut -d',' -f5)
	PASSWD=$(grep "$linea" $1 | cut -d',' -f6)
	# Crear el servidor virtual
	addVirtualServer
done