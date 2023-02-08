#!/bin/bash

# Autor: José María Viúdez
# Descripcion: Script con menú para realizar copias de seguridad a los usuarios del sistema

# Limpiar la pantalla al lanzar el menú
clear

# Función que muestra las opciones del menú
getOptions() {
    echo "1) Backup usuarios"
    echo "2) Restaurar usuarios"
    echo "3) Salir"
}

# Ejecución de la funcion para que muestre las opciones del menú
getOptions

# Leer la opción introducida por el usuario
read -p "Introduce una opción: " option

clear
# Bucle de permanecer en el menú hasta que el usuario introduzca la opción 3
while [[ ${option} != 3 ]]
do
clear
    # Comprobar que ha introducido el usuario
    case ${option} in
        1)
            # Si el usuario introduce la opción 1 le pedimos que introduzca los usuarios
            read -p "Introduce los nombres de los usuarios separados por espacios: " users
            
            bash 1.2.1-UserBackups.sh $users
        ;;
        2)
            # Si el usuario introduce la opción 2 le pedimos que introduzca la ruta del backup y los usuarios que restaurar
            read -p "Introduce la ruta de los backup y los nombres de los usuarios separados por espacios: " recover

            bash 1.2.2-RecoverUserBackups.sh $recover
        ;;
		*)
			# En caso de q el usuario introduzca una opción no válida, se mostrará lo siguiente
			echo "Opción no válida"
		;;
	esac
done
