#!/bin/bash

###################################################
###--Crear carpetas compartidas y sus permisos--###
###################################################
mkdir /srv/directores
mkdir /srv/recursoshumanos
mkdir /srv/tecnologia
mkdir /srv/marketing

chown nobody:nogroup /srv/directores
chown nobody:nogroup /srv/recursoshumanos
chown nobody:nogroup /srv/tecnologia
chown nobody:nogroup /srv/marketing

chmod -R 777 /srv/directores
chmod -R 777 /srv/recursoshumanos
chmod -R 777 /srv/tecnologia
chmod -R 777 /srv/marketing

###################################################
######------Configurar el /etc/exports-------######
###################################################
echo '/srv/directores *(rw,sync,no_root_squash)' > /etc/exports
echo '/srv/recursoshumanos *(rw,sync,no_root_squash)' >> /etc/exports
echo '/srv/tecnologia *(rw,sync,no_root_squash)' >> /etc/exports
echo '/srv/marketing *(rw,sync,no_root_squash)' >> /etc/exports

###################################################
######------Reiniciar el servicio------------######
###################################################
service nfs-kernel-server restart