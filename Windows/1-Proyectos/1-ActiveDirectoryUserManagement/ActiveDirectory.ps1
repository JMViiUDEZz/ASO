
# Autor: Jose Maria Viudez
# Descripcion: Script con variables de entorno

DOMAIN=(Get-ADDomainController).Domain
DC=(Get-ADDomainController).DefaultPartition
ADMIN="Administrador"
PASSWORD="jose2019+"
DATE=Get-Date -Format "MM/dd/yyyy"
TIME=Get-Date -Format "HH:mm"
DATE_TIME=Get-Date -Format "MM/dd/yyyy_HH:mm"
DEFDIR=C:\1-ActiveDirectoryUserManagement
DEFIMPFILE=$DIRPS1\usersImported.ldf
DEFEXPFILE=$DIRPS1\usersExported.ldf