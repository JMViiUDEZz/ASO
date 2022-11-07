# * Script que al pasar por argumento un archivo o directorio devuelve el tamaño en MB

#!/bin/bash
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
