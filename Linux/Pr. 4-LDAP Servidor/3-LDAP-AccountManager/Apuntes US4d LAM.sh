###################################################
####-----------Instalar en el servidor-----------##
###################################################
apt install ldap-account-manager -y


###################################################
####-----------Pasos a seguir-----------###########
###################################################
#	1) Abrir http://<ip servidor>/lam
#    2) Lam Configuration --> Arriba derecha
#    3) Edit general settings
#    4) Master password --> lam
#    5) Change master password --> <Nueva contraseña>
#    6) Editar perfiles de servidor
#    7) Sufijo del arbol <dc=ies,dc=local>
#    8) Lista de usuarios válidos --> <cn=admin,dc=ies,dc=local>
#    9) Cambiar contraseña de perfil
#    10) Tipos de cuentas
#    11) Configurar usuarios y grupos
#    12) Iniciar sesión