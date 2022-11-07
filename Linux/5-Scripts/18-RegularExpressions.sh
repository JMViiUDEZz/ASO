# * 1. Buscar las líneas en las que aparece la palabra bash en el archivo /etc/passwd * #

    --> egrep "(bash){1}" /etc/passwd

# * 2. Buscar en el archivo anterior todas las líneas que empiecen por m * #

    --> egrep "^m" /etc/passwd

# * 3. Buscar en el archivo anterior todas las líneas que no empiecen por m * #

    --> egrep "^[^m]" /etc/passwd

# * 4. Buscar en el archivo anterior todas las líneas que acaban por la palabra nologin * #

    --> egrep "(nologin)$" /etc/passwd

# * 5. Buscar en el archivo anterior todas las líneas que no comienzan por g, m, r, s * #

    --> egrep "^[^gmrs]" /etc/passwd

# * 6. ¿Cuántos ficheros README hay en el subdirectorio de /usr/shell/doc ?* #

    --> ls -R /usr/share/doc | grep "README" | wc -l
    --> ls -R /usr/share/doc | grep -c "README"

# * 7. Buscar en el archivo /etc/hosts todas las líneas de red 127.0.0.0/8 * #

    --> egrep "127.0.[01].1" /etc/hosts

# * 8. Buscar en el archivo /etc/group los grupos con identificador comprendido entre 1000-1099 * #

    --> egrep "10[0-9][0-9]:" /etc/group

# * 9. Buscar en el archivo anterior todos los grupos cuyo indentificador comienza por 2 * #

    --> cut -d ":" -f 3 /etc/group | egrep "^2"

# * 10. Buscar en el archivo anterior todos los grupos cuyo nombre comience por s y finalice por d* #

    --> cut -d ":" -f 1 /etc/group | egrep "^s.*d$"