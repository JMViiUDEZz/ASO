#!/bin/bash

#Crear un array 
mascota[0]=perro
mascota[1]=gato
mascota[2]=pez
pet=( perro gato pez )

#Para extraer una entrada del array ${array[i]}
echo ${mascota[0]}
echo ${mascota[2]}

#Para extraer todos los elementos se utiliza un asterisco: 
echo ${array[*]}

#Para saber cuántos elementos hay en el array:
echo ${#array[*]} 
#(La longitud máxima de un array son 1024 elementos)

#Podemos combinar los arrays con bucles utilizando for: 
for x in ${array[*]} 
do 
	echo ${array[$x]}
done
