#!/usr/bin/env python3

import os
import argparse

# Función para generar el archivo docker-compose.yml
def generate_docker_compose(image_name, container_name, ports_prefix):
    docker_compose_content = f"""
services:

  {container_name}:

    labels:
      maintainer: "Vicente Arévalo"
      description: "{container_name} - Contenedor para 'vscode' - Proyecto TYRELL"

    image: {image_name}

    container_name: {container_name}

    hostname: test

    environment:
      - DISPLAY="${{DISPLAY}}" # Soporte gráfico
      - USER=root     # Usuario preconfigurado en la imagen
      - PASSWORD=test # Contraseña preconfigurada en la imagen
      - NVIDIA_VISIBLE_DEVICES=all # Exponer todas las GPUs
      - NVIDIA_DRIVER_CAPABILITIES=compute,utility,graphics # Capacidades necesarias

#      - PULSE_SERVER="unix:/run/pulse/native" # Dirección del servidor PulseAudio

    privileged: true

    cap_add:
      - SYS_ADMIN
      - SYS_RAWIO

    devices:
      - "/dev/dri:/dev/dri"

    ports:
      - "{ports_prefix}22:22"    # Puerto ssh
      - "{ports_prefix}80:80"    # Puerto http
      - "{ports_prefix}33:3389"  # Puerto xrdp (escritorio remoto)

    volumes:
      - ./home:/root  # Directorio persistente para root
      - /tmp/.X11-unix:/tmp/.X11-unix      # Compartir el entorno gráfico

#      - {XDG_RUNTIME_DIR}/pulse/native:/run/pulse/native   # Mapeo del socket de PulseAudio
#      - $HOME/.config/pulse/cookie:/root/.config/pulse:ro   # Cookie de autenticación de PulseAudio

    runtime: nvidia  # Activar soporte NVIDIA
"""

    with open("docker-compose.yml", "w") as file:
        file.write(docker_compose_content)
    print("Archivo docker-compose.yml generado con éxito.")


def main():
    # Crear el parser de argumentos
    parser = argparse.ArgumentParser(description="Generar docker-compose.yml a partir de parámetros de línea de comandos")
    
    # Agregar los argumentos para IMAGE_NAME, CONTAINER_NAME y PORTS_PREFIX
    parser.add_argument('-i', '--image_name', required=True, help="Nombre de la imagen Docker")
    parser.add_argument('-c', '--container_name', required=True, help="Nombre del contenedor Docker")
    parser.add_argument('-p', '--ports_prefix', required=True, help="Prefijo de los puertos que se mapearán")

    # Parsear los argumentos
    args = parser.parse_args()

    # Obtener los valores de los parámetros de la línea de comandos
    image_name = args.image_name
    container_name = args.container_name
    ports_prefix = args.ports_prefix

    # Generar el archivo docker-compose.yml
    generate_docker_compose(image_name, container_name, ports_prefix)

if __name__ == "__main__":
    main()
