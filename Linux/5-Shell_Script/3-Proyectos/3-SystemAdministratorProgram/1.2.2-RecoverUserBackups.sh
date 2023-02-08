#!/bin/bash

# Autor: José María Viúdez
# Descripcion: Script con menú para realizar copias de seguridad a los usuarios del sistema

# Llamar al archivo de configuracion environment.sh
. ./environment.sh

clear

# Comprobamos que el usuario ha introducido al menos dos parametros.
if [ $# -le 1 ]; then
    echo "Debes introducir al menos dos parámetros:"
    echo " - El primero será la ruta donde estén almacenadas las copias de seguridad."
	echo " - El segundo será el usuario."
	echo ""
    exit 0;
fi

# Comprobamos que existe la ruta donde obtendremos las copias de seguridad.
if ! [ -d $1 ]; then
    echo "La ruta $1 no existe, por lo que no hay donde obtener las copias de seguridad."
    exit 0;
fi

# Desplazamos los parémetros uno hacia la derecha, ya que el primero de ellos es la ruta de las copias de seguridad.
shift 1
# Creamos un bucle que recorra los usuarios introducidos como parámetro.
# for user in $*
for user in "$@"
do
    # Comprobamos si existen los usuarios introducidos como parámetro.
    if ! [ "$(grep -cw "^$user" /etc/passwd)" -ge 1 ]; then
        echo "El usuario $user no existe, por lo que no se podrá realizar una copia de seguridad del mismo."
        continue;
    fi

    # Comprobamos si existen copias de seguridad de los usuarios introducidos anteriormente.
    if ! [ -f $DIRBAC/$user.tar ]; then
        echo "No existe ninguna copia de seguridad para el usuario $user"
        continue;
    fi

    # Comprobamos si existen directorios personales de los usuarios introducidos previamente.
	# Si no existen los creamos desde el backup, teniendo en cuenta que este exista.
    # Pedimos al usuario que nos confirme si quiere sustiuir el /home del backup por el home actual
    if [ -d /home/$user ]; then
        flag=0
        until [[ ${flag} == 1 ]]
        do
            # Mostramos las opciones al usuario
            read -p "Actualmente ya existe un home del usuario $user, ¿quiere borrar el home actual 
            y sustituirlo por el home de la copia de seguridad? y/n: " option
            # Comprobamos que ha introducido el usuario
            case ${option} in
                "y")
                    # Eliminamos el home actual...
                    echo "Eliminando el home actual..."
                    rm -rf /home/$user
                    # Recuperamos el home del backup...
                    echo "Recuperando el home de la copia de seguridad..."
                    tar -xzf $DIRBAC/$user.tar -C /
                    flag=1
                ;;
                "n")
                    # Cancelamos la recuperación del usuario...
                    echo "Recuperación del usuario $user cancelado"
                    flag=1
                ;;
                *)
                    # En caso de q el usuario introduzca una opción no válida, se mostrará lo siguiente:
                    echo "Opción no válida, introduzca y/n"
                ;;
            esac
            clear
        done
    else
        tar -xzf $DIRBAC/$user.tar -C /
    fi
    
done

echo ""
echo "Script de restauracion de copias de seguridad de usuarios finalizado correctamente."
echo ""