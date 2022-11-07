#!/bin/bash
# * AWK allow us to process text files

########## * E.X. alumnos.txt
# * Juan;Almería;950-111-555;8
# * Luis;Cádiz;950-111-555;8
# * Alberto;Córdoba;950-111-555;8
# * Ana;Granada;950-111-555;8
# * Ana;Huelva;950-111-555;8
# * Valeria;Jaén;950-111-555;8
########## * END E.X.

# Separadores con -F
awk -F';' '{print $1}' alumnos.txt # Outputs the name
awk -F';' '{print $2}' alumnos.txt # Outputs the state
awk -F';' '{print $3}' alumnos.txt # Outputs the number
awk -F';' '{print $4}' alumnos.txt # Outputs the mark

awk -F';' '{print "La nota de " $1 " es " $4}' alumnos.txt # Outputs with extra text

# Regular Expressions
awk -F';' '/^A/ {print "La nota de " $1 " es " $4}' alumnos.txt # Outputs just those that start with A
awk -F';' '$4 >= 5 {print "La nota de " $1 " es " $4}' alumnos.txt # Outputs just those who have marks >= 5

awk -F';' '$4 < 5 && $1=="Alberto" {print "La nota de " $1 " es " $4}' alumnos.txt # Outputs just those who have marks >= 5

