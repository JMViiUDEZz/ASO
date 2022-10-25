#####################################
######-----Ejercicio 1-----##########
#####################################

#gidNumber	Grupo
#5001		profesores
#5002		alumnos

#uidNumber	Nombre				Grupo
#10001		Antonio Resines		profesores
#10002		Carmen Maura		profesores
#10003		Rodolfo Sancho		alumnos
#10004		Paz Vega			alumnos
#10005		Hugo Silva			alumnos
#10006		Clara Lago			çalumnos

#1. Instalar OpenLDAP en el servidor.
#	Requisitos:
#		Es servidor tiene asignado una IP estática.
#		El archivo /etc/hostname contiene el nombre correcto del servidor.
#		El archivo /etc/hosts contienen los nombres adecuados para el servidor(192.168.1.100    u-server.ies.local   u-server).

#	Instalar ldap y slap
apt install slapd ldap-utils -y

#2. Crear el dominio ies.local
#	Iniciar instalacion
dpkg-reconfigure slapd

#	Comprobar que se ha instalado
sudo service slapd status
#sudo systemctl status slapd
ldapsearch -x -LLL -b dc=ies,dc=local dn
slapcat


#	* LANZAR DESDE ESTE PUNTO *#

#!/bin/bash

#3. Crear las unidades organizativas usuarios y grupos.
#4. Crear los grupos profesores y alumnos dentro de la unidad organizativa grupos.
#5. Crear los usuarios contenidos en la tabla dentro de la unidad organizativa usuarios.
#	Crear archivo ldapPlantilla.ldif
touch /home/ldapPlantilla.ldif

#	Estructura
echo '# Fichero ldapPlantilla.ldif' > /home/ldapPlantilla.ldif

echo dn: ou=usuarios,dc=ies,dc=local >> /home/ldapPlantilla.ldif
echo objectclass: organizationalUnit >> /home/ldapPlantilla.ldif
echo ou: usuarios >> /home/ldapPlantilla.ldif

echo '' >> /home/ldapPlantilla.ldif

echo dn: ou=grupos,dc=ies,dc=local >> /home/ldapPlantilla.ldif
echo objectclass: organizationalUnit >> /home/ldapPlantilla.ldif
echo ou: grupos >> /home/ldapPlantilla.ldif

echo '' >> /home/ldapPlantilla.ldif

echo dn: cn=alumnos,ou=grupos,dc=ies,dc=local >> /home/ldapPlantilla.ldif
echo objectclass: posixGroup >> /home/ldapPlantilla.ldif
echo cn: alumnos >> /home/ldapPlantilla.ldif
echo gidNumber: 5002 >> /home/ldapPlantilla.ldif

echo '' >> /home/ldapPlantilla.ldif

echo dn: cn=profesores,ou=grupos,dc=ies,dc=local >> /home/ldapPlantilla.ldif
echo objectclass: posixGroup >> /home/ldapPlantilla.ldif
echo cn: profesores >> /home/ldapPlantilla.ldif
echo gidNumber: 5001 >> /home/ldapPlantilla.ldif

echo '' >> /home/ldapPlantilla.ldif

echo dn: uid=antonior,ou=usuarios,dc=ies,dc=local >> /home/ldapPlantilla.ldif
echo objectClass: inetOrgPerson >> /home/ldapPlantilla.ldif
echo objectClass: posixAccount >> /home/ldapPlantilla.ldif
echo uid: antonior >> /home/ldapPlantilla.ldif
echo sn: Resines >> /home/ldapPlantilla.ldif
echo cn: Antonio Resines >> /home/ldapPlantilla.ldif
echo uidNumber: 10001 >> /home/ldapPlantilla.ldif
echo gidNumber: 5001 >> /home/ldapPlantilla.ldif
echo userPassword: jose >> /home/ldapPlantilla.ldif
echo loginShell: /bin/bash >> /home/ldapPlantilla.ldif
echo homeDirectory: /home/antonior >> /home/ldapPlantilla.ldif 
echo mail: antonio.resines@ies.local >> /home/ldapPlantilla.ldif

