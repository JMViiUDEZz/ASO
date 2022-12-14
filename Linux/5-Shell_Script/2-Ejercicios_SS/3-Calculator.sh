#!/bin/bash

# Autor: José María Viúdez
# 3) Crear un script que funcione como una calculadora para 
# sumar, restar, multiplicar y dividir.

# 1ª FORMA
#Obtención del primer número
read -p "Introduce el primer número --> " number1
#Creación de la primera expresión regular
reNumber='^[-+]?[0-9]+\.?[0-9]*$'
while ! [[ $number1 =~ $reNumber ]] ;
do
   read -p "Número inválido, introduce el primer número --> " number1;
done

#Obtención del operador matemático
read -p "Introduce \"+\", \"-\", \"*\", o \"/\" --> " operador
#Creación de expresión regular para el operador
reOperador='^[-+*/]{1}$'
while ! [[ $operador =~ $reOperador ]] ;
do
   read -p "Operador inválido, introduce \"+\", \"-\", \"*\", o \"/\" --> " operador;
done

#Obtención del segundo número
read -p "Introduce el segundo número --> " number2
# Creación de la expresión regular para el segundo número
reNumber2='^[-+]?[0-9]+\.?[0-9]*$'
while ! [[ $number2 =~ $reNumber ]] ;
do
   read -p "Número inválido, introduce el segundo número --> " number1;
done

#Cálculo con los numeros obtenidos y el operador matemático
resultado=$(($number1 $operador $number2))

clear

#Mostrar en pantalla el resultado
echo "La operación aritmética $number1 $operador $number2 es igual a $resultado"

# 2ª FORMA
clear
echo " "
echo "----------Operaciones Basicas-----------"

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
	done
exit 1