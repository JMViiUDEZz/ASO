#!/bin/bash

###################################################
#####---------Instalar nfs-common------------######
###################################################
apt install nfs-common -y

###################################################
#####----Crear carpetas para el montaje------######
###################################################
mkdir /mnt/directores
mkdir /mnt/administracion
mkdir /mnt/tecnologia
mkdir /mnt/ventas
mkdir /mnt/recursoshumanos
mkdir /mnt/marketing

###################################################
######------Configurar el /etc/fstab---------######
###################################################
echo '192.168.1.1:/srv/directores  /mnt/directores  nfs4  auto  0  0' >> /etc/fstab
echo '192.168.1.1:/srv/administracion  /mnt/administracion  nfs4  auto  0  0' >> /etc/fstab
echo '192.168.1.1:/srv/tecnologia  /mnt/tecnologia  nfs4  auto  0  0' >> /etc/fstab
echo '192.168.1.1:/srv/ventas  /mnt/ventas  nfs4  auto  0  0' >> /etc/fstab
echo '192.168.1.1:/srv/recursoshumanos  /mnt/recursoshumanos  nfs4  auto  0  0' >> /etc/fstab
echo '192.168.1.1:/srv/marketing  /mnt/marketing  nfs4  auto  0  0' >> /etc/fstab

echo 'Reinicia el sistema para montar las carpetas'

