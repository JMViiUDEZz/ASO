#!/bin/bash

# * SCRIPT PARA BUSCAR USUARIOS Y GENERAR UN LISTADO CON SU NOMBRE, APELLIDOS, TELÉFONO Y CORREO ELECTRÓNICO * #

echo "INFORME DE USUARIOS"

echo ""

generarListado() {
    ldapsearch -xLLL -b "dc=asir,dc=local" "(objectClass=Person)" telephoneNumber mail sn givenName
}

generarListado

echo ""
