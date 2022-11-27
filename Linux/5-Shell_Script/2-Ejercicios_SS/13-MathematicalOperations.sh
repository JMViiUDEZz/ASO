#!/bin/bash

# Autor: José María Viúdez
# 13) Escribir un script que realice una operación matemática entre dos números según las siguientes opciones del menú: 
# (a) suma, (b) resta, (c) multiplicación (d) división entera.

# 1ª FORMA
clear
echo ""
echo "Realiza una operacion matematica segun las opciones"
echo ""
echo "a. Suma"
echo "b. Resta"
echo "c. Multiplicación"
echo "d. División entera"
read -p "Seleccione la operación y pulse intro: " op
read -p "introduzca operando 1:" num1
read -p "introduzca operando 2:" num2

case $op in
a)
suma=`expr $num1 + $num2`
echo "El resultado de la suma es "$suma
;;

b)
resta=`expr $num1 - $num2`
echo "El resultado de la resta es "$resta
;;

c)
multiplicacion=`expr $num1 \* $num2`
echo "El resultado de la multiplicación es"
echo $multiplicacion
;;

d)
division=`expr $num1 / $num2`
resto=`expr $num1 % $num2`
echo "El resultado de la división es "$division
echo "Y el resto es " $resto
;;
esac

# 2ª FORMA
clear
echo "------Operaciones Basicas-------"
PS3="Elige una opcion: "
select option in Sumar Restar Dividir Multiplicar Salir
	do
		case $option in
			"Sumar")
				echo -e "\n-------Suma--------\n"
				read -p "Introduce el primer numero: " n1
				read -p "Introduce el segundo numero: " n2
				echo -e "\n$n1 + $n2 = $(($n1+$n2))\n"
			;;
			"Restar")
				echo -e "\n-------Resta--------\n"
				read -p "Introduce el primer numero: " n1
				read -p "Introduce el segundo numero: " n2
				echo -e "\n$n1 - $n2 = $(($n1-$n2))\n"
			;;
			"Dividir")
				echo -e "\n-------Division--------\n"
				read -p "Introduce el primer numero: " n1
				read -p "Introduce el segundo numero: " n2
				echo -e "\n$n1 / $n2 = $(($n1/$n2))\n"
			;;
			"Multiplicar")
				echo -e "\n-------Multiplicacion--------\n"
				read -p "Introduce el primer numero: " n1
				read -p "Introduce el segundo numero: " n2
				echo -e "\n$n1 * $n2 = $(($n1*$n2))\n"
			;;
			"Salir")
				echo -e "\nHas pulsado $option.\n"
				exit 0
			;;
			# Entrada no desada
			*)
				echo -e "\n $REPLY no es una opcion valida.\n"
			;;
		esac
		read -p "pulse una tecla para continuar ... " PAUSA
		clear
		echo "------Operaciones Basicas-------"
		echo "1) Sumar"
		echo "2) Restar"
		echo "3) Dividir"
		echo "4) Multiplicar"
		echo "5) Salir"
	done