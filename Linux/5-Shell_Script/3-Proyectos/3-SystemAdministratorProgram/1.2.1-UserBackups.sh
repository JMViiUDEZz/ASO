#!/bin/bash

# Autor: José María Viúdez
# Descripcion: Script con menú para realizar copias de seguridad a los usuarios del sistema

# Llamar al archivo de configuracion environment.sh
. ./environment.sh

clear

# Comprobamos que el usuario ha introducido al menos un nombre de un usuario.
if [ $# == 0 ]; then
    echo "Debes introducir al menos un nombre de un usuario."
    echo ""
    exit 0;
fi

# Comprobamos que existe el destino donde guardaremos las copias de seguridad de los usuarios introducidos anteriormente.
if ! [ -d $DIRBAC ]; then
    echo "El directorio /userBackups no existe, por lo que será creado a continuación..."
    echo ""
	mkdir -p $DIRBAC  
    exit 0;
fi

# Creamos un bucle que recorra los usuarios introducidos como parámetro.
# for user in $*
for user in "$@"
do
    # Comprobamos si existen los usuarios introducidos como parámetro.
    if ! [ "$(grep -cw "^$user" /etc/passwd)" -ge 1 ]; then
        echo "El usuario $user no existe, por lo que no se podrá realizar una copia de seguridad del mismo."
        continue;
    fi

    # Comprobamos que los usuarios tienen un directorio personales dentro del directorio /home.
    if [ -d /home/$user ]; then
        # Comprobar si ya existe algun backup de este usuario, si existe lo eliminamos
        if [ -f $DIRBAC/$user.tar ]; then
            rm -rf $DIRBAC/$user.tar
        fi

        # Creamos un nuevo backup de este usuario
        tar -zcpf $DIRBAC/$user.tar /home/$user
        echo "Tar del usuario $user creado correctamente"
    fi
done

echo ""
echo "Script de copias de seguridad de usuarios finalizado correctamente."
echo ""