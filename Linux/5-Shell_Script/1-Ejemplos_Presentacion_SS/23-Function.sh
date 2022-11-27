#!/bin/bash

function check()
{
	if [ -e "/home/$1" ]
	then
		return 0
	else
		return 1
	fi
}

read -p "Nombre del archivo: " x

if check $x
then 
	echo "$x existe !"
else 
	echo "$x no existe !"
fi 