echo '' >> /home/ldapPlantilla.ldif

echo dn: uid=carmenm,ou=usuarios,dc=ies,dc=local >> /home/ldapPlantilla.ldif
echo objectClass: inetOrgPerson >> /home/ldapPlantilla.ldif
echo objectClass: posixAccount >> /home/ldapPlantilla.ldif
echo uid: carmenm >> /home/ldapPlantilla.ldif
echo sn: Maura >> /home/ldapPlantilla.ldif
echo cn: Carmen Maura >> /home/ldapPlantilla.ldif
echo uidNumber: 10002 >> /home/ldapPlantilla.ldif
echo gidNumber: 5001 >> /home/ldapPlantilla.ldif
echo userPassword: jose >> /home/ldapPlantilla.ldif
echo loginShell: /bin/bash >> /home/ldapPlantilla.ldif
echo homeDirectory: /home/carmenm >> /home/ldapPlantilla.ldif 
echo mail: carmen.maura@ies.local >> /home/ldapPlantilla.ldif

echo '' >> /home/ldapPlantilla.ldif

echo dn: uid=rodolfos,ou=usuarios,dc=ies,dc=local >> /home/ldapPlantilla.ldif
echo objectClass: inetOrgPerson >> /home/ldapPlantilla.ldif
echo objectClass: posixAccount >> /home/ldapPlantilla.ldif
echo uid: rodolfos >> /home/ldapPlantilla.ldif
echo sn: Sancho >> /home/ldapPlantilla.ldif
echo cn: Rodolfo Sancho >> /home/ldapPlantilla.ldif
echo uidNumber: 10003 >> /home/ldapPlantilla.ldif
echo gidNumber: 5002 >> /home/ldapPlantilla.ldif
echo userPassword: jose >> /home/ldapPlantilla.ldif
echo loginShell: /bin/bash >> /home/ldapPlantilla.ldif
echo homeDirectory: /home/rodolfos >> /home/ldapPlantilla.ldif 
echo mail: rodolfo.sancho@ies.local >> /home/ldapPlantilla.ldif

echo '' >> /home/ldapPlantilla.ldif

echo dn: uid=pazv,ou=usuarios,dc=ies,dc=local >> /home/ldapPlantilla.ldif
echo objectClass: inetOrgPerson >> /home/ldapPlantilla.ldif
echo objectClass: posixAccount >> /home/ldapPlantilla.ldif
echo uid: pazv >> /home/ldapPlantilla.ldif
echo sn: Vega >> /home/ldapPlantilla.ldif
echo cn: Paz Vega >> /home/ldapPlantilla.ldif
echo uidNumber: 10004 >> /home/ldapPlantilla.ldif
echo gidNumber: 5002 >> /home/ldapPlantilla.ldif
echo userPassword: jose >> /home/ldapPlantilla.ldif
echo loginShell: /bin/bash >> /home/ldapPlantilla.ldif
echo homeDirectory: /home/pazv >> /home/ldapPlantilla.ldif 
echo mail: paz.vega@ies.local >> /home/ldapPlantilla.ldif

echo '' >> /home/ldapPlantilla.ldif

echo dn: uid=hugos,ou=usuarios,dc=ies,dc=local >> /home/ldapPlantilla.ldif
echo objectClass: inetOrgPerson >> /home/ldapPlantilla.ldif
echo objectClass: posixAccount >> /home/ldapPlantilla.ldif
echo uid: hugos >> /home/ldapPlantilla.ldif
echo sn: Silva >> /home/ldapPlantilla.ldif
echo cn: Hugo Silva >> /home/ldapPlantilla.ldif
echo uidNumber: 10005 >> /home/ldapPlantilla.ldif
echo gidNumber: 5002 >> /home/ldapPlantilla.ldif
echo userPassword: jose >> /home/ldapPlantilla.ldif
echo loginShell: /bin/bash >> /home/ldapPlantilla.ldif
echo homeDirectory: /home/hugos >> /home/ldapPlantilla.ldif 
echo mail: hugo.silva@ies.local >> /home/ldapPlantilla.ldif

