# * Script que lista todos los directorios y subdirectorios recursivamente de uno dado.
# * El directorio será introducido como argumento y el guión lo primero que hará será verificar si es un directorio.

#!/bin/bash
if [ ! $# -eq 1 ]
then
    echo "¡ERROR!, Uso: $0 nombre_dir"
elif [ -d $1 ]
then
    ls -lR $1 | grep '^d'
else
    echo "No existe el directorio"
fi