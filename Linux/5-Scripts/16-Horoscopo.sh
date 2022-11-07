#!/bin/bash

read -p "Introduce un año de nacimiento: " year

case $(( year%12 )) in 
    0)
        echo "El horoscopo chino del año ${year} es Mono"
    ;;
    1)
        echo "El horoscopo chino del año ${year} es Gallo"
    ;;
    2)
        echo "El horoscopo chino del año ${year} es Perro"
    ;;
    3)
        echo "El horoscopo chino del año ${year} es Cerdo"
    ;;
    4)
        echo "El horoscopo chino del año ${year} es Rata"
    ;;
    5)
        echo "El horoscopo chino del año ${year} es Buey"
    ;;
    6)
        echo "El horoscopo chino del año ${year} es Tigre"
    ;;
    7)
        echo "El horoscopo chino del año ${year} es Conejo"
    ;;
    8)
        echo "El horoscopo chino del año ${year} es Dragón"
    ;;
    9)
        echo "El horoscopo chino del año ${year} es Serpiente"
    ;;
    10)
        echo "El horoscopo chino del año ${year} es Caballo"
    ;;
    11)
        echo "El horoscopo chino del año ${year} es Cabra"
    ;;
esac