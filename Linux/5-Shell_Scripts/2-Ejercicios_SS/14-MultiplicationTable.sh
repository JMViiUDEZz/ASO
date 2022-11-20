#!/bin/bash

# Autor: José María Viúdez
# 14) Realiza un script al que se le pasa un número por parámetro y muestra la tabla de multiplicar.

# 1ª FORMA
clear
echo " la tabla de multiplicar de $1 es: "
numerador=1
while [ $numerador -lt 11 ]
do
resul=`expr $1 \* $numerador`
echo "$1 x $numerador = $resul"
numerador=`expr $numerador + 1`
done

# 2ª FORMA
clear
source /home/juan/ASO/scripts/impColor.sh
if [ $# -ne 1 ]
then
    impColor rojo "ERROR: Numero de parametros incorrecto."
    echo -e "\nIntroduce un numero entero como parametro\n"
    exit 0
elif [[ ! $1 =~ ^[0-9]+$ ]]
then
    impColor rojo "ERROR: No has introducido un numero entero"
    echo -e "\nIntroduce un numero entero como parametro\n"
    exit 0
fi
echo "    Tabla del $1"
echo "---------------------"
for (( i=1; i<=10; i++ ))
do
    echo "    $i x $1 = $(($i*$1))"
done
echo -e "---------------------\n"

exit 0