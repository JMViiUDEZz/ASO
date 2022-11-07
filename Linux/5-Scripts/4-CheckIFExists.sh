# * EJEMPLO 1 * #

###################################################
####-----Comprobar si existe un fichero-----#######
###################################################
#!/bin/bash
if [ -f fichero ]
then
    echo "El fichero existe"
else
    echo "El fichero existe"
fi
exit 0


###################################################
####-----Comprobar si adivinan mi edad------#######
###################################################
#!/bin/bash

echo "Introduce cuál crees que es mi edad:"
read edad

if [ $edad -eq 19 ]
then
    echo "Has acertado mi edad: $edad"

else
    echo "Has fallado, vuelve a intentarlo"

fi
exit 0

###################################################
####---Comprobar si el numero es positivo---#######
###################################################
#!/bin/bash


echo "Introduce un número"
read numero

re='^[+-]?[0-9]+([.][0-9]+)?$'

while ! [[ $numero =~ $re ]]
do
    echo "Introduce un número entero"
    read numero
done

if [ $numero -lt 0 ]
then
    echo "El número: $numero es negativo"

elif [ $numero -gt 0 ]
then
    echo "El número: $numero es positivo"

else
    echo "El número es 0"

fi
exit 0

###################################################
####----Comprobar detalles de un fichero----#######
###################################################
#!/bin/bash

if [ $# -ne 1 ]
then
    echo "Introduce un solo parámetro"

else

    if [ ! -e $1 ]
    then
        echo "El fichero no existe"
    else

        if [ -r $1 ]
        then
            echo "El fichero $1 es regular"
        else
            echo "El fichero $1 no es regular"
        fi
    
        if [ -s $1 ]
        then
            echo "El fichero $1 no está vacio"
        else
            echo "El fichero $1 está vacio"
        fi

        if [ -r $1 ]
        then
            echo "El fichero $1 es legible"
        else
            echo "El fichero $1 no es legible"
        fi

        if [ -x $1 ]
        then
            echo "El fichero $1 es ejecutable"
        else
            echo "El fichero $1 no es ejecutable"
        fi

        if [ -w $1 ]
        then
            echo "El fichero $1 es modificable"
        else
            echo "El fichero $1 no es modificable"
        fi

    fi
fi



