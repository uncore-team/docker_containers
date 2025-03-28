﻿
# Docker Containers Scripts

This document contains descriptions of the `.sh` scripts developed for managing containers tailored for the [TYRELL project](https://babel.isa.uma.es/research/projects/tyrell/). Of course, there are more comprehensive and sophisticated systems for managing docker containers graphically, such as [portainer](https://www.portainer.io/), but these require a more significant learning curve compared to these scripts. Feel free to use, share or change them for your proposal.

> Our images are based on the [official NVIDIA images](https://catalog.ngc.nvidia.com/orgs/nvidia/containers/cuda), supports SSH connections, and include a XRDP server for remote graphical connections. You can customize these base images by means of a file named `packages.sh` that can be used to install your particular software. Reader can check our "builds" opening some folder of this repo. For example, `build_20_ros1` builds a image based on ´nvidia/cuda:12.2.0-base-ubuntu20.04´ with `ROS1` support.


## 1. **re-build.sh**

This Bash script automates the process of building a Docker image. It performs the following steps:

- **Checks for the existence of the `image.txt` file:** If the file does not exist, the script stops and displays an error message.

- **Reads the image name from `image.txt`:** Extracts the value of the `IMAGE_NAME` variable from the file.

- **Checks if the image already exists:** If the image exists, the script:

    - Finds and lists containers that depend on that image.

    - Prompts for confirmation to stop and remove dependent containers.

    - Prompts for confirmation to delete the existing image.

- **Builds the new image:** Uses docker build to create the image with the specified name and tag.

- **Lists available images:** Displays a list of Docker images available on the system.

### Help Option (`-h` or `--help`)

You can add a help option to the script to display the above description.

### Structure of the `image.txt` file

```
IMAGE_NAME=my_image_name
```

### How to Use

Run the script without arguments to build the Docker image:

```
./rebuild.sh
```

Use the `-h` or `--help` option to display the help message:

```
$ ./rebuild.sh -h
```

Please, refer to script [`play.sh`](#2-playsh) to start the built container.

## 2. **generate_container.sh**

This Bash script automates the setup and configuration of a Docker container for a specific project. It performs the following tasks:

- **Validates Input Arguments:** Ensures that exactly three arguments are provided: `<project name>`, `<container name>`, and `<port prefix>`.

- **Checks for Required Files:** Verifies the existence of the `image.txt` file, which contains the Docker image name.

- **Reads the Docker Image Name:** Extracts the `IMAGE_NAME` from the `image.txt` file.

- **Checks if the Docker Image Exists:** Ensures the specified Docker image exists; if not, the script exits.

- **Creates Project Directories:** Sets up the necessary directories for the project and container under `$HOME/docker/`.

- **Generates Configuration Files:** Creates a config.txt file with project-specific details (e.g., `IMAGE_NAME`, `CONTAINER_NAME`, `PORTS_PREFIX`). If a `config.txt` already exists, it renames it to `config.bak`.

- **Generates Docker Compose File:** Executes the `generate_compose.sh` script to create a `docker-compose.yml` file.

- **Copies Files to the Container:** Copies files from a source directory (`scripts/root`) to the container's home directory, skipping files that already exist in the destination.

### Help Option (-h or --help)

You can add a help option to the script to display a summary of its functionality.

### How to Use

Run the script with the required arguments to set up the Docker container:

```
./script_name.sh <project_name> <container_name> <port_prefix>
```

Use the -h or --help option to display the help message:
```
./script_name.sh -h
```

## 3. **play.sh**

