#!/bin/bash

# Autor: José María Viúdez
# 2) Realiza un backup de la carpeta personal de un usuario utilizando el comando tar.

clear
fecha=$(date +%F_%H-%M)
backup="backup_$fecha.tgz"
tar cvzf /backups/$backup $HOME