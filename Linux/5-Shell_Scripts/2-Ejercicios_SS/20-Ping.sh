#!/bin/bash

# Autor: José María Viúdez
# 20) Script para realizar un "ping" a todas las máquinas de nuestro sistema.

# 1ª FORMA
clear
# Defino una función con todas las operaciones para poder
# llamarla recursivamente.

ejecucion() {
clear
for server in `cat mis_servers.lst`
do
echo
echo Realizo un ping a la maquina $server
echo
ping -c 2 -A $server
done

# Ahora dentro de la funcion voy a llamar a la propia
# funcion para convertir el proceso en un bucle. 
# Colocare una pausa para 
# espere 2 minitos antes de volver a ejecutarse

sleep 120 
ejecucion
}
ejecucion

# Esta llamada externa es la que se va a ejecutar la primera vez.