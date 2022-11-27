#!/bin/bash

# Autor: José María Viúdez
# Descripcion: Realizar un conjunto de scripts con la finalidad de poder importar y exportar usuarios 
# desde archivos CSV (valores separados por comas) a un directorio OpenLDAP y viceversa.

# Configuración
DOMAIN="asir.local"
ADMIN="admin"
PASS="jose"
# IP=192.168.1.100
UIDFROM=10000
GIDFROM=5000
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

# Fijar argumentos que se pasarán a partir de el nombre de la cuenta del administrador y la contraseña
if [ "$PASS" = "" ]; then
	ARGS="-v -D cn=$ADMIN,$DC -W"
else
	ARGS="-v -D cn=$ADMIN,$DC -w $PASS"
fi

# Crear un grupo
addGroup() {
	clear;echo "Crear un grupo"
	# Obtener siguiente id
	GRUPO_ID=`getNextGid`
	# Crear grupo
	ldapadd $ARGS << EOF
	dn: cn=$1,ou=grupos,$DC
	objectClass: posixGroup
	cn: $1
	gidNumber: $GRUPO_ID
EOF
}

# Crear un usuario
addUser() {
	clear;echo "Crear un usuario"
	
	if [ "`existUser $USUARIO`" = "1" ]
	then
		echo "Usuario $USUARIO ya existe"
	fi
	
	GRUPO_ID=`getGroupId $GRUPO`
	if [ "`existGroup $GRUPO_ID`" = "1" ]
	then
		echo "Grupo $GRUPO ya existe"
	else
		addGroup $GRUPO
		echo "Grupo $GRUPO ha sido creado correctamente"
	fi
	USUARIO_ID=`getNextUid`
	
	# Crear usuario
	ldapadd $ARGS << EOF
	dn: uid=$USUARIO,ou=usuarios,$DC
	objectClass: posixAccount
	objectClass: inetOrgPerson
	objectClass: organizationalPerson
	objectClass: person
	loginShell: /bin/bash
	homeDirectory: /home/$USUARIO
	uid: $USUARIO
	cn: $NOMBRE $APELLIDO
	uidNumber: $USUARIO_ID
	gidNumber: $GRUPO_ID
	sn: $APELLIDO
	givenName: $NOMBRE
	mail: $USUARIO@$DOMAIN
EOF
}

# Verifica si un usuario existe
existUser() {
	ldapsearch -x -b "ou=usuarios,$DC" "(objectclass=*)" | grep ^uid: | awk -v usuario=$1 '{if($2==usuario) print "1"}'
}

# Verifica si un grupo existe
existGroup() {
	ldapsearch -x -b "ou=grupos,$DC" "(objectclass=*)" | grep ^gidNumber: | awk -v grupo=$1 '{if($2==grupo) print "1"}'
}

# Obtener próximo UID libre
getNextUid() {
	LASTUID=`ldapsearch -x -b "ou=usuarios,$DC" "(objectclass=*)" | grep uidNumber | awk '{print $2}' | sort -r | head -1`
	if [ "$LASTUID" = "" ]; then
		echo $UIDFROM
	else
		echo $(($LASTUID+1))
	fi
}

# Obtener próximo GID libre
getNextGid() {
	LASTGID=`ldapsearch -x -b "ou=grupos,$DC" "(objectclass=*)" | grep gidNumber | awk '{print $2}' | sort -r | head -1`
	if [ "$LASTGID" = "" ]; then
		echo $GIDFROM
	else
		echo $(($LASTGID+1))
	fi
}

# Obtener GID a partir del nombre del grupo
getGroupId() {
	ldapsearch -x -b "cn=$1,ou=grupos,$DC" "(objectclass=*)" | grep gidNumber | awk '{printf $2}'
}

clear

if [ -f $1 ]
then

    # Bucle de todas las líneas del archivo a importar
    for linea in $(cat $1)
    do
        # Guardar en variables los diferentes campos del usuario
		USUARIO=$(grep "$linea" $1 | cut -d',' -f1)
		NOMBRE=$(grep "$linea" $1 | cut -d',' -f2)
		APELLIDO=$(grep "$linea" $1 | cut -d',' -f3)
		GRUPO=$(grep "$linea" $1 | cut -d',' -f4)
        
		# Crear el usuario
		addUser
		
		# Comprobar si el usuario ha sido creado correctamente
		if [ "`existUser $USUARIO`" = "1" ]
		then
			echo "Usuario $USUARIO ha sido creado correctamente"
		fi
		
        # Añadir el usuario al log de usuarios creados con sus contraseñas
        echo "Usuario: ${NOMBRE} --- Clave: ${CLAVE}" >> ~/usuarios.log
		
    done
else
    echo "el archivo introducido no existe."
fi