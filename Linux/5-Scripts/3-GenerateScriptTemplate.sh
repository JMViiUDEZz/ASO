#!/bin/bash

read -p "Escriba la descripcion del script: " descripcion

usuario=$(whoami)

echo "#!/bin/bash" > $1
echo "#Author: ${usuario}" >> $1
echo "#Date: `date +%d-%m-%y`" >> $1
echo "#Description: $descripcion" >> $1

chmod u+x $1

nano $1