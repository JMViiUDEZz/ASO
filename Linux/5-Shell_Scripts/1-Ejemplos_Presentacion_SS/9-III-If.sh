#!/bin/bash

read -p "Introduzca su nombre de usuario: " login

if [ "$login" = "$USER" ]
then
	echo "Hola, $login. Cómo está hoy?"
else
	echo "Tú no eres $login!!!"
fi
