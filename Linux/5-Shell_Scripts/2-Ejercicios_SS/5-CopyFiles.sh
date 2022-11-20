#!/bin/bash

# Autor: José María Viúdez
# 5) Copia todos los archivos de trabajo con extensión .dat y .c 
# del directorio actual al directorio pasado como argumento. 
# Si este directorio no existe, el guión lo debe crear.

# 1ª FORMA
clear
if [ -d $1 ]
then
    echo "$1 es un directorio"
else 
    echo "$1 no existe"
	mkdir $1
fi

cp .*.dat $1
cp .*.c $1

# 2ª FORMA
clear
if [ $# -ne 1 ]
then
    echo "Numero de parametros incorrecto."
    echo -e "\nIntroduce un nombre de un direcctorio como parametro"
    exit 0
fi

# test ! -d $1 && mkdir $1
if [ ! -d $1 ]
then
    mkdir $1
fi

if [ -d $1 ]
then
    cp *.dat *.c $1 2> /dev/null
fi