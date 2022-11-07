#!/bin/bash
# * 1. Modifica cualquier 9 del primer dígito del teléfono por un 6 * #
    --> sed '/^.*;.*;9/ s/9/6/' alumnos.txt

# * 2. Cambia el carácter delimitador de campo ';' por un espacio en blanco * #
    --> sed 's/;/ /g' alumnos.txt

# * 3. Modifica el teéfono de Valeria por 953-111-222 * #
    --> sed '/^Valeria/ s/...-...-.../953-111-222/' alumnos.txt

# * 4. A partir de la línea 2 cambia toda la provincia Sevilla por Cádiz * #
    --> sed '2,$ s/Sevilla/Cádiz/' alumnos.txt

# * 5. Borra la línea 6 del fichero * #
    --> sed '6 d' alumnos.txt

# * 6. Borra cualquier línea en la que aparezca la provincia Huelva * #
    --> sed '/Huelva/ d' alumnos.txt

# * 7. Cambia Granada por Córdoba entre las líneas Luis y Valeria * #
    --> sed '/^Luis/,/^Valeria/ s/Granada/Córdoba/' alumnos.txt

# * 8. Añade después de la linea 5 la alumna Marta de Granada con teléfono 958-522-333 y nota media 9 * #
    --> sed '5a\Marta;Granada;958-522-333;9' alumnos.txt

# * 9. Cambia la línea 2 por el alumno Pepe de Granada con teléfono 958-112-455 y nota media 6 * #
    --> sed '2c\Pepe;Granada;958-112-455;6' alumnos.txt

# * 10. Cambia la alumna Valeria 2 por la alumna Paqui de Cádiz con teléfono 956-988-755 y nota media 8 * #
    --> sed '/^Valeria/c\Paqui;Cádiz;956-988-755;8' alumnos.txt
