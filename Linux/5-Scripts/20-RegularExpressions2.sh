#!/bin/bash

# * 1. Buscar en el archivo /proc/meminfo la memoria total o la swap * #
    --> egrep -i "^(MemTotal|SwapTotal)" /proc/meminfo

# * 2. Buscar en el archivo /proc/cpuinfo las palabras que empiecen por p y terminan por r * #
    --> egrep "^p[a-z]*r(\t|\n|\s)" /proc/cpuinfo

# * 3. Buscar en el archivo /etc/group los grupos cuyo nombre contienen por lo menos dos "s" consecutivas * #
    --> egrep "s{2}" /etc/group

# * 4. Buscar en el archivo /etc/group los grupos cuyo nombre tenga 4 caracteres * #
    --> cut -d ":" -f 1 /etc/group | egrep "^.{4,4}$"

# * 5. Buscar los grupos con nombre de 4 o 5 caracteres * #
    --> cut -d ":" -f 1 /etc/group | egrep "^.{4,5}$"

# * 6. Buscar los grupos con al menos 8 caracteres * #
    --> cut -d ":" -f 1 /etc/group | egrep "^.{8}$"

# * 7. Buscar los grupos con máximo 3 caracteres * # 
    --> cut -d ":" -f 1 /etc/group | egrep "^.{,3}$"

# * 8. Buscar los grupos con identificador menor a 100 * # 
    --> cut -d ":" -f 3 /etc/group | egrep "^(100|[0-9]?[0-9])$"

# * 9. Buscar los grupos con identificador entre 100 y 199 * # 
    --> cut -d ":" -f 3 /etc/group | egrep "^1[0-9][0-9]$"

# * 10. Buscar los grupos con identificador mayor o igual a 1000 * # 
    --> cut -d ":" -f 3 /etc/group | egrep "^[1-9][0-9]{3}$"

# * 11. Validar un codigo postal de España que debe tener 5 dígitos y ser un número entre 01000 y 52999 * # 
    --> egrep "^([1-5][0-3][0-9]{3,3})|(01[0-9]{3,3})$"

# * 12. Validar las contraseñas de usuario, long min 8 caracteres, max 20, y se puede ($ ) * # 
    --> egrep "^([0-5][0-3][0-9]{3,3})|(01[0-9]{3,3})$"