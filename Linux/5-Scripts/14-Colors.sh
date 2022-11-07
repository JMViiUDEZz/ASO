#!/bin/bash
# * Mostrar texto de un color

rojo() {
    echo -e "\e[0;31m$1 \e[0m"
}

verde() {
    echo -e "\e[0;32m$1 \e[0m"
}

if [ -f $1 ]
 then 
    if grep -w $2 $1 >> /dev/null
     then 
        verde "Se ha encontrado la palabra $2"
    else 
        rojo "No se ha encontrado la palabra $2"
    fi
else
    echo "El fichero introducido cómo primer parámetro no es válido o no existe"
fi

