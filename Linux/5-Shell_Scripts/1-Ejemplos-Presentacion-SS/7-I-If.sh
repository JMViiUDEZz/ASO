#!/bin/bash

clear

if `cd /tmp/prueba`
then
	echo "Pues si, es un directorio y contiene..."
	ls -l
else
	echo "Pues va a ser que no es un directorio"
fi
