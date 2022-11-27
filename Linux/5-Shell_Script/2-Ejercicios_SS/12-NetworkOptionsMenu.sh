#!/bin/bash

# Autor: José María Viúdez
# 12) Crear un script que realice las operaciones asociadas con la red indicadas en el siguiente menú: 
# (1) Ver interfaces de red, (2) Var tablas de ruta, (3) Ver tabla arp, (4) Mostrar puertos abiertos y (5) Salir.

# 1ª FORMA
clear
echo "1. Ver las interfaces de red."
echo "2. Ver las tablas de ruta"
echo "3. Ver la tabla ARP."
echo "4. Mostrar puertos abiertos."
echo "5. Salir."
echo "Elije una opción:"
read opcion
case $opcion in
1)
   ip addr list
   ;;
2)
   ip route show
   ;;
3)
   ip neighbor show
   ;;
4)
   nmap localhost
   ;;
5)
   exit
   ;;
*)
   echo "Error: Opción no válida"
   ;;
esac

# 2ª FORMA
clear
i=0
until [ $i -eq 1 ]
do
    clear
    echo "              MENU"
    echo "-----------------------------------"
    echo "      1 - Interfaces de Red"
    echo "      2 - Tablas de Ruta"
    echo "      3 - Tabla arp"
    echo "      4 - Puertos abiertos"
    echo "      5 - Salir"
    echo " "
    read -p "Elige una opcion: " opt
    echo " "
    case $opt in 
        1) ip addr list ;;
        2) ip route show ;;
        3) ip neighbor show;;
        4) netmap localhost ;;
        5) i=1 ;;
        *) echo -e "\nOpcion incorrecta\n" ;;
    esac
    echo " "
    read -p "Pulsa una tecla para continuar ..." PAUSA
done 

exit 0