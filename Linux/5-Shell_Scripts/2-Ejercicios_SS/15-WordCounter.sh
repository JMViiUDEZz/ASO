#!/bin/bash

# Autor: José María Viúdez
# 15) Crear un script contador de palabras. Nos pide palabras y 
# nos muestra el número de palabras escritas al finalizar con la palabra “salir”.

# 1ª FORMA
clear
CONTADOR=0
PALABRA=""
clear
while [ "$PALABRA" != "salir" ]
do
    read -p "Introduzca palabra: " PALABRA
    let CONTADOR++
done
# Quitamos 1 por "salir":
let CONTADOR--
# Total de palabras:
echo "Has tecleado $CONTADOR palabras."

# 2ª FORMA
clear
i=0
word="nulo"
declare -a array
until [ $word == 'salir' ]
do  
    clear
    read -p "Dame una palabra: " palabra
    # Si se introduce mas de una palabra, se queda solo con la primera
    word=$(echo $palabra | cut  -d' ' -f1)
    # Comprueba que se ha escritto al menos una letra y no es "salir"
    if [ -n $word ] && [ $word != 'salir' ]
    then
        array[$i]="$word"
        i=$i+1
    fi
done
clear
echo ${array[*]}
echo ${#array[@]}

exit 0