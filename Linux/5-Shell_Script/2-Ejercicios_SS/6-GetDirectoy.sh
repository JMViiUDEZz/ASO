#!/bin/bash

# Autor: José María Viúdez
# 6) Crear un shell script que liste todos los directorios y 
# subdirectorios recursivamente de uno dado. 
# El directorio será introducido como argumento y el guión lo primero que hará 
# será verificar si es precisamente un directorio.

# 1ª FORMA
clear
if [ ! $# -eq 1 ]
then
    echo "¡ERROR!, Uso: $0 nombre_dir"
elif [ -d $1 ]
then
    ls -lR $1 | grep '^d'
else
    echo "No existe el directorio"
fi

# 2ª FORMA
clear
if [ $# -ne 1 ]
then
    echo "Numero de parametros incorrecto."
    echo -e "\nIntroduce un nombre de un direcctorio como parametro\nFormato: $0 <nombre_dir>"
    echo " "
    exit 0
fi

if [  -d $1 ]
then
    ls -lR $1 | grep "^d"
else
    echo "No exixte un directorio llamado $1"
fi

exit 0