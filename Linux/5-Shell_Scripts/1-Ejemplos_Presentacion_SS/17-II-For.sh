#!/bin/bash

for i in $(ls *.sh) 
do
	if [ -x "$i"]
	then
		echo "El fichero $i es ejecutable"
	fi
done
