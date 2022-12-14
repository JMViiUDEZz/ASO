#!/bin/bash

# Autor: José María Viúdez
# Descripcion: Script para administrar directorio OpenLDAP

# Configuración
DOMAIN="asir.local"
ADMIN="admin"
PASS="jose"
IP=192.168.1.100
UIDFROM=10000
GIDFROM=5000
PASSWORD_EXP="(?=^.{8,}$)(?=^[^\s]*$)(?=.*\d)(?=.*[A-Z])(?=.*[a-z])"
PASSWORD_MSG="al menos 8 caracteres que tengan 1 mayúscula, 1 minúscula y 1 número"
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

# Obtener los datos del árbol completo de directorio
getAll() {
	clear;echo "Obtener los datos del árbol completo de directorio"
	read -p "¿Es usted un Cliente? [y/n]: " CLIENTE
	if [ "$CLIENTE" = "y" ]; then
		ldapsearch -x -H ldap://$IP -b "$DC" "(objectclass=*)" | less
	else
		ldapsearch -x -b "$DC" "(objectclass=*)" | less
	fi
}

# Obtener el nombre, los apellidos y el correo electrónico de los usuarios
getAllUsers() {
	clear;echo "Obtener el nombre, los apellidos y el correo electrónico de los usuarios"
	read -p "¿Es usted un Cliente? [y/n]: " CLIENTE
	if [ "$CLIENTE" = "y" ]; then
		ldapsearch -x -H ldap://$IP -b "$DC" "(objectClass=Person)" dn cn mail | less
	else
		ldapsearch -x -b "$DC" "(objectClass=Person)" dn cn mail | less
	fi
}

# Obtener el nombre, los apellidos y el correo electrónico de un usuario, si existe
getUser() {
	clear;echo "Obtener el nombre, los apellidos y el correo electrónico de un usuario, si existe"
	read -p "Usuario: " USUARIO
	read -p "¿Es usted un Cliente? [y/n]: " CLIENTE
	if [ "`existUser $USUARIO`" != "1" ]; then
		echo "El usuario $USUARIO no existe"
	else
		echo "Búsqueda de Datos del Usuario:" $USUARIO
		if [ "$CLIENTE" = "y" ]; then
			ldapsearch -x -H ldap://$IP -b "$DC" "(&(objectClass=Person)(uid=$USUARIO))" dn cn mail | less
		else
			ldapsearch -x -b "$DC" "(&(objectClass=Person)(uid=$USUARIO))" dn cn mail | less
		fi
	fi
}

# Crear una unidad organizativa
addOu() {
	clear;echo "Crear una unidad organizativa"
	ldapadd $ARGS << EOF
	dn: ou=$1,$DC
	objectclass: organizationalUnit
	ou: $1
EOF
}

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

# Eliminar un grupo
delGroup() {
	clear;echo "Eliminar un grupo"
	ldapdelete $ARGS "cn=$1,ou=grupos,$DC"
}

# Crear un usuario
addUser() {
	clear;echo "Crear un usuario"
	# Solicitar usuario sabiendo que si existe, se pide otro. Por ello, este no se puede enviar por parametro ($1)
	read -p "Usuario: " USUARIO
	while [ "`existUser $USUARIO`" = "1" ]; do
		read -p "Usuario $USUARIO ya existe, ingrese nuevo: " USUARIO
	done
	# Solicitar otros campos del usuario
	read -p "Nombre: " NOMBRE
	read -p "Apellido: " APELLIDO
	read -p "Grupo principal (`getAllGroups`): " GRUPO
	GRUPO_ID=`getGroupId $GRUPO`
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
	userPassword: {CRYPT}*
	sn: $APELLIDO
	givenName: $NOMBRE
	mail: $USUARIO@$DOMAIN
EOF
	# Asignar clave al usuario
	modPasswd $USUARIO
}

# Eliminar un usuario
delUser() {
	clear;echo "Eliminar un usuario"
	ldapdelete $ARGS "uid=$1,ou=usuarios,$DC"
}

# Generar clave
genModPasswd() {
	local l=$1
       	[ "$l" == "" ] && l=20
      	tr -dc A-Za-z0-9_ < /dev/urandom | head -c ${l} | xargs 
}

