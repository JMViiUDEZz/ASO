# * Crear un fichero con nombre copia.bkp donde se almacenen comprimidos
# * todos los ficheros que se pasan por parámetros

#!/bin/bash
if [ $# -ne 0 ]
then
    tar cvfz copia.bkp $*
else
    echo "Error: no se han pasado ficheros"
fi