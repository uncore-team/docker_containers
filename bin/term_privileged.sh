#!/bin/bash

# Run an interactive container with the Ubuntu image
docker run -it -w /data --rm --privileged -v .:/data ubuntu bash
