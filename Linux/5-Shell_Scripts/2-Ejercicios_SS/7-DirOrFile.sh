#!/bin/bash

# Autor: José María Viúdez
# 7) Escribir un script que al pasarle por argumento un parámetro, 
# determine si es archivo, directorio, o si el parámetro no existe.

# 1ª FORMA
clear
if [ $# -lt 1 ]
then
    echo "Error. Sintaxis de uso: $0 archivo"
elif [ -d $1 ]
then
    echo "$1 es un directorio"
elif [ -f $1 ]
then 
    echo "$1 es un fichero"
    du -hs $1
else 
    echo "$1 no existe"
fi

# 2ª FORMA
clear
if [ $# -ne 1 ]
then
    echo "ERROR!! Numero de parametros incorrecto."
    echo -e "\nFormato:\n \n$0 <nombre_archivo>"
    echo " "
    exit 0
fi

if [ -e $1 ]
then
    if [ -d $1 ]
    then
        echo " "
        echo "$1 es un DIRECTORIO"
        echo " "
    else
        echo " "
        echo "$1 es un ARCHIVO"
        echo " "
    fi
else
    echo " "
    echo "$1 no existe"
    echo " "
fi

exit 0