# Cambiar clave a un usuario
modPasswd() {
	clear;echo "Cambiar clave a un usuario"
	# Si el usuario no existe, mostrará un mensaje de ERROR
	if [ "$1" = "" ]; then
		echo "[ERROR] - El usuario $1 no existe"
		exit 1
	fi
	# Solicitar confirmación para cambiar la clave del usuario que se muestra
	read -p "¿Cambiar clave al usuario $1? [y/n]: " OK
	if [ "$OK" = "y" ]; then
		# Repetir hasta tener una clave válida
		while true; do
			# Solicitar clave hasta tener una válida
			getModPasswd
			# Verificar clave sabiendo que si no es válida, se vuelve a pedir
			checkModPasswd $PASSWORD
			# Si la clave es válida, se rompe el bucle
			if [ $PASSWORD_OK -eq 0 ]; then
				break
			fi
		done
		# Cambiar clave
		ldappasswd $ARGS "uid=$1,ou=usuarios,$DC" -s "$PASSWORD"
	fi
}

# Solicitar clave al usuario (2 veces)
getModPasswd() {
	echo -n "Ingresar clave con ($PASSWORD_MSG): "
	stty -echo; read PASSWORD1; stty echo; echo ""
	echo -n "Repetir clave: "
	stty -echo; read PASSWORD2; stty echo; echo ""
	# Si las claves son diferentes, se piden de nuevo
	if [ "$PASSWORD1" != "$PASSWORD2" ]; then
		PASSWORD=1
	else
		PASSWORD=$PASSWORD1
	fi
}

# Verificar que la clave cumpla unas mínimas condiciones 
checkModPasswd() {
	# Copiar clave
	PASSWORD=$1
	# Se asume que la clave es válida
	PASSWORD_OK=0
	# Si la clave es igual a 1, estas son diferentes
	if [ "$PASSWORD" = "1" ]; then
		echo "[ERROR] - Las claves son diferentes"
		PASSWORD_OK=1
	else
		# Verificar expresión regular
		export PASSWORD_EXP
		if [ `perl -e 'exit $ARGV[0] =~ $ENV{"PASSWORD_EXP"} ? 0 : 1' "$PASSWORD"; echo $?` -eq 0 ]; then
			echo "[ERROR] - La clave no cumple lo mínimo requerido ($PASSWORD_MSG)"
			PASSWORD_OK=1
		else
			return
		fi
	fi
}

# Cambiar UID de un usuario
modUserUid() {
	clear;echo "Cambiar UID de un usuario"
	# Modificar UID
	ldapmodify $ARGS << EOF
	dn: uid=$1,ou=usuarios,$DC
	changetype: modify
	replace: uidNumber
	uidNumber: $2
EOF
}

# Verifica si un usuario existe
existUser() {
	ldapsearch -x -b "ou=usuarios,$DC" "(objectclass=*)" | grep ^uid: | awk -v usuario=$1 '{if($2==usuario) print "1"}'
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

# Obtener listado de grupos
getAllGroups() {
	ldapsearch -x -b "ou=grupos,$DC" "(objectclass=*)" | grep cn: | sort | awk '{printf $2" "}'
}

# Mostrar mensaje de ayuda
help() {
	echo "Modo de ejecución: sh $0 {opción}"
	echo "Opciones ejecutables:
	1) getAll
	2) getAllUsers
	3) getUser
	4) addOu {unidad organizativa que desea crear}
	5) addGroup {grupo que desea crear}
	6) delGroup {grupo que desea eliminar}
	7) addUser
	8) delUser {usuario que desea eliminar}
	9) modPasswd {usuario que desea cambiarle la clave}
	10) modUserUid {usuario} {uidNumber que desea cambiarle al mismo}"
	exit 1
}

# Determinar la opción a ejecutar según se haya indicado por el primer parámetro ($1)
case "$1" in
	getAll) getAll;;
	getAllUsers) getAllUsers;;
	getUser) getUser;;
	addOu) addOu $2;;
	addGroup) addGroup $2;;
	delGroup) delGroup $2;;
	addUser) addUser;;
	delUser) delUser $2;;
	modPasswd) modPasswd $2;;
	modUserUid) modUserUid $2 $3;;
	*) help;;
esac