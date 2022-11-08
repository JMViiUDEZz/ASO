#!/bin/bash

echo "Dando permiso de ejecución a: " $1
chmod u+x $1
ls -l $1