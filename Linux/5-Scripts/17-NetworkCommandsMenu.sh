#!/bin/bash
# * Crear un script que realice las operaciones asociadas con la red indicadas en el siguiente menú:
# * (1) Ver interfaces de red, (2) Var tablas de ruta, (3) Ver tabla arp, (4) Mostrar puertos abiertos
# * y (5) Salir.

clear

getOptions() {
    echo "1) Ver interfaces de red"
    echo "2) Ver tablas de ruta"
    echo "3) Ver tabla arp"
    echo "4) Ver puertos abiertos"
    echo "5) Salir"
}

getOptions

read -p "Introduce una opción --> " option

clear
while [[ ${option} != 5 ]]
do
clear
    case ${option} in
        1)
            ip a
        ;;
        2)
            netstat -rn
        ;;
        3)
            arp -a
        ;;
        4)
            netstat -tplugn | grep LISTEN
        ;;
        *)
            echo "Opción no válida"
        ;;
    esac
    echo ""
    read -p "Pulsa cualquier tecla para continuar..." pausa

    clear

    getOptions
    read -p "Introduce una nueva opción --> " option    
done
clear
echo "Has cerrado el programa :)"
echo ""