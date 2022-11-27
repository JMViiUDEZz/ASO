#!/bin/bash

# Autor: José María Viúdez
# 11) Escribir un script que nos pida el año de nacimiento
# y muestre el signo del zodiaco chino que eres.

# 1ª FORMA
clear
read -p "Inserta el año que naciste: " anio
let zodiaco=anio%12
case $zodiaco in
0) signo=" el Mono" ;;
1) signo=" el Gallo" ;;
2) signo=" el Perro" ;;
3) signo=" el Cerdo" ;;
4) signo=" el Rata" ;;
5) signo=" el Buey" ;;
6) signo=" el Tigre" ;;
7) signo=" el Conejo" ;;
8) signo=" el Dragon" ;;
9) signo=" el Serpiente" ;;
10) signo=" el Caballo" ;;
11) signo=" el Cabra" ;;
esac
echo "Tu signo chino es " $signo

# 2ª FORMA
clear
source /home/juan/ASO/scripts/impColor.sh
signo=" "
read -p "Dame tu fecha de nacimiento: " anio
let resto=$anio%12

case $resto in
    0) signo="Mono" ;;
    1) signo="Gallo" ;;
    2) signo="Perro" ;;
    3) signo="Cerdo" ;;
    4) signo="Rata" ;;
    5) signo="Buey" ;;
    6) signo="Tigre" ;;
    7) signo="Conejo" ;;
    8) signo="Dragon" ;;
    9) signo="Serpiente" ;;
    10) signo="Caballo" ;;
    11) signo="Cabra" ;;
esac

echo " "
echo -n "Tu signo del zodiaco chino es "
impColor verde "$signo\n"

exit 0
