#!/bin/bash
Reg='^-?[0-9]+([.][0-9]+)?$'

read -p "Dame un número: " NUM

if [[ $NUM =~ $Reg ]]
 then
    echo $NUM " es un número"
else
    echo $NUM " no es un número"
fi