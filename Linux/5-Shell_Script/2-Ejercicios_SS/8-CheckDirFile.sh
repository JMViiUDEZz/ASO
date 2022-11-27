#!/bin/bash

# Autor: José María Viúdez
# 8) Escribir un script que al pasarle por argumento 
# un archivo o directorio, devuelve el tamaño en MB.

# 1ª FORMA
clear
if [ $# -lt 1 ]
then
    echo "Error. Sintaxis de uso: $0 archivo"
elif [ -d $1 ]
then
    echo "$1 es un directorio y su tamaño es:"
    du -hs $1
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
    echo -e "\nFormato:\n \n$0 <nombre_archivo>\n"
    exit 0
fi

if [ -e $1 ]
then
    du -sh $1
else
    echo "No existe un archivo o directorio llamado $1"
fi

exit 0