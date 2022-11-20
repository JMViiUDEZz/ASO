#!/bin/bash

# Autor: José María Viúdez
# 18) Mueve todos los ficheros que se le pasen por parámetro,
# y para los que tengamos permisos, al directorio Backup.

# 1ª FORMA
clear
if [ $# -ne 0 ]
then
   if [ ! -d Backup ]
   then
      mkdir Backup
   fi

   for FICHERO in $*
   do
      if [ -f $FICHERO -a -w $FICHERO ]
      then
         mv $FICHERO Backup
      fi
   done
else
   echo "Error: no se han pasado ficheros"
fi

# 2ª FORMA
clear
source /home/juan/ASO/scripts/impColor.sh
if [ $# -lt 1 ]
then
    impColor rojo "ERROR: Numero de parametros incorrecto."
    echo -e "\nIntroduce algo como $0 <archivo1> <archivo2> ... para mover esos archivos al directorio /home/$USER/backup\n"
    exit 0
fi
if [ ! -d /home/$USER/Backup ]
then
    mkdir /home/$USER/Backup
fi
for i in $@
do
    if [ -f $i ] && [ -r $i ] && [ -w $i ]
    then
        mv $i /home/$USER/Backup
    fi
done
exit 0