echo '' >> /home/ldapPlantilla.ldif

echo dn: uid=claral,ou=usuarios,dc=ies,dc=local >> /home/ldapPlantilla.ldif
echo objectClass: inetOrgPerson >> /home/ldapPlantilla.ldif
echo objectClass: posixAccount >> /home/ldapPlantilla.ldif
echo uid: claral >> /home/ldapPlantilla.ldif
echo sn: Lago >> /home/ldapPlantilla.ldif
echo cn: Clara Lago >> /home/ldapPlantilla.ldif
echo uidNumber: 10006 >> /home/ldapPlantilla.ldif
echo gidNumber: 5002 >> /home/ldapPlantilla.ldif
echo userPassword: jose >> /home/ldapPlantilla.ldif
echo loginShell: /bin/bash >> /home/ldapPlantilla.ldif
echo homeDirectory: /home/claral >> /home/ldapPlantilla.ldif 
echo mail: clara.lago@ies.local >> /home/ldapPlantilla.ldif

ldapadd -x -W -D 'cn=admin,dc=ies,dc=local' -f /home/ldapPlantilla.ldif 


#	* LANZAR DESDE ESTE PUNTO *#

#!/bin/bash

#####################################
######-----Ejercicio 2-----##########
#####################################
#Realiza las siguientes modificaciones en el directorio:
#1. Añade el atributo “mobile” a los alumnos.
#2. Añade el atributo “homePhone” a los profesores.
#3. Añade el atributo “initials” a los profesores.
#	Estructura modify.ldif
touch /home/modify.ldif

echo '# Fichero modify.ldif' > /home/modify.ldif

echo dn: uid=rodolfos,ou=usuarios,dc=ies,dc=local >> /home/ldapPlantilla.ldif
echo changetype: modify >> /home/modify.ldif
echo add: mobile >> /home/modify.ldif
echo mobile: +34 333 333 333 >> /home/modify.ldif

echo '' >> /home/modify.ldif

echo dn: uid=pazv,ou=usuarios,dc=ies,dc=local >> /home/ldapPlantilla.ldif
echo changetype: modify >> /home/modify.ldif
echo add: mobile >> /home/modify.ldif
echo mobile: +34 444 444 444 >> /home/modify.ldif

echo '' >> /home/modify.ldif

echo dn: uid=hugos,ou=usuarios,dc=ies,dc=local >> /home/ldapPlantilla.ldif
echo changetype: modify >> /home/modify.ldif
echo add: mobile >> /home/modify.ldif
echo mobile: +34 555 555 555 >> /home/modify.ldif

echo '' >> /home/modify.ldif

echo dn: uid=claral,ou=usuarios,dc=ies,dc=local >> /home/ldapPlantilla.ldif
echo changetype: modify >> /home/modify.ldif
echo add: mobile >> /home/modify.ldif
echo mobile: +34 666 666 666 >> /home/modify.ldif

echo '' >> /home/modify.ldif

echo dn: uid=antonior,ou=usuarios,dc=ies,dc=local >> /home/ldapPlantilla.ldif
echo changetype: modify >> /home/modify.ldif
echo add: homePhone >> /home/modify.ldif
echo homePhone: +34 111 111 111 >> /home/modify.ldif

echo '' >> /home/modify.ldif

echo dn: uid=carmenm,ou=usuarios,dc=ies,dc=local >> /home/ldapPlantilla.ldif
echo changetype: modify >> /home/modify.ldif
echo add: homePhone >> /home/modify.ldif
echo homePhone: +34 222 222 222 >> /home/modify.ldif

echo '' >> /home/modify.ldif

