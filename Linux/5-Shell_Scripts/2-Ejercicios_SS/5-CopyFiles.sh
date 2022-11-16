# 5) Copia todos los archivos de trabajo con extensión .dat y .c 
# del directorio actual al directorio pasado como argumento. 
# Si este directorio no existe, el guión lo debe crear.

#!/bin/bash

if [ -d $1 ]
then
    echo "$1 es un directorio"
else 
    echo "$1 no existe"
	mkdir $1
fi

cp .*.dat $1
cp .*.c $1