#!/bin/bash 

read -p "Introduzca un número entre 1 < x < 10: " num

if [ "$num" -gt 1 –a "$num" -lt 10 ]
then
	echo "$num*$num=$(($num*$num))"
else
	echo "Número introducido incorrecto !"
fi
