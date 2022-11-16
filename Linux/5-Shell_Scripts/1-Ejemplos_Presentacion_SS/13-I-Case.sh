#!/bin/bash

binario=1 
    
case $binario in
	0) 
		echo "El valor es 0."
		;;
	1) 
		echo "El valor es 1."
		;;
	*) 
		echo "Valor desconocido."
esac