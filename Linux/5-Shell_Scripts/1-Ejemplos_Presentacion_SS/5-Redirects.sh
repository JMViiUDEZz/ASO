#!/bin/bash

#Redirigir la salida estándar a un fichero.
ls > salida.txt

#Redirigir la salida de errores a un fichero.
ls /root 2> error.log

#Redirigir la salida estándar y de errores a un fichero.
ls &> salida.txt

#Redirigir la entrada estándar desde un fichero.
cat < entrada.txt

#Redirigir la entrada y la salida estándar en el mismo comando.
sort < desordenado.txt > ordenado.txt
