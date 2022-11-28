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

clear

# Comprobar si ya existe un archivo de exportación y eliminarlo en caso positivo
if [ -f usersExported.txt ]; then
    rm usersExported.txt
fi

# Bucle de todos los UID de los usuarios
for linea in $(ldapsearch -x -b "ou=usuarios,$DC" "(objectClass=Person)" uid gidNumber sn givenName | grep uid: | cut -d ":" -f 2)
do
	# Guardar el UID del usuario en una variable
	USUARIO_ID=$(echo $linea)
	
	# Bucle de cada UID del usuario
	for USUARIO in $USUARIO_ID
	do
		# Guardar el nombre del usuario en una variable
		NOMBRE=$(ldapsearch -x -b "ou=usuarios,$DC" "(uid=$USUARIO)" givenName | grep givenName: | cut -d ":" -f 2 | tr -d " ")
		# Guardar el apellido del usuario en una variable
		APELLIDO=$(ldapsearch -x -b "ou=usuarios,$DC" "(uid=$USUARIO)" sn | grep sn: | cut -d ":" -f 2 | tr -d " ")
		# Guardar el GID del grupo en una variable
		GRUPO_ID=$(ldapsearch -x -b "ou=usuarios,$DC" "(uid=$USUARIO)" gidNumber | grep gidNumber: | cut -d ":" -f 2 | tr -d " ")
		# Guardar el nombre del grupo en una variable
		GRUPO=$(ldapsearch -x -b "ou=grupos,$DC" "(gidNumber=$GRUPO_ID)" cn | grep cn: | cut -d ":" -f 2 | tr -d " ")
		
		# En caso positivo se guarda el nombre del usuario y el nombre del grupo en el archivo de exportacion
		echo "$USUARIO,$NOMBRE,$APELLIDO,$GRUPO" >> usersExported.txt
	done
	echo "Usuarios exportados correctamente a usersExported.txt"
	break
done

