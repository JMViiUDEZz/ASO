#!/bin/bash

# Autor: José María Viúdez
# Descripcion: Realizar un conjunto de scripts con la finalidad de poder importar y exportar 
# usuarios desde archivos CSV (valores separados por comas) a un directorio OpenLDAP y viceversa.

# Los requisitos mínimos que se deben cumplir son:
# - Al script de importación se le pasará como parámetro el nombre de fichero CSV 
# con los datos necesarios e importará los usuarios al directorio de OpenLDAP.

# - Opcionalmente el script puede generar solo el fichero LDIF 
# (LDAP Data Interchange Format) para cargar los datos más tarde.

# - El script de importación deberá comprobar al menos que los parámetros 
# son correctos y que el fichero existe y mostrar ayuda en caso de error.

# - En otro script diferente se implementará la utilidad de exportación, que debe 
# funcionar de manera inversa, es decir, guardará los usuarios del directorio en un fichero CSV.

# - Para hacer más sencillo el funcionamiento, un tercer script mostrará un menú que permita al 
# usuario trabajar de manera interactiva con las utilidades sin tener que conocer los parámetros. 
# El menú al menos proporcionará la opción de importar usuarios, exportar y salir del menú.

# - Por último el sistema debe ser portable y funcionar en otros directorios. Para ello contará 
# con un fichero de configuración en el que se pueda establecertodos los parámetros necesarios 
# para el funcionamiento, como el nombre del servidor, dirección IP, nombre del dominio, etc…

# Comprobacion de que se ejecuta el script como root
# if ! [ $(id -u) = 0 ]
# then 
    # echo -e "No tienes permisos.\nEjecuta el script como root." 
    # exit 1 
# fi

# Limpiar la pantalla al lanzar el menú
clear

# Función que muestra las opciones del menú
getOptions() {
    echo "1) Importar usuarios"
    echo "2) Exportar usuarios"
    echo "3) Salir"
}

# Ejecución de la funcion para que muestre las opciones del menú
getOptions

# Leer la opción introducida por el usuario
read -p "Introduce una opción: " option

clear
# Comprobar que ha introducido el usuario
case ${option} in
    1)
        # Si el usuario introduce la opción 1, comprobaremos que el archivo de importación introducido en el primer parámetro existe			
		if [ -f $1 ]; then
			sh 1.1-ImportUsers.sh $1
        else
            echo "El archivo de importacion no existe"
        fi
    ;;
    2)
        # Si el usuario introduce la opción 2, crearemos un archivo con los usuarios del sistema y su grupo
        sh 1.2-ExportUsers.sh
    ;;
	3)
        # Si el usuario introduce la opción 3, se saldrá del script
		echo "Has salido del programa"
		sleep 2
		exit
    ;;
    *)
        # En caso de q el usuario introduzca una opción no válida, se mostrará lo siguiente
        echo "Opción no válida"
    ;;
esac