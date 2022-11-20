#!/bin/bash

# Autor: José María Viúdez
# 16) Realiza un script donde el usuario debe adivinar un número al azar generado por la computadora.

# 1ª FORMA
clear
#Se genera un número aleatorio del 1 al 10
AZAR=$[$RANDOM%10+1]
while [ 1 ]
do
	echo –n "Ingrese un número: "
 	read NUM
	if [ $NUM –eq $AZAR ]
then
     	echo "Acertaste!"
		break
 	elif [ $NUM –gt $AZAR ]
then
     	echo "Es menor"
	else
     	echo "ES mayor"
 	fi
done

# 2ª FORMA
clear
correcto=$(($RANDOM%30+1))
num=0
cont=0
echo -e "\nAdivina un numero entre [1-30]\n"
until [ $num -eq $correcto ]
do
    read -p "Introduce el numero: " num
    if [ $num -lt $correcto ]
    then 
        echo -e "\nMayor\n"
    elif [ $num -gt $correcto ]
    then
        echo -e "\nMenor\n"
    fi
    let cont++
done
clear
echo -e "\nCorrecto!!! El numero secreto es: $correcto\n\nSolo necesitaste $cont intentos para adivinarlo.\n\nPrueba de nuevo.\n" 
exit 0