# Base image
FROM nvidia/cuda:12.2.0-base-ubuntu20.04

# Evitar preguntas interactivas durante la instalación
ARG DEBIAN_FRONTEND=noninteractive

# Configurar locales y zona horaria
ARG LANGUAGE=es_ES:es \
    LANG=es_ES.UTF-8 \
    LC_ALL=es_ES.UTF-8

RUN apt-get update && apt-get install -y \
    locales \
    tzdata && \
    echo "${LANG} UTF-8" > /etc/locale.gen && \
    locale-gen && \
    update-locale LANG=${LANG} LC_ALL=${LC_ALL} && \
    ln -fs /usr/share/zoneinfo/Europe/Madrid /etc/localtime && \
    dpkg-reconfigure --frontend=noninteractive tzdata && \
    # Limpieza
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Persistir los valores en el entorno de ejecución
ENV LANGUAGE=${LANGUAGE} \
    LANG=${LANG} \
    LC_ALL=${LC_ALL}

# Instalar paquetes esenciales
RUN apt-get update && apt-get install -y \
    # Herramientas básicas
    wget curl git software-properties-common \
    # Entorno gráfico
    xfce4 xfce4-goodies \
    # Servidor de escritorio remoto
    xrdp \
    # Soporte de audio
#    pulseaudio \
    # Controladores de video
    xserver-xorg-video-all \
    mesa-utils \
    libgl1-mesa-glx \
    libgl1-mesa-dri \
    # Navegador y utilidades gráficas 
    firefox \
    # Herramientas de red y SSH
    openssh-server \
    # Herramientas de sistema
    sudo dbus dbus-x11 \
    # Utilidades adicionales
    nano net-tools util-linux \
    # Utilidades de depuración
    x11-apps && \
    # Limpieza
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Instalar paquetes desarrollo
RUN apt-get update && apt-get install -y \
    build-essential \
    python-is-python3 \
    python3-dev \
    python3-opengl \
    python3-pip \
    python3-venv \
    swig \
    xvfb && \
    # Limpieza
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Copiar scripts y ficheros de configuración: X11, SSH y XRDP
COPY ./scripts/ /

# Asignar permisos de ejecución a los scripts
RUN chmod +x /*.sh

# Ejecutar el instalador de paquetes específicos (si lo hay)
RUN if [ -f /packages.sh ]; then /packages.sh; fi

# Preparar configuración de dbus y permisos
RUN mkdir -p /var/run/dbus \
    && chmod 755 /var/run/dbus \
    && dbus-uuidgen > /var/lib/dbus/machine-id

# Crear directorio de runtime
RUN mkdir -p /run/user/0 \
    && chmod 700 /run/user/0

# Crear usuario root con contraseña
RUN echo "root:test" | chpasswd

# Para facilitar la copia entre host y guest
RUN chmod 777 /root

# Exponer puertos
EXPOSE 22 80 3389

# Configurar punto de entrada (no necesario si se usa play.sh)
# ENTRYPOINT ["/init.sh"]
