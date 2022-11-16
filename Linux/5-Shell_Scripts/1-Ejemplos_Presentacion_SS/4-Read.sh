#!/bin/bash

read -p "Nombre de fichero a borrar: " fichero 

#Borra el fichero pidiendo confirmación (-i)
rm -i $fichero 

echo "Fichero $fichero borrado!"