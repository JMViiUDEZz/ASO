# 4) Comprueba si el fichero pasado por parámetro tiene permisos de lectura, 
# en cuyo caso mostrará el contenido de forma paginada.

#!/bin/bash

if [ $# -lt 1 ]
then
    echo "Error. Sintaxis de uso: $0 archivo"
elif [ -f $1 ]
then 
    echo "$1 es un fichero"
	if [ -r $1 ]
	then
		echo "$1 tiene permisos de lectura"
		cat $1 | more
	else
		echo "$1 no tiene permisos de lectura"
	fi
else 
    echo "$1 no es un fichero"
fi