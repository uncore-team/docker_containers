#!/bin/bash

set -e  # Finalizar el script si ocurre un error

# Agregar ROS repository y clave
# echo "Agregando repositorio de ROS..."
# sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
# curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | apt-key add -

# Actualizamos los repositorios
apt update

# Instalar encabezados genéricos del kernel
echo "Instalando encabezados genéricos del kernel..."
apt install -y linux-headers-generic

# Instalar ROS Noetic Desktop-Full
# echo "Instalando ROS Noetic Desktop-Full..."
# apt install -y ros-noetic-desktop #-full

# Instalar dependencias para construir paquetes de ROS
# echo "Instalando dependencias para construir paquetes ROS..."
# apt install -y \
#     python3-rosdep \
#     python3-rosinstall \
#     python3-rosinstall-generator \
#     python3-wstool \
#     build-essential

# Inicializar rosdep
# echo "Inicializando rosdep..."
# rosdep init
# rosdep update

# Incluir aquí otros paquetes ROS
#apt install -y \

# echo "Instalación y configuración de ROS Noetic completada con éxito."
