#!/bin/bash 

read -p "Introduzca un número 1 < x < 10: " num 

if [ "$num" -lt 10 ]
then 
	if [ "$num" -gt 1 ]
	then 
		echo "$num*$num=$(($num*$num))" 
	else 
		echo "Número fuera de rango !" 
	fi 
else 
	echo "Número fuera de rango !" 
fi
