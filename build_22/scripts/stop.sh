#!/bin/bash

echo "Deteniendo servicios y procesos iniciados por init.sh."

# Detener el servicio dbus
if service dbus status &>/dev/null; then
    echo "Deteniendo dbus..."
    service dbus stop
else
    echo "El servicio dbus no está en ejecución."
fi

# Detener el servicio SSH
if service ssh status &>/dev/null; then
    echo "Deteniendo SSH..."
    service ssh stop
else
    echo "El servicio SSH no está en ejecución."
fi

# Detener el servicio XRDP
if service xrdp status &>/dev/null; then
    echo "Deteniendo XRDP..."
    service xrdp stop
else
    echo "El servicio XRDP no está en ejecución."
fi
