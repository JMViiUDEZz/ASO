#!/bin/bash

# Autor: José María Viúdez
# 9) Crear un fichero con de nombre copia.bkp, 
# donde se almacenen comprimidos todos los ficheros que se pasen por parámetros.

# 1ª FORMA
clear
if [ $# -ne 0 ]
then
    tar cvfz copia.bkp $*
else
    echo "Error: no se han pasado ficheros"
fi

# 2ª FORMA
clear
if [ $# -eq 0 ]
then
    echo "ERROR!! Numero de parametros incorrecto."
    echo -e "\nFormato:\n \n$0 <nombre_archivo>\n"
    exit 0
fi

tar cvzf copia.tgz $@ 

exit 0