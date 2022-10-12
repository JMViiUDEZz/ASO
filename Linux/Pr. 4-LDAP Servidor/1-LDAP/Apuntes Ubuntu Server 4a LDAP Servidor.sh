###################################################
##########-----Requisitos-----#####################
###################################################
#Es servidor tiene asignado una IP estática.
#El archivo /etc/hostname contiene el nombre correcto del servidor.
#El archivo /etc/hosts contienen los nombres adecuados para el servidor.


###################################################
######-----Instalar ldap-----######################
###################################################
apt install slapd ldap-utils -y


###################################################
######-----Iniciar instalacion-----################
###################################################
dpkg-reconfigure slapd


###################################################
######-----Comprobar instalacion-----##############
###################################################
sudo service slapd status
ldapsearch -x -LLL -b dc=ies,dc=local dn
slapcat


#* LANZAR DESDE ESTE PUNTO *#

#!/bin/bash

###################################################
######-----Crear archivo plantillas-----###########
###################################################
touch /home/ldapPlantilla.ldif


###################################################
############-----Estructura-----###################
###################################################
echo dn: ou=usuarios,dc=ies,dc=local > /home/ldapPlantilla.ldif
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

echo dn: uid=aresines,ou=usuarios,dc=ies,dc=local >> /home/ldapPlantilla.ldif
echo objectClass: inetOrgPerson >> /home/ldapPlantilla.ldif
echo objectClass: posixAccount >> /home/ldapPlantilla.ldif
echo uid: aresines >> /home/ldapPlantilla.ldif
echo sn: Resines >> /home/ldapPlantilla.ldif
echo cn: Antonio Resines >> /home/ldapPlantilla.ldif
echo uidNumber: 10001 >> /home/ldapPlantilla.ldif
echo gidNumber: 5001 >> /home/ldapPlantilla.ldif
echo userPassword: usuario >> /home/ldapPlantilla.ldif
echo loginShell: /bin/bash >> /home/ldapPlantilla.ldif
echo homeDirectory: /home/aresines >> /home/ldapPlantilla.ldif 
echo mail: aresines@ies.local >> /home/ldapPlantilla.ldif

echo '' >> /home/ldapPlantilla.ldif

echo dn: uid=pvega,ou=usuarios,dc=ies,dc=local >> /home/ldapPlantilla.ldif
echo objectClass: inetOrgPerson >> /home/ldapPlantilla.ldif
echo objectClass: posixAccount >> /home/ldapPlantilla.ldif
echo uid: pvega >> /home/ldapPlantilla.ldif
echo sn: Vega >> /home/ldapPlantilla.ldif
echo cn: Paz Vega >> /home/ldapPlantilla.ldif
echo uidNumber: 10002 >> /home/ldapPlantilla.ldif
echo gidNumber: 5002 >> /home/ldapPlantilla.ldif
echo userPassword: usuario >> /home/ldapPlantilla.ldif
echo loginShell: /bin/bash >> /home/ldapPlantilla.ldif
echo homeDirectory: /home/pvega >> /home/ldapPlantilla.ldif 
echo mail: pvega@ies.local >> /home/ldapPlantilla.ldif

ldapadd -x -W -D 'cn=admin,dc=ies,dc=local' -f /home/ldapPlantilla.ldif 


###################################################
#########-----Modificar el .conf-----##############
###################################################
SERVER=localhost
BINDDN='dn=admin, dc=ies, dc=local'
BINDPWDFILE="/etc/ldapscripts/ldapscripts.passwd"
UIDSTART=10001
LDAPSEARCHBIN="/usr/bin/ldapsearch"
LDAPADDBIN="/usr/bin/ldapadd"
LDAPDELETEBIN="/usr/bin/ldapdelete"
UTEMPLATE=""


###################################################
#######-----Darle la contraseña sudo-----##########
###################################################
echo -n '<mi contraseña>' > /etc/ldapscripts/ldapscripts.passwd

chmod 400 /etc/ldapscripts/ldapscripts.passwd


#* LANZAR DESDE ESTE PUNTO *#

#!/bin/bash

###################################################
######-----Crear archivo modificar-----###########
###################################################
touch /home/modify.ldif

###################################################
############-----Estructura-----###################
###################################################
echo dn: uid=pvega,ou=usuarios,dc=ies,dc=local > /home/modify.ldif
echo changetype: modify >> /home/modify.ldif
echo add: homePhone >> /home/modify.ldif
echo homePhone: +34 922 541 978 >> /home/modify.ldif

echo '' >> /home/modify.ldif

echo dn: uid=pvega,ou=usuarios,dc=ies,dc=local >> /home/modify.ldif
echo changetype: modify >> /home/modify.ldif
echo delete: mail >> /home/modify.ldif

echo '' >> /home/modify.ldif

echo dn: uid=pvega,ou=usuarios,dc=ies,dc=local >> /home/modify.ldif
echo changetype: modify >> /home/modify.ldif
echo replace: mail >> /home/modify.ldif
echo mail: hola@ies.local >> /home/modify.ldif

ldapmodify -x -W -D "cn=admin,dc=ies,dc=local" -f /home/modify.ldif


#* LANZAR DESDE ESTE PUNTO *#

#!/bin/bash

###################################################
########-----Estructura Eliminar-----##############
###################################################
ldapdelete -x -W -D "cn=admin,dc=ies,dc=local" "uid=pvega,ou=usuarios,dc=ies,dc=local"


#* LANZAR DESDE ESTE PUNTO *#

#!/bin/bash

###################################################
########-----Estructura Busqueda-----##############
###################################################
ldapsearch -xLLL -b "dc=ies,dc=local" "(objectClass=Person)" mobile

ldapsearch -xLLL -b "dc=ies,dc=local" "(uid=aresines)" homePhone mail

ldapsearch -xLLL -b "dc=ies,dc=local" "(uid=*res*)" dn cn

ldapsearch -xLLL -b "dc=ies,dc=local" "(uidNumber>=10000)" dn cn

ldapsearch -xLLL -b "dc=ies,dc=local" "(mobile=*)" dn cn

# Operador and
ldapsearch -xLLL -b "dc=ies,dc=local" "(&(objectClass=Person)(cn=a*))" dn cn

# Operador or
ldapsearch -xLLL -b "dc=ies,dc=local" "(|(objectClass=Person)(cn=a*))" dn cn

# Operador not
ldapsearch -xLLL -b "dc=ies,dc=local" '(!(objectClass=Person))' dn cn

# Operadores multiples
ldapsearch -xLLL -b "dc=ies,dc=local" "(&(objectClass=Person)(|(objectClass=Person)(cn=a*)))" dn cn