echo dn: uid=antonior,ou=usuarios,dc=ies,dc=local >> /home/ldapPlantilla.ldif
echo changetype: modify >> /home/modify.ldif
echo add: initials >> /home/modify.ldif
echo initials: A. R. >> /home/modify.ldif

echo '' >> /home/modify.ldif

echo dn: uid=carmenm,ou=usuarios,dc=ies,dc=local >> /home/ldapPlantilla.ldif
echo changetype: modify >> /home/modify.ldif
echo add: initials >> /home/modify.ldif
echo initials: C. M. >> /home/modify.ldif

echo '' >> /home/modify.ldif

#4. Modifica la shell de Rodolfo por /bin/sh.
#5. Modifica el e-mail de Rodolfo por r.sancho@ies.es
echo dn: uid=rodolfos,ou=usuarios,dc=ies,dc=local >> /home/ldapPlantilla.ldif
echo changetype: modify >> /home/modify.ldif
echo replace: loginShell >> /home/modify.ldif
echo loginShell: /bin/sh >> /home/modify.ldif

echo '' >> /home/modify.ldif

echo dn: uid=rodolfos,ou=usuarios,dc=ies,dc=local >> /home/ldapPlantilla.ldif
echo changetype: modify >> /home/modify.ldif
echo replace: mail >> /home/modify.ldif
echo mail: r.sancho@ies.es >> /home/modify.ldif

echo '' >> /home/modify.ldif

#6. Elimina el atributo “initials” de Carmen.
echo '' >> /home/modify.ldif

echo dn: uid=carmenm,ou=usuarios,dc=ies,dc=local >> /home/ldapPlantilla.ldif
echo changetype: modify >> /home/modify.ldif
echo delete: initials >> /home/modify.ldif

ldapmodify -x -W -D "cn=admin,dc=ies,dc=local" -f /home/modify.ldif


#	* LANZAR DESDE ESTE PUNTO *#

#!/bin/bash

#####################################
######-----Ejercicio 3-----##########
#####################################
#Realiza las siguientes búsquedas en el directorio:
#1. Mostrar sólo el dn de todos los usuarios.
ldapsearch -xLLL -b "dc=ies,dc=local" "(objectClass=Person)" dn

#2. Mostrar los usuarios cuyo nombre comience por C.
ldapsearch -xLLL -b "dc=ies,dc=local" "(&(objectClass=Person)(cn=c*))" dn objectClass cn

#3. Mostrar el nombre y los apellidos de todos los alumnos.
ldapsearch -xLLL -b "dc=ies,dc=local" "(gidNumber=5002)" dn cn sn

#4. Mostrar el uid de los profesores.
ldapsearch -xLLL -b "dc=ies,dc=local" "(gidNumber=5001)" dn uid

#5. Mostrar el nombre de los alumnos con teléfono móvil.
ldapsearch -xLLL -b "dc=ies,dc=local" "(&(gidNumber=5002)(mobile=*))" dn cn

#6. Mostrar el nombre y los apellidos del usuario con identificador de valor 10004.
ldapsearch -xLLL -b "dc=ies,dc=local" "(uidNumber=10004)" dn cn sn

#7. Mostrar los alumnos con apellido acabado en A.
ldapsearch -xLLL -b "dc=ies,dc=local" "(&(gidNumber=5002)(sn=*a))" dn gidNumber sn

#8. Mostrar los alumnos con apellido no acabado en O.
ldapsearch -xLLL -b "dc=ies,dc=local" "(&(gidNumber=5002)(!(sn=*o)))" dn gidNumber sn

#9. Mostrar los profesores con identificador distinto a 10001
ldapsearch -xLLL -b "dc=ies,dc=local" "(&(gidNumber=5001)(!(uidNumber=10001)))" dn gidNumber uidNumber

#10. Mostrar los alumnos con identificador mayor a 10005 que tengan email o móvil.
ldapsearch -xLLL -b "dc=ies,dc=local" "(&(gidNumber=5002)(&(|(email=*)(mobile=*))(uidNumber>=10005)))" dn gidNumber uidNumber email mobile