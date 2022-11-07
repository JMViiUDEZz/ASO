#!/bin/bash
# * Comprobar si un nombre existe dentro de un fichero
# * Param 1 -> Nombre fichero
# * Param 2 -> Nombre que queremos buscar
if [ -f $1 ]
 then 
    if grep -w $2 $1
     then 
        echo -e "\e[0;32m $2 existe en el fichero \e[0m"
    else 
        echo -e "\e[0;31m No se ha encontrado a $2 \e[0m"
    fi
else
    echo "El fichero introducido cómo primer parámetro no es válido o no existe"
fi