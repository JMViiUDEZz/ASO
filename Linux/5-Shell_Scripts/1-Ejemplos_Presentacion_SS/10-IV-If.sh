#!/bin/sh

#Muestra si el parámetro es positivo o negativo
if [ $# -eq 0 ]
then
	echo "$0 : Debes proporcionar un entero"
	exit 1
fi

if test $1 -gt 0
then
	echo "$1 es positivo"
else 
	echo "$1 es negativo“
fi
