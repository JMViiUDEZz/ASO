#!/bin/bash

clear

read -n 1 -p “Pulsa una tecla ” tecla

case $tecla in
	[a-z,A-Z]) echo “Ha introducido una letra” ;;
	[0-9]) echo “Ha introducido un numero” ;;
	*) echo “Ha introducido un carácter especial” ;;
esac
