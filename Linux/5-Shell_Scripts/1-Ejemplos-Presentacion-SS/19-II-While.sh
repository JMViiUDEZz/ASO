#!/bin/bash

read –p "Introduzca un número: " x

let sum=0

let i=1

while [ $i –le $x ]
do
	let sum=sum+i
	let i=i+1
done
echo "La suma de los primeros $x números es: $sum" 