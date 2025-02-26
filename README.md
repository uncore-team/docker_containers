﻿
# Docker Containers Scripts (WiP)

This document contains descriptions of the `.sh` scripts developed for managing containers tuned for the TYRELL project.

The images used in this project support NVIDIA (CUDA) cards, SSH, and the xrdp server for remote graphical connections.

## 1. **re-build.sh**

This script allows you to create (or rebuild) an image from an existing Dockerfile. The image name is read from the `image.txt` file, which must be in the same directory as the Dockerfile. Before building the new image, it checks if a Docker image with that name already exists. If so, it removes the image along with its dependent containers.

### Structure of the `image.txt` file.

```
IMAGE_NAME=my_image_name
```

### Usage Example
Running this
```
$ ./rebuild.sh
```
generates an image named `my_image_name`.
