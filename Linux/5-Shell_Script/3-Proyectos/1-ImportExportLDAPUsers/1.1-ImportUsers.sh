#!/bin/bash

# Autor: José María Viúdez
# Descripcion: Realizar un conjunto de scripts con la finalidad de poder importar y exportar usuarios 
# desde archivos CSV (valores separados por comas) a un directorio OpenLDAP y viceversa.

# Llamar al archivo de configuracion LDAP.conf
. ./LDAP.conf

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

# Crear un grupo
addGroup() {
	echo "Crear grupo $1"
	# Obtener siguiente id
	GRUPO_ID=`getNextGid`
	# Crear grupo
	echo " " >> groupsImported.ldif
	echo "dn: cn=$1,ou=grupos,$DC
objectClass: posixGroup
cn: $1
gidNumber: $GRUPO_ID" >> groupsImported.ldif
	ldapadd -v -D cn=$ADMIN,$DC -w $PASS << EOF
	dn: cn=$1,ou=grupos,$DC
	objectClass: posixGroup
	cn: $1
	gidNumber: $GRUPO_ID
EOF
	echo "Grupo $1 ha sido creado correctamente"
}

# Crear un usuario
addUser() {
	echo "Crear usuario $USUARIO"
	if [ "`existUser $USUARIO`" = "1" ]
	then
		echo "Usuario $USUARIO ya existe"
	else
		USUARIO_ID=`getNextUid`
		GRUPO_ID=`getGroupId $GRUPO`
		if [ "`existGroup $GRUPO_ID`" = "1" ]
		then
			echo "Grupo $GRUPO ya existe"
		else
			addGroup $GRUPO
		fi
		# Crear usuario
		echo " " >> usersImported.ldif
		echo "dn: uid=$USUARIO,ou=usuarios,$DC
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
mail: $USUARIO@$DOMAIN" >> usersImported.ldif
		ldapadd -v -D cn=$ADMIN,$DC -w $PASS  << EOF
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
		echo "Usuario $USUARIO ha sido creado correctamente"
	fi
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
done