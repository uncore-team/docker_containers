#!/bin/bash

# Variables de entorno
export XDG_RUNTIME_DIR=/run/user/0
export XDG_SESSION_TYPE=x11

# Eliminar archivos .pid para evitar conflictos
echo "Comprobando y eliminando archivos .pid antiguos si existen..."

if [ -f /var/run/dbus/pid ]; then
    echo "Eliminando /var/run/dbus/pid..."
    rm -f /var/run/dbus/pid
fi

if [ -f /var/run/sshd.pid ]; then
    echo "Eliminando /var/run/sshd.pid..."
    rm -f /var/run/sshd.pid
fi

if [ -f /var/run/xrdp/xrdp-sesman.pid ]; then
    echo "Eliminando /var/run/xrdp/xrdp-sesman.pid..."
    rm -f /var/run/xrdp/xrdp-sesman.pid
fi

if [ -f /var/run/xrdp/xrdp.pid ]; then
    echo "Eliminando /var/run/xrdp/xrdp.pid..."
    rm -f /var/run/xrdp/xrdp.pid
fi

# Iniciar DBUS
echo "Iniciando DBUS..."
service dbus start

# Iniciar SSH
echo "Iniciando SSH..."
service ssh start

# Iniciar XRDP
echo "Iniciando XRDP..."
/etc/init.d/xrdp start

# Añadir aquí otros servicios o configuraciones adicionales si lo necesitas

# Impedir el cierre del contenedor
tail -f /dev/null
