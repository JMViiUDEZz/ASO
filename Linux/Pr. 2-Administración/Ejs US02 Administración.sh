####################################
######-----Ejercicios-----##########
####################################
#1. Desde la terminal, averigua qué líneas del archivo auth.log contienen el texto “FAILED LOGIN” y trata de encontrarles una explicación.
#	Guardan detalle del funcionamiento del sistema: 
cd /var/log
#	Daemon: syslog-ng y rsyslogd (predeterminado en Ubuntu).
cat auth.log | grep 'FAILED LOGIN'
#		Registro	Tipo de eventos
#		auth.log	Mensajes relativos a la seguridad y a las autorizaciones.
#		boot.log	Mensajes de arranque del sistema.
#		dpkg.log	Mensajes relacionados con la instalación de paquetes.
#		kern.log	Mensajes relacionados con el núcleo.
#		syslog		Mensajes relacionados con el daemon de registro.

#2. Utiliza el archivo auth.log para averiguar la fecha y hora de del último inicio de sesión del usuario alberto.
sudo tail -f -n 100 auth.log | grep 'alberto'

#3. Averigua el PID del proceso systemd.
#	Informa sobre los procesos que se están ejecutando en el sistema.
ps

#4. Descubre quién es el proceso padre de atd.
#	Muestra los procesos que se están ejecutando con una estructura de árbol.
pstree

#5. Obtener la cantidad de memoria ram y swap del sistema.
#	Información sobre el grado de ocupación de la CPU, de la memoria RAM, de la memoria de intercambio (swap) y los procesos que se están ejecutando.
top
htop
#	Ofrece información detallada sobre la memoria (tanto física como de intercambio).
free
#	Muestra el mapa de memoria de un proceso en particular.
pmap
#	Nos informa sobre la cantidad de tiempo que lleva funcionando el sistema.
#uptime
#	Informa sobre los usuarios que están en estos momentos autenticados en el sistema.
#who

#6. Averigua el estado del servicio ssh.
#	Iniciar, detener o reiniciar un servicio
#systemctl start <service>
#systemctl stop <service>
#systemctl restart <service>
systemctl status ssh

#7. Lista el estado de todos los servicios.
#	Obtener todos los servicios en ejecución o que fallan:
systemctl --state running
systemctl --state failed

#8. Obtén el nivel de ejecución actual del sistema y indica algún servicio que se active en este nivel.
#	Nivel de ejecución: Modo de operación del sistema operativo (0 = Apagado; 6 = Reinicio)
runlevel
#/etc/rc0.d hasta /etc/rc6.d y /etc/rcS.d (arranque del sistema).
cd /etc/rc5.d
#	Cada directorio contiene enlaces simbólicos a elementos del directorio
#cd /etc/init.d.

