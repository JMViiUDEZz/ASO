#!/bin/bash

# Autor: José María Viúdez
# 10) Escribir un script que al pasarle como parámetro un archivo de texto, 
# ordene las líneas de texto ascendentemente al pasarle una "A" 
# como segundo parámetro o descendentemente al pasarle una "Z".

# 1ª FORMA
clear
if [ $# -eq 2 ]
 then
    if [ -f $1 ]
        if [ $2 = 'A' ]
         then
            cat $1
        elif [ $2 = 'Z' ]
         then
            tail $1
        else
            echo "Error, el segundo parámetro debe ser una A o una Z"
        fi
    else
        echo "Error, el primer parámetro no se corresponde con un archivo existente" 
    fi
else
    echo "Error, el número de parámetros debe ser 2"
fi

# 2ª FORMA
clear
if [ $# -lt 1 ] || [ $# -gt 2 ]
then
    echo "ERROR!! Numero de parametros incorrecto."
    echo -e "\nFormato:\n \n$0 [ A || D ] <nombre_archivo>\n"
    exit 0
fi

if [ $# -eq 1 ] && [ -f $1 ]
then
    cat $1
    exit 0
elif [ $# -eq 1 ] && [ ! -f $1 ]
then
    echo "El archivo $1 no existe"
    exit 0
fi

if [ $# -eq 2 ] && [ -f $2 ]
then
    case $1 in
        A) cat $2 | sort ;;
        D) cat $2 | sort -r ;;
        *) echo -e "El primer parametro introducido es incorrecto.\nIntroduce una A o D"
    esac
    exit 0
else
    echo "El archivo $2 no existe"
fi

exit 0