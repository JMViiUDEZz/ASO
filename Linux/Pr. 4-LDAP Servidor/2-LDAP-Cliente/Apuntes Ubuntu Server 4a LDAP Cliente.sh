###################################################
######-----Instalar ldap en clientes-----##########
###################################################
apt install libnss-ldap
    1) ldap://Ip del servidor
    2) nombre del dominio --> dc=ies,dc=local
    3) Version 3
    4) Yes
    5) No
    6) cn=admin,dc=ies,dc=local
    7) <contraseña>


###################################################
####--En caso de que necesitemos reconfigurar--####
###################################################
dpkg-reconfigure ldap-auth-config


#	* LANZAR DESDE ESTE PUNTO *#

#!/bin/bash

###################################################
####-------Configurar el nsswitch.conf---------####
###################################################
echo 'passwd:         files systemd ldap' > /etc/nsswitch.conf
echo 'group:          files systemd ldap' >> /etc/nsswitch.conf
echo 'shadow:         files ldap' >> /etc/nsswitch.conf
echo 'gshadow:        files' >> /etc/nsswitch.conf
echo '' >> /etc/nsswitch.conf
echo 'hosts:          files mdns4_minimal [NOTFOUND=return] dns' >> /etc/nsswitch.conf
echo 'networks:       files'
echo '' >> /etc/nsswitch.conf
echo 'protocols:      db files' >> /etc/nsswitch.conf
echo 'services:       db files' >> /etc/nsswitch.conf
echo 'ethers:         db files' >> /etc/nsswitch.conf
echo 'rpc:            db files' >> /etc/nsswitch.conf
echo '' >> /etc/nsswitch.conf
echo 'netgroup:       nis >> /etc/nsswitch.conf' >> /etc/nsswitch.conf


###################################################
####-------Configurar el common-password---------##
###################################################
echo 'password        [success=2 default=ignore]      pam_unix.so obscure sha512 > /etc/pam.d/common-password' >> etc/pam.d/common-password
echo 'password        [success=1 user_unknown=ignore default=die]     pam_ldap.so try_first_pass' >> etc/pam.d/common-password
echo '' >> /etc/pam.d/common-password
echo 'password        requisite                       pam_deny.so' >> etc/pam.d/common-password
echo '' >> /etc/pam.d/common-password
echo 'password        required                        pam_permit.so' >> etc/pam.d/common-password
echo '' >> /etc/pam.d/common-password
echo 'password        optional        pam_gnome_keyring.so >> /etc/pam.d/common-password' >> etc/pam.d/common-password


###################################################
####-------Configurar el common-session----------##
###################################################
echo 'session [default=1]      pam_permit.so' > /etc/pam.d/common-session

echo '' >> /etc/pam.d/common-session

echo 'session requisite        pam_deny.so' >> /etc/pam.d/common-session

echo '' >> /etc/pam.d/common-session

echo 'session required         pam_permit.so' >> /etc/pam.d/common-session

echo '' >> /etc/pam.d/common-session

echo 'session optional         pam_umask.so' >> /etc/pam.d/common-session

echo '' >> /etc/pam.d/common-session

echo 'session required        pam_unix.so' >> /etc/pam.d/common-session
echo 'session optional        pam_ldap.so' >> /etc/pam.d/common-session
echo 'session optional        pam_systemd.so' >> /etc/pam.d/common-session
echo 'session optional        pam_mkhomedir.so' skel=/etc/skel umask=077 >> /etc/pam.d/common-session


#Reiniciar el pc
sudo shutdown -r now


###################################################
####---Comprobar la instalación en el cliente----##
###################################################
getent passwd