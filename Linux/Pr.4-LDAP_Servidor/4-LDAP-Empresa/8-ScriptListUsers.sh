#!/bin/bash
# * SCRIPT PARA LISTAR USUARIOS CON NOMBRE, APELLIDOS, TELÉFONO Y CORREO  * #

#! V1

echo "INFORME DE USUARIOS"

echo ""

generarListado() {
    ldapsearch -xLLL -b "dc=ies,dc=local" "(objectClass=Person)" telephoneNumber mail sn givenName
}

generarListado

echo ""

#! V2

echo ""
echo ""

echo "INFORME DE USUARIOS"

echo ""

generarListado() {
    listadoOriginal=`ldapsearch -xLLL -b "dc=ies,dc=local" "(objectClass=Person)" telephoneNumber mail sn givenName`
    conNombre="${listadoOriginal//givenName/Nombre}"
    conApellido="${conNombre//sn/Apellidos}"
    conTelefono="${conApellido//telephoneNumber/Telefono}"
    conEmail="${conTelefono//mail/Email}"

    echo "$conEmail" > conEmail.txt

    sed '/dn:/d' conEmail.txt
}

generarListado

echo ""


