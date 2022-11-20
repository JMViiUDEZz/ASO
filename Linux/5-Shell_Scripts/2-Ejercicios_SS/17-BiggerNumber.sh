#!/bin/bash

# Autor: José María Viúdez
# 17) Indica el mayor de los números pasados por parámetro.

# 1ª FORMA
clear
source /home/juan/ASO/scripts/impColor.sh
if [ $# -lt 1 ]
then
    impColor rojo "ERROR: Numero de parametros incorrecto."
    echo -e "\nIntroduce numeros entero como parametros\n"
    exit 0
fi
mayor=0
for i in $@
do
    if [[ $i =~ ^[0-9]+$ ]] && [ $mayor -lt $i ]
    then
        mayor=$i
    fi
done

echo "El mayor de los parametros insroducidos es: $mayor"

exit 0