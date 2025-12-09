#!/bin/bash

# Check if the config.txt file exists
if [ ! -f "config.txt" ]; then
  echo "config.txt file not found."
  exit 1
fi

# Read the container name from a file
IMAGE_NAME=$(grep "IMAGE_NAME" config.txt | cut -d '=' -f 2 | xargs)
CONTAINER_NAME=$(grep "CONTAINER_NAME" config.txt | cut -d '=' -f 2 | xargs)
PORTS_PREFIX=$(grep "PORTS_PREFIX" config.txt | cut -d '=' -f 2 | xargs)

# Dynamically generate the docker-compose.yml file
cat > docker-compose.yml <<EOL
services:

  ${CONTAINER_NAME}:

    labels:
      maintainer: "Vicente Arévalo"
      description: "${CONTAINER_NAME} - Container for 'vscode' - TYRELL Project"

    image: ${IMAGE_NAME}

    container_name: ${CONTAINER_NAME}

    hostname: ${CONTAINER_NAME}

    environment:
      - DISPLAY="${DISPLAY}" # Graphics support
      - USER=root     # Preconfigured user in the image
      - PASSWORD=test # Preconfigured password in the image
      - NVIDIA_VISIBLE_DEVICES=all # Expose all GPUs
      - NVIDIA_DRIVER_CAPABILITIES=compute,utility,graphics # Required capabilities

    privileged: true

    cap_add:
      - SYS_ADMIN
      - SYS_RAWIO

    devices:
      - "/dev/dri:/dev/dri"

    ports:
      - "${PORTS_PREFIX}22:22"    # SSH port
      - "${PORTS_PREFIX}80:80"    # HTTP port
      - "${PORTS_PREFIX}33:3389"  # XRDP port (remote desktop)

    volumes:
      - ./home:/root                    # Persistent directory for root
      - $HOME/datasets:/root/datasets   # Datasets directory

      - /tmp/.X11-unix:/tmp/.X11-unix      # Share graphical environment
      - /usr/lib/nvidia:/usr/lib/nvidia    # Mount NVIDIA libraries

    runtime: nvidia  # Enable NVIDIA support

    entrypoint: "/init.sh"
EOL
