# Base image
FROM nvidia/cuda:12.2.0-base-ubuntu22.04

# Avoid interactive questions during installation
ARG DEBIAN_FRONTEND=noninteractive

# Configure locales and time zone
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
    # Clean up
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Persist the values in the runtime environment
ENV LANGUAGE=${LANGUAGE} \
    LANG=${LANG} \
    LC_ALL=${LC_ALL}

# Install essential packages
RUN apt-get update && apt-get install -y \
    # Basic tools
    wget curl git software-properties-common \
    # Graphical environment
    xfce4 xfce4-goodies \
    # Remote desktop server
    xrdp \
    # Audio support
#    pulseaudio \
    # Video drivers
    xserver-xorg-video-all \
    mesa-utils \
    libgl1-mesa-glx \
    libgl1-mesa-dri \
    # Browser and graphical utilities
    firefox \
    # Network and SSH tools
    openssh-server \
    # System tools
    sudo dbus dbus-x11 \
    # Additional utilities
    nano net-tools util-linux \
    # Debugging utilities
    x11-apps && \
    # Clean up
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install development packages
RUN apt-get update && apt-get install -y \
    build-essential \
    python3-dev \
    python3-opengl \
    python3-pip \
    python3-venv \
    swig \
    xvfb && \
    # Clean up
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Copy scripts and configuration files: X11, SSH, and XRDP
COPY ./scripts/ /

# Assign execution permissions to the scripts
RUN chmod +x /*.sh

# Run the installer for specific packages (if any)
RUN if [ -f /packages.sh ]; then /packages.sh; fi

# Prepare dbus configuration and permissions
RUN mkdir -p /var/run/dbus \
    && chmod 755 /var/run/dbus \
    && dbus-uuidgen > /var/lib/dbus/machine-id

# Create runtime directory
RUN mkdir -p /run/user/0 \
    && chmod 700 /run/user/0

# Create root user with password
RUN echo "root:test" | chpasswd

# To facilitate copying between host and guest
RUN chmod 777 /root

# Expose ports
EXPOSE 22 80 3389

# Configure entry point (not needed if using play.sh)
# ENTRYPOINT ["/init.sh"]
