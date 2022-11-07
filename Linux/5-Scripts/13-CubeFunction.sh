#!/bin/bash

# Crear una función que calcule el cubo de un entero

cubo() {
    echo "El cubo de $1 es: " $(($1 ** 3))
}

read -p "Dame un número: " num
cubo $num