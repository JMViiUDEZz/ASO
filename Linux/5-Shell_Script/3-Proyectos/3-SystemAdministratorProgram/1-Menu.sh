#!/bin/bash

# Autor: José María Viúdez
# Descripcion: Script con menú para monitorear los recursos del sistema o
# ejecutar otro menú para realizar copias de seguridad a los usuarios del sistema

# Limpiar la pantalla al lanzar el menú
clear

# Función que muestra las opciones del menú
getOptions() {
    echo "1) Monitorear los recursos del sistema"
    echo "2) Ejecutar menú para realizar copias de seguridad a los usuarios del sistema"
    echo "3) Salir"
}

# Ejecución de la funcion para que muestre las opciones del menú
getOptions

# Leer la opción introducida por el usuario
read -p "Introduce una opción: " option

# Bucle de permanecer en el menú hasta que el usuario introduzca la opción 3
while [ ${option} != 3 ]
do
clear
	# Comprobar que ha introducido el usuario
	case ${option} in
		1)
            # Si el usuario introduce la opción 1 ejecutamos el script de obtener los recursos del sistema
            sh 1.1-ResourcesMonitoring.sh
		;;
		2)
            # Si el usuario introduce la opción 2 le ofrecemos el menu de copias de seguridad
            sh 1.2-MenuUserBackups.sh
		;;
		*)
			# En caso de q el usuario introduzca una opción no válida, se mostrará lo siguiente
			echo "Opción no válida"
		;;
    esac
    # Al final de cada opción, pediremos al usuario que teclee una tecla al azar para continuar
    echo ""
    read -p "Pulsa una tecla al azar para continuar..." pausa

	# Limpiar la pantalla
    clear

    # Volvemos a mostrar las opciones del menú
    getOptions
    read -p "Introduce una nueva opción: " option    
done

# Limpiar la pantalla
clear

echo "Has cerrado el programa"
echo ""
