#!/bin/bash

test -d /home/alumno && echo “El directorio existe”
[ -d /home/alumno ]
echo $?