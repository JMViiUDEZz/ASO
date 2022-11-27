#!/bin/bash

# Autor: José María Viúdez
# 4) Comprueba si el fichero pasado por parámetro tiene permisos de lectura, 
# en cuyo caso mostrará el contenido de forma paginada.

# 1ª FORMA
clear
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

# 2ª FORMA
clear
if [ $# -ne 1 ]
then
    echo "Numero de parametros incorrecto."
    exit 0
fi

if [ -e $1 ] 
then
    if [ -r $1 ]
    then
        cat $1 | more
    else
        echo "No tienes permiso de lectura en $1."
    fi
else
    echo "El archivo $1 no existe."
fi

exit 0