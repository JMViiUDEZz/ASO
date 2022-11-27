#!/bin/bash

# Autor: José María Viúdez
# Descripcion: Realizar un conjunto de scripts con la finalidad de poder importar y exportar usuarios 
# desde archivos CSV (valores separados por comas) a un directorio OpenLDAP y viceversa.


# Configuración
DOMAIN="asir.local"
# ADMIN="admin"
# PASS="jose"
# IP=192.168.1.100
# UIDFROM=10000
# GIDFROM=5000
# En este caso, las variables se han declarado en el propio script
# No obstante, podrían ser solicitadas  al inicio de la ejecución del mismo

# Obtener "dc=asir,dc=local" a partir del nombre del dominio, en mi caso es asir.local
getDc() {
	OIFS=$IFS
	IFS='.'
	AUX=''
	for parte in $1; do
		if [ "$AUX" != "" ]; then
			AUX="$AUX,"
		fi
		AUX="${AUX}dc=$parte"
	done
	IFS=$OIFS
	echo $AUX
}

# Fijar "dc=asir,dc=local"
DC=`getDc $DOMAIN`

# Obtener el nombre, los apellidos y el correo electrónico de los usuarios
getAllUsers() {
	ldapsearch -x -b "ou=usuarios,$DC" "(objectClass=Person)" uid gidNumber sn givenName
}

# Obtener el nombre del grupo a partir del GID
getGroupCn() {
	ldapsearch -x -b "gidNumber=$1,ou=grupos,$DC" "(objectclass=*)" | grep cn | awk '{printf $2}'
}

clear

# Comprobar si ya existe un archivo de exportación y eliminarlo en caso positivo
if [ -f usersExported.txt ]; then
    rm usersExported.txt
fi

# Bucle de todos los usuarios 
for linea in $(getAllUsers)
do
	# uid: $USUARIO
	# gidNumber: $GRUPO_ID
	# sn: $APELLIDO
	# givenName: $NOMBRE
	# GRUPO=`getGroupCn $GRUPO_ID`

    # Guardar el UID del usuario en una variable
    USUARIO=$(echo $linea | cut -d ": " -f 2)
    # Guardar el GID del grupo en una variable
    GRUPO_ID=$(echo $linea | cut -d ": " -f 2)
	# Guardar el apellido del usuario en una variable
    APELLIDO=$(echo $linea | cut -d ": " -f 2)
    # Guardar el nombre del usuario en una variable
    NOMBRE=$(echo $linea | cut -d ": " -f 2)
    # Guardar el nombre del grupo en una variable
	GRUPO=`getGroupCn $GRUPO_ID`

    # En caso positivo se guarda el nombre del usuario y el nombre del grupo en el archivo de exportacion
    echo "$USUARIO,$NOMBRE,$APELLIDO,$GRUPO" >> usersExported.txt
done

echo "Usuarios exportados correctamente a usersExported.txt"