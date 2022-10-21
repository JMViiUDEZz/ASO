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

echo dn: cn=directores,ou=grupos,dc=ies,dc=local >> /home/ldapPlantilla.ldif
echo objectclass: posixGroup >> /home/ldapPlantilla.ldif
echo cn: directores >> /home/ldapPlantilla.ldif
echo gidNumber: 5001 >> /home/ldapPlantilla.ldif

echo '' >> /home/ldapPlantilla.ldif
echo dn: cn=recursosHumanos,ou=grupos,dc=ies,dc=local >> /home/ldapPlantilla.ldif
echo objectclass: posixGroup >> /home/ldapPlantilla.ldif
echo cn: recursosHumanos >> /home/ldapPlantilla.ldif
echo gidNumber: 5002 >> /home/ldapPlantilla.ldif

echo '' >> /home/ldapPlantilla.ldif

echo dn: cn=tecnologia,ou=grupos,dc=ies,dc=local >> /home/ldapPlantilla.ldif
echo objectclass: posixGroup >> /home/ldapPlantilla.ldif
echo cn: tecnologia >> /home/ldapPlantilla.ldif
echo gidNumber: 5003 >> /home/ldapPlantilla.ldif

echo '' >> /home/ldapPlantilla.ldif

echo dn: cn=marketing,ou=grupos,dc=ies,dc=local >> /home/ldapPlantilla.ldif
echo objectclass: posixGroup >> /home/ldapPlantilla.ldif
echo cn: marketing >> /home/ldapPlantilla.ldif
echo gidNumber: 5004 >> /home/ldapPlantilla.ldif



ldapadd -x -W -D 'cn=admin,dc=ies,dc=local' -f /home/ldapPlantilla.ldif 