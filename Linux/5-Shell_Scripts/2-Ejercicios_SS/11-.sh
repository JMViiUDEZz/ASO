# 1) Escribir un script que muestre el nombre de la máquina, 
# nuestro nombre de usuario, el identificador de usuario, 
# el identificador de grupo, la ruta de nuestra carpeta personal 
# y el directorio en el que nos encontramos actualmente.

#!/bin/bash

echo "Máquina: " $HOSTNAME
echo "Usuario: " $USER
echo "Identificador de usuario (PID): " $UID
echo "Identificador de grupo: " $GROUPS
echo "Directorio personal: " $HOME
echo "Directorio actual: " $PWD
