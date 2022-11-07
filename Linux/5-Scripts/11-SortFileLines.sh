# * Script que al pasarle como parámetro un archivo de texto ordene las líneas
# * de texto ascendentemente al pasarle una 'A' como segundo parámetro o 
# * descendentemente al pasarle una 'Z' como segundo parámetro

#!/bin/bash
if [ $# -eq 2 ]
 then
    if [ -f $1 ]
        if [ $2 = 'A' ]
         then
            cat $1
        elif [ $2 = 'Z' ]
         then
            tail $1
        else
            echo "Error, el segundo parámetro debe ser una A o una Z"
        fi
    else
        echo "Error, el primer parámetro no se corresponde con un archivo existente" 
    fi
else
    echo "Error, el número de parámetros debe ser 2"